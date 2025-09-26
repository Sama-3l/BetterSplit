import 'package:bettersplitapp/core/errors/failure.dart';
import 'package:bettersplitapp/features/trip_screen/data/datasources/ledger_local_datasource.dart';
import 'package:bettersplitapp/features/trip_screen/domain/entities/ledger.dart';
import 'package:bettersplitapp/features/trip_screen/domain/repo/ledger_repo.dart';
import 'package:dartz/dartz.dart';

class LedgerRepoImpl extends LedgerRepo {
  final LedgerLocalDataSource _ledgerLocalDataSource;

  LedgerRepoImpl(this._ledgerLocalDataSource);

  @override
  Future<Either<Failure, List<LedgerEntity>>> getAllLedgers() async {
    try {
      final ledgers = await _ledgerLocalDataSource.getAllLedgers();
      return Right(ledgers.map((e) => e.toEntity()).toList());
    } catch (e) {
      return const Left(LocalStorageFailure());
    }
  }
}
