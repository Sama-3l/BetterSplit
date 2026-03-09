import 'package:bettersplitapp/core/utils/constants/methods.dart';
import 'package:bettersplitapp/features/home/domain/entities/user.dart';
import 'package:bettersplitapp/features/payment_screen/domain/entities/user_share.dart';
import 'package:bettersplitapp/features/trip_screen/domain/entities/ledger.dart';
import 'package:bettersplitapp/features/trip_screen/domain/entities/trip.dart';
import 'package:flutter_test/flutter_test.dart';

// Import your actual paths
// import 'package:your_app/domain/entities/trip_entity.dart';
// import 'package:your_app/domain/entities/user_entity.dart';
// import 'package:your_app/domain/entities/payment_entity.dart';
// import 'package:your_app/domain/entities/ledger_entity.dart';
// import 'package:your_app/domain/entities/user_share_entity.dart';
// import 'package:your_app/domain/usecases/add_payment.dart'; // wherever addPayment lives

// ─── Helpers ────────────────────────────────────────────────────────────────

UserEntity makeUser(String name, String number) => UserEntity(
  id: number,
  name: name,
  userName: name.toLowerCase(),
  number: number,
  upiID: '$name@upi',
);

TripEntity makeTrip(List<UserEntity> users) => TripEntity(
  id: 'trip-1',
  title: 'Test Trip',
  startDate: DateTime(2024, 1, 1),
  endDate: DateTime(2024, 1, 10),
  users: users,
  payments: const [],
  ledger: const [],
  netBalance: const {},
);

UserShareEntity share(UserEntity user, double amount, {bool included = true}) =>
    UserShareEntity(user: user, amount: amount, isIncluded: included);

// Checks that the sum of all netBalance values is (close to) 0
void expectBalancedNetBalance(Map<String, double> netBalance) {
  final total = netBalance.values.fold(0.0, (a, b) => a + b);
  expect(
    total.abs(),
    lessThan(1e-9),
    reason: 'Net balance across all users should sum to 0',
  );
}

// Checks that the ledger settlements sum correctly
void expectLedgerSettlesBalance(
  Map<String, double> netBalance,
  List<LedgerEntity> ledger,
) {
  final settled = <String, double>{};
  for (final entry in ledger) {
    // payer is paying off their debt, balance moves toward 0 (increases)
    settled[entry.payer.number] =
        (settled[entry.payer.number] ?? 0) + entry.amount;
    // friend is receiving, their credit reduces toward 0 (decreases)
    settled[entry.friend.number] =
        (settled[entry.friend.number] ?? 0) - entry.amount;
  }
  for (final key in netBalance.keys) {
    final balance = netBalance[key] ?? 0;
    final settlement = settled[key] ?? 0;
    // After settlement, balance + settlement should equal 0
    expect(
      (balance + settlement).abs(),
      lessThan(1e-9),
      reason:
          'User $key has balance $balance but ledger only settles $settlement',
    );
  }
}

// ─── Tests ───────────────────────────────────────────────────────────────────

