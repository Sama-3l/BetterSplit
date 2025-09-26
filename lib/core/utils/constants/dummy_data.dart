import 'dart:math';
import 'package:bettersplitapp/features/home/domain/entities/user.dart';
import 'package:bettersplitapp/features/payment_screen/domain/entities/payment.dart';
import 'package:bettersplitapp/features/payment_screen/domain/entities/user_share.dart';
import 'package:bettersplitapp/features/trip_screen/domain/entities/ledger.dart';
import 'package:bettersplitapp/features/trip_screen/domain/entities/trip.dart';

// Utility: random date between two dates
DateTime randomDate(DateTime start, DateTime end) {
  final rand = Random();
  final s = start.isBefore(end) ? start : end;
  final e = end.isAfter(start) ? end : start;

  final diff = e.millisecondsSinceEpoch - s.millisecondsSinceEpoch;
  if (diff <= 0) return s;

  // Use nextDouble to avoid upper bound issues
  final offset = (rand.nextDouble() * diff).floor();
  return DateTime.fromMillisecondsSinceEpoch(s.millisecondsSinceEpoch + offset);
}

// Make shares like in Swift
List<UserShareEntity> makeShares({
  required UserEntity payer,
  required List<UserEntity> friends,
  required double total,
}) {
  final allUsers = [payer, ...friends];
  final perPerson = total / allUsers.length;
  return allUsers
      .map((u) => UserShareEntity(user: u, amount: perPerson))
      .toList();
}

// USERS
final dummyUser = UserEntity(
  id: "1",
  name: "Raghv",
  userName: "Raghvendra Mishra",
  number: "6386291080",
  upiID: "raghvendramishra2002@okaxis",
  currentUser: true,
);

final friend1 = UserEntity(
  id: "1",
  name: "Harsh",
  userName: "Harshu",
  number: "9829309123",
  upiID: "aduiabwdbiawd",
);
final friend2 = UserEntity(
  id: "1",
  name: "Pushkar",
  userName: "PussyCat",
  number: "9829309132",
  upiID: "aduiabwdbiawd",
);
final friend3 = UserEntity(
  id: "1",
  name: "Rishi",
  userName: "Srivastave",
  number: "9829390123",
  upiID: "aduiabwdbiawd",
);
final friend4 = UserEntity(
  id: "1",
  name: "Yusuf",
  userName: "Muscle-man",
  number: "9823909123",
  upiID: "aduiabwdbiawd",
);
final friend5 = UserEntity(
  id: "1",
  name: "Avinash",
  userName: "Avi",
  number: "8929309123",
  upiID: "aduiabwdbiawd",
);
final friend6 = UserEntity(
  id: "1",
  name: "Vaishnavi",
  userName: "Vaish",
  number: "9822309123",
  upiID: "aduiabwdbiawd",
);
final friend7 = UserEntity(
  id: "1",
  name: "Shambhavi",
  userName: "Shagun",
  number: "9829301123",
  upiID: "aduiabwdbiawd",
);

// DATE RANGE
final start = DateTime(2025, 1, 1);
final end = DateTime(2025, 12, 31);

// Example payment
PaymentEntity samplePayment(UserEntity payer) => PaymentEntity(
  id: "2",
  payer: payer,
  shares: makeShares(payer: payer, friends: [friend3], total: 1234.0),
  date: randomDate(start, end),
  title: "Mc Donald's",
  amount: 1234.0,
  settled: false,
);

// LEDGER
final sampleLedger = [
  LedgerEntity(id: "2", payer: friend2, friend: friend4, amount: 200),
  LedgerEntity(id: "2", payer: friend1, friend: friend4, amount: 200),
  LedgerEntity(id: "2", payer: friend3, friend: friend4, amount: 200),
];

// TRIPS
final trip1 = TripEntity(
  id: "",
  title: "Pondicherry Diaries",
  startDate: start,
  endDate: end,
  users: [dummyUser, friend1, friend2, friend3, friend4],
  payments: [
    samplePayment(dummyUser),
    samplePayment(friend2),
    PaymentEntity(
      id: "2",
      payer: friend1,
      shares: makeShares(payer: friend1, friends: [dummyUser], total: 12342.0),
      date: randomDate(start, end),
      title: "Mc Donald's",
      amount: 12342.0,
      settled: true,
    ),
    PaymentEntity(
      id: "2",
      payer: friend4,
      shares: makeShares(payer: friend4, friends: [dummyUser], total: 134.0),
      date: randomDate(start, end),
      title: "Mc Donald's",
      amount: 134.0,
      settled: false,
    ),
  ],
  ledger: sampleLedger,
);

final trips = [trip1]; // replicate trip1 as trip2, trip3, trip4 if needed
