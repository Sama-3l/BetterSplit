import 'package:bettersplitapp/core/errors/failure.dart';
import 'package:bettersplitapp/features/trip_screen/domain/entities/ledger.dart';
import 'package:dartz/dartz.dart';

abstract class LedgerRepo {
  Future<Either<Failure, List<LedgerEntity>>> getAllLedgers();
}