void main() {
  late UserEntity alan, christy, doug, tony;
  late TripEntity trip;

  setUp(() {
    alan = makeUser('Alan', '0001');
    christy = makeUser('Christy', '0002');
    doug = makeUser('Doug', '0003');
    tony = makeUser('Tony', '0004');
    trip = makeTrip([alan, christy, doug, tony]);
  });

  // ── Test 1: Equal split among all 4 users ──────────────────────────────────
  test('Equal split: Alan pays 300, all 4 share 75 each', () {
    final result = Methods.addPayment(
      title: 'Dinner',
      trip: trip,
      paidByUser: alan,
      amount: 300,
      userShares: [
        share(alan, 75),
        share(christy, 75),
        share(doug, 75),
        share(tony, 75),
      ],
    );

    expect(result.netBalance['0001'], closeTo(225, 1e-9)); // paid 300, owes 75
    expect(result.netBalance['0002'], closeTo(-75, 1e-9));
    expect(result.netBalance['0003'], closeTo(-75, 1e-9));
    expect(result.netBalance['0004'], closeTo(-75, 1e-9));

    expectBalancedNetBalance(result.netBalance);
    expect(result.payments.length, 1);

    // Ledger: 3 entries, each owing 75 to Alan
    expect(result.ledger.length, 3);
    for (final entry in result.ledger) {
      expect(entry.friend.number, '0001'); // all pay Alan
      expect(entry.amount, closeTo(75, 1e-9));
    }
  });

  // ── Test 2: Unequal split, one user excluded ───────────────────────────────
  test('Unequal split: Alan pays 300, Tony excluded', () {
    // Alan-100, Christy-50, Doug-50, Tony excluded (as per your example)
    final result = Methods.addPayment(
      title: 'Lunch',
      trip: trip,
      paidByUser: alan,
      amount: 200,
      userShares: [
        share(alan, 100),
        share(christy, 50),
        share(doug, 50),
        share(tony, 0, included: false),
      ],
    );

    expect(result.netBalance['0001'], closeTo(100, 1e-9)); // 200 - 100
    expect(result.netBalance['0002'], closeTo(-50, 1e-9));
    expect(result.netBalance['0003'], closeTo(-50, 1e-9));
    expect(result.netBalance['0004'] ?? 0, closeTo(0, 1e-9));

    expectBalancedNetBalance(result.netBalance);

    // Ledger: Christy owes Alan 50, Doug owes Alan 50
    expect(result.ledger.length, 2);
    for (final entry in result.ledger) {
      expect(entry.friend.number, '0001');
      expect(entry.amount, closeTo(50, 1e-9));
    }
  });

  // ── Test 3: Multiple payments accumulate correctly ─────────────────────────
  test('Multiple payments: balances accumulate correctly', () {
    // Payment 1: Alan pays 300, equal split
    final trip1 = Methods.addPayment(
      title: 'Payment 1',
      trip: trip,
      paidByUser: alan,
      amount: 300,
      userShares: [
        share(alan, 75),
        share(christy, 75),
        share(doug, 75),
        share(tony, 75),
      ],
    );

    // Payment 2: Christy pays 200, equal split
    final trip2 = Methods.addPayment(
      title: 'Payment 2',
      trip: trip1,
      paidByUser: christy,
      amount: 200,
      userShares: [
        share(alan, 50),
        share(christy, 50),
        share(doug, 50),
        share(tony, 50),
      ],
    );

    // Alan: +300 - 75 - 50 = +175
    expect(trip2.netBalance['0001'], closeTo(175, 1e-9));
    // Christy: +200 - 75 - 50 = +75
    expect(trip2.netBalance['0002'], closeTo(75, 1e-9));
    // Doug: -75 - 50 = -125
    expect(trip2.netBalance['0003'], closeTo(-125, 1e-9));
    // Tony: -75 - 50 = -125
    expect(trip2.netBalance['0004'], closeTo(-125, 1e-9));

    expectBalancedNetBalance(trip2.netBalance);
    expect(trip2.payments.length, 2);
    expectLedgerSettlesBalance(trip2.netBalance, trip2.ledger);
  });

  // ── Test 4: Delete a payment reverses balances ─────────────────────────────
  test('Delete payment: balances revert to original', () {
    final trip1 = Methods.addPayment(
      title: 'Dinner',
      trip: trip,
      paidByUser: alan,
      amount: 300,
      userShares: [
        share(alan, 75),
        share(christy, 75),
        share(doug, 75),
        share(tony, 75),
      ],
    );

    final paymentToDelete = trip1.payments.first;

    final trip2 = Methods.addPayment(
      title: 'Dinner',
      trip: trip1,
      paidByUser: alan,
      amount: 300,
      userShares: [
        share(alan, 75),
        share(christy, 75),
        share(doug, 75),
        share(tony, 75),
      ],
      currPayment: paymentToDelete,
      delete: true,
    );

    // All balances should be back to 0
    for (final value in trip2.netBalance.values) {
      expect(
        value.abs(),
        lessThan(1e-9),
        reason: 'All balances should be 0 after deleting the only payment',
      );
    }

    expect(trip2.payments.length, 0);
    expect(trip2.ledger.length, 0);
  });

  // ── Test 5: Payer is not in the split ─────────────────────────────────────
  test('Payer not included in split: full amount owed back', () {
    // Alan pays 300 but only Christy, Doug, Tony split it
    final result = Methods.addPayment(
      title: 'Hotel',
      trip: trip,
      paidByUser: alan,
      amount: 300,
      userShares: [
        share(alan, 0, included: false),
        share(christy, 100),
        share(doug, 100),
        share(tony, 100),
      ],
    );

    expect(result.netBalance['0001'], closeTo(300, 1e-9)); // paid all, owes 0
    expect(result.netBalance['0002'], closeTo(-100, 1e-9));
    expect(result.netBalance['0003'], closeTo(-100, 1e-9));
    expect(result.netBalance['0004'], closeTo(-100, 1e-9));

    expectBalancedNetBalance(result.netBalance);
    expect(result.ledger.length, 3);
  });

  // ── Test 6: Ledger minimizes transactions ──────────────────────────────────
  test('Ledger minimizes number of transactions', () {
    // Alan pays 400, Christy pays 200
    // After settling: Doug and Tony owe money
    // Optimal: Doug pays Alan, Tony pays Alan (or Christy) — not both
    final trip1 = Methods.addPayment(
      title: 'Payment 1',
      trip: trip,
      paidByUser: alan,
      amount: 400,
      userShares: [
        share(alan, 100),
        share(christy, 100),
        share(doug, 100),
        share(tony, 100),
      ],
    );

    final trip2 = Methods.addPayment(
      title: 'Payment 2',
      trip: trip1,
      paidByUser: christy,
      amount: 200,
      userShares: [
        share(alan, 50),
        share(christy, 50),
        share(doug, 50),
        share(tony, 50),
      ],
    );

    // Alan: +400-100-50 = +250, Christy: +200-100-50 = +50
    // Doug: -100-50 = -150, Tony: -100-50 = -150
    // Minimum transactions: Doug->Alan 150, Tony->Alan 100, Tony->Christy 50
    expect(
      trip2.ledger.length,
      lessThanOrEqualTo(3),
      reason: 'Should settle in at most 3 transactions',
    );

    expectBalancedNetBalance(trip2.netBalance);
    expectLedgerSettlesBalance(trip2.netBalance, trip2.ledger);
  });

  // ── Test 7: Single user trip (edge case) ───────────────────────────────────
  test('Single user: no ledger entries generated', () {
    final soloTrip = makeTrip([alan]);
    final result = Methods.addPayment(
      title: 'Solo expense',
      trip: soloTrip,
      paidByUser: alan,
      amount: 100,
      userShares: [share(alan, 100)],
    );

    expect(result.netBalance['0001'], closeTo(0, 1e-9));
    expect(result.ledger.length, 0);
  });

  // ── Test 8: Floating point precision ──────────────────────────────────────
  test('Floating point: 100 split among 3 users', () {
    final trip3 = makeTrip([alan, christy, doug]);
    final perPerson = 100 / 3; // 33.333...

    final result = Methods.addPayment(
      title: 'Snacks',
      trip: trip3,
      paidByUser: alan,
      amount: 100,
      userShares: [
        share(alan, perPerson),
        share(christy, perPerson),
        share(doug, perPerson),
      ],
    );

    expectBalancedNetBalance(result.netBalance);
    expectLedgerSettlesBalance(result.netBalance, result.ledger);

    // Alan should be owed ~66.67
    expect(result.netBalance['0001'], closeTo(66.67, 0.01));
  });

  // ── Test 9: Complex scenario with 6 payments ──────────────────────────────
  test('Complex: 6 payments with varied splits and payers', () {
    // Payment 1: Alan pays 600, equal split among all 4
    // Alan: +600 - 150 = +450, Christy: -150, Doug: -150, Tony: -150
    final trip1 = Methods.addPayment(
      title: 'Flight tickets',
      trip: trip,
      paidByUser: alan,
      amount: 600,
      userShares: [
        share(alan, 150),
        share(christy, 150),
        share(doug, 150),
        share(tony, 150),
      ],
    );

    // Payment 2: Christy pays 400, Doug and Tony excluded
    // Alan: -200, Christy: +400 - 200 = +200, Doug: 0, Tony: 0
    final trip2 = Methods.addPayment(
      title: 'Hotel',
      trip: trip1,
      paidByUser: christy,
      amount: 400,
      userShares: [
        share(alan, 200),
        share(christy, 200),
        share(doug, 0, included: false),
        share(tony, 0, included: false),
      ],
    );

    // Payment 3: Doug pays 300, equal split among all 4
    // Alan: -75, Christy: -75, Doug: +300 - 75 = +225, Tony: -75
    final trip3 = Methods.addPayment(
      title: 'Car rental',
      trip: trip2,
      paidByUser: doug,
      amount: 300,
      userShares: [
        share(alan, 75),
        share(christy, 75),
        share(doug, 75),
        share(tony, 75),
      ],
    );

    // Payment 4: Tony pays 200, only Tony and Alan split it
    // Alan: -100, Christy: 0, Doug: 0, Tony: +200 - 100 = +100
    final trip4 = Methods.addPayment(
      title: 'Groceries',
      trip: trip3,
      paidByUser: tony,
      amount: 200,
      userShares: [
        share(alan, 100),
        share(christy, 0, included: false),
        share(doug, 0, included: false),
        share(tony, 100),
      ],
    );

    // Payment 5: Alan pays 120, equal split among all 4
    // Alan: +120 - 30 = +90, Christy: -30, Doug: -30, Tony: -30
    final trip5 = Methods.addPayment(
      title: 'Museum tickets',
      trip: trip4,
      paidByUser: alan,
      amount: 120,
      userShares: [
        share(alan, 30),
        share(christy, 30),
        share(doug, 30),
        share(tony, 30),
      ],
    );

    // Payment 6: Christy pays 180, unequal split
    // Alan: -40, Christy: +180 - 80 = +100, Doug: -60, Tony: 0 excluded
    final trip6 = Methods.addPayment(
      title: 'Dinner',
      trip: trip5,
      paidByUser: christy,
      amount: 180,
      userShares: [
        share(alan, 40),
        share(christy, 80),
        share(doug, 60),
        share(tony, 0, included: false),
      ],
    );

    // ── Running totals ──
    // Alan:    +450 - 200 - 75 - 100 + 90 - 40  = +125
    // Christy: -150 + 200 - 75       - 30 + 100 = +45
    // Doug:    -150       + 225      - 30 - 60  = -15
    // Tony:    -150            + 100 - 30       = -80
    // Sum: 125 + 45 - 15 - 80 = 75 ❌ — wait let me recount
    // (Rechecked below — sum must be 0)

    expect(trip6.netBalance['0001'], closeTo(125, 1e-9)); // Alan
    expect(trip6.netBalance['0002'], closeTo(45, 1e-9)); // Christy
    expect(trip6.netBalance['0003'], closeTo(-15, 1e-9)); // Doug
    expect(trip6.netBalance['0004'], closeTo(-155, 1e-9)); // Tony

    // Core invariants
    expectBalancedNetBalance(trip6.netBalance);
    expectLedgerSettlesBalance(trip6.netBalance, trip6.ledger);

    expect(trip6.payments.length, 6);

    // With 2 creditors (Alan +125, Christy +45) and 2 debtors
    // minimum transactions should be at most 3
    expect(trip6.ledger.length, lessThanOrEqualTo(3));
  });
}
