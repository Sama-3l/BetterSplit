// import 'package:hive/hive.dart';

// extension _HiveIdGenerator on HiveObject {
//   static String generateId() =>
//       DateTime.now().microsecondsSinceEpoch.toString();
// }

// Source - https://stackoverflow.com/a/29629114
// Posted by Günter Zöchbauer, modified by community. See post 'Timeline' for change history
// Retrieved 2026-03-10, License - CC BY-SA 4.0

extension StringCasingExtension on String {
  String get toCapitalized =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String get toTitleCase => replaceAll(
    RegExp(' +'),
    ' ',
  ).split(' ').map((str) => str.toCapitalized).join(' ');
}
