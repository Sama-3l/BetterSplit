import 'package:bettersplitapp/features/trip_screen/domain/models/local/ledger_model_local.dart';
import 'package:hive/hive.dart';

abstract class LedgerLocalDataSource {
  Future<List<LedgerModel>> getAllLedgers();
}

class LedgerLocalDataSourceImpl implements LedgerLocalDataSource {
  static const _ledgerBoxName = 'ledgerBox';

  @override
  Future<List<LedgerModel>> getAllLedgers() async {
    final box = await Hive.openBox<LedgerModel>(_ledgerBoxName);
    try {
      return box.values.toList();
    } catch (_) {
      return [];
    }
  }
}
