import 'package:bettersplitapp/core/utils/constants/currency_formatter.dart';
import 'package:bettersplitapp/core/utils/constants/enums.dart';
import 'package:bettersplitapp/features/home/domain/entities/user.dart';
import 'package:bettersplitapp/features/home/domain/models/local/user_model_local.dart';
import 'package:bettersplitapp/features/payment_screen/domain/entities/payment.dart';
import 'package:bettersplitapp/features/payment_screen/domain/entities/user_share.dart';
import 'package:bettersplitapp/features/payment_screen/presentation/blocs/cubits/AddPaymentCubit/add_payment_cubit.dart';
import 'package:bettersplitapp/features/trip_screen/domain/entities/ledger.dart';
import 'package:bettersplitapp/features/trip_screen/domain/entities/trip.dart';
import 'package:bettersplitapp/features/trip_screen/domain/models/local/trip_model_local.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Methods {
  static String formatAmount(double amount, String currency) {
    return amount.toStringAsFixed(2);
  }

  static Color interpolate(Color from, Color to, double t) {
    return Color.lerp(from, to, t.clamp(0.0, 1.0))!;
  }

  static String daySuffix(int day) {
    if (day >= 11 && day <= 13) return "th";
    switch (day % 10) {
      case 1:
        return "st";
      case 2:
        return "nd";
      case 3:
        return "rd";
      default:
        return "th";
    }
  }

  static String formatDateRange(
    DateTime startDate,
    DateTime? endDate,
    bool goingOn,
  ) {
    final startDay = startDate.day;
    final startMonthStr = DateFormat(
      'MMM',
    ).format(startDate); // import intl: ^0.18.0
    final startSuffix = daySuffix(startDay);
    final startStr = "$startMonthStr $startDay$startSuffix";

    if (goingOn) {
      return "$startStr – Present";
    } else if (endDate != null) {
      final endDay = endDate.day;
      final endMonthStr = DateFormat('MMM').format(endDate);
      final endSuffix = daySuffix(endDay);
      final endStr = "$endMonthStr $endDay$endSuffix";
      final year = endDate.year;
      return "$startStr – $endStr, $year";
    } else {
      return startStr;
    }
  }

  static Map<String, String> splitNumberParts(String rawNumber) {
    String number = rawNumber.trim();
    String countryCode = '';
    String mainNumber = number;

    // 1️⃣ Detect if starts with '+' and extract code by length
    if (number.startsWith('+') && number.length > 10) {
      // length of country code portion = total length - 10 digits
      final codeLength = number.length - 10;
      countryCode = number.substring(0, codeLength); // includes '+'
      mainNumber = number.substring(codeLength); // last 10 digits
    }

    // 2️⃣ Split main number
    final part1 = mainNumber.length >= 4
        ? mainNumber.substring(0, 4)
        : mainNumber;
    final part2 = mainNumber.length >= 7 ? mainNumber.substring(4, 7) : '';
    final part3 = mainNumber.length >= 10 ? mainNumber.substring(7, 10) : '';

    return {
      'countryCode': countryCode,
      'part1': part1,
      'part2': part2,
      'part3': part3,
    };
  }

  /// convert list of users to initials for HorizontalFriendsList
  static List<String> getInitialsList(List<UserEntity> users) {
    return users.map((u) {
      final name = u.userName;
      if (name.isEmpty) return '';
      final parts = name.split(' ');
      if (parts.length == 1) return parts.first[0];
      return parts.first[0] + (parts.last.isNotEmpty ? parts.last[0] : "");
    }).toList();
  }

  static double safeParse(String s) {
    final cleaned = s.replaceAll(RegExp(r'[^0-9.]'), '').trim();
    return cleaned.isEmpty ? 0.0 : double.tryParse(cleaned) ?? 0.0;
  }

  static void updateTotalFromFriends(
    AddPaymentState state,
    Map<String, TextEditingController> controllers,
    TextEditingController amountController,
  ) {
    double total = 0;
    if (state.selectedSplitOption == SplitType.unequally) {
      for (final controller in controllers.values) {
        total += double.tryParse(controller.text.replaceAll(',', '')) ?? 0;
      }
      // use your formatter on the computed total
      final formatter = CurrencyInputFormatter(state.selectedCurrency);
      final newValue = formatter.formatEditUpdate(
        TextEditingValue(text: total.toStringAsFixed(2)),
        TextEditingValue(text: total.toStringAsFixed(2)),
      );

      amountController.value = newValue;
    }
    if (state.selectedSplitOption == SplitType.unequally) {
      for (int i = 0; i < controllers.length; i++) {
        state.userShares[i].amount =
            double.tryParse(
              controllers.values.toList()[i].text.replaceAll(',', ''),
            ) ??
            0;
      }
    } else if (state.selectedSplitOption == SplitType.percentage) {
      for (int i = 0; i < controllers.length; i++) {
        state.userShares[i].amount =
            (double.tryParse(
                  controllers.values.toList()[i].text.replaceAll(',', ''),
                ) ??
                0) *
            Methods.safeParse(state.amount) *
            0.01;
        state.userShares[i].percentage =
            (double.tryParse(
              controllers.values.toList()[i].text.replaceAll(',', ''),
            ) ??
            0);
      }
    }
  }

  static TripEntity addPayment({
    required String title,
    required TripEntity trip,
    required UserEntity paidByUser,
    required double amount,
    required List<UserShareEntity> userShares,
    PaymentEntity? currPayment,
    bool delete = false,
  }) {
    final netBalance = Map<String, double>.from(trip.netBalance);

    if (delete) {
      netBalance[paidByUser.number] =
          (netBalance[paidByUser.number] ?? 0) - amount;
      // Methods.safeParse(state.amount);

      for (final share in userShares) {
        if (share.isIncluded) {
          netBalance[share.user.number] =
              (netBalance[share.user.number] ?? 0) + (share.amount ?? 0);
        }
      }
    } else {
      netBalance[paidByUser.number] =
          (netBalance[paidByUser.number] ?? 0) + amount;

      for (final share in userShares) {
        if (share.isIncluded) {
          netBalance[share.user.number] =
              (netBalance[share.user.number] ?? 0) - (share.amount ?? 0);
        }
      }
    }

    final sortedByValueAscending =
        netBalance.entries.map((e) => {'key': e.key, 'value': e.value}).toList()
          ..sort(
            (a, b) => (a['value'] as double).compareTo(b['value'] as double),
          );

    print(sortedByValueAscending);
    print("HERE\n\n\n$netBalance");

    final userLookup = {for (var u in trip.users) u.number: u};

    int left = 0;
    int right = sortedByValueAscending.length - 1;

    trip.ledger.clear();
    // List<LedgerEntity> l = [];

    while (left < right) {
      double debit = -((sortedByValueAscending[left]['value']) as double);
      double credit = (sortedByValueAscending[right]['value']) as double;
      double settlement = debit < credit ? debit : credit;

      sortedByValueAscending[left]['value'] =
          (sortedByValueAscending[left]['value'] as double) + settlement;
      sortedByValueAscending[right]['value'] =
          (sortedByValueAscending[right]['value'] as double) - settlement;

      if (settlement > 0) {
        final payer = userLookup[sortedByValueAscending[left]['key'] as String];
        final receiver =
            userLookup[sortedByValueAscending[right]['key'] as String];

        if (payer != null && receiver != null) {
          final ledgerEntry = LedgerEntity(
            id: Uuid().v4(),
            trip: trip,
            payer: payer,
            friend: receiver,
            amount: settlement,
          );
          // l.add(ledgerEntry);
          trip.ledger.add(ledgerEntry);
        }
      }

      if (((sortedByValueAscending[left]['value']) as double).abs() < 1e-9) {
        left++;
      }
      if (((sortedByValueAscending[right]['value']) as double).abs() < 1e-9) {
        right--;
      }
    }

    // print("\n");
    // print(l.map((e) => "${e.payer.name} -> ${e.friend.name} : ${e.amount}"));
    // print(netBalance);
    // print("\n");

    if (delete) {
      trip.payments.removeWhere((e) => e.id == currPayment!.id);
    } else {
      final payment = PaymentEntity(
        id: Uuid().v4(),
        title: title,
        amount: amount,
        payer: paidByUser,
        shares: userShares,
        date: DateTime.now(),
        settled: false,
      );
      trip.payments.add(payment);
    }

    return trip.copyWith(netBalance: netBalance);
  }

  static double getExpenditure(List<TripEntity> entities, UserEntity currUser) {
    double amount = 0;
    for (var trip in entities) {
      amount += trip.netBalance[currUser.number]!;
    }
    return amount;
  }
}

class TestingMethods {
  static void deleteAllTrips() async {
    final box = await Hive.openBox<TripModel>("tripBox");
    try {
      box.clear();
    } catch (_) {}
  }

  static void deleteAllNonCurrentUsers() async {
    final box = await Hive.openBox<UserModel>("userBox");
    try {
      box.deleteAll(box.values.where((e) => !e.currentUser).map((e) => e.id));
    } catch (_) {}
  }

  static getAllUsers() async {
    final box = await Hive.openBox<UserModel>('userBox');
    try {
      print(box.values.map((e) => e.name));
    } catch (_) {}
  }
}
