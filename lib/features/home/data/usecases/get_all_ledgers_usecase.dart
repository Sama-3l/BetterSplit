import 'package:bettersplitapp/core/errors/failure.dart';
import 'package:bettersplitapp/core/usecase/usecase.dart';
import 'package:bettersplitapp/features/trip_screen/domain/entities/ledger.dart';
import 'package:bettersplitapp/features/trip_screen/domain/repo/ledger_repo.dart';
import 'package:dartz/dartz.dart';

class GetAllLedgersUsecase extends UseCase<List<LedgerEntity>, NoParams> {
  final LedgerRepo _ledgerRepository;

  GetAllLedgersUsecase(LedgerRepo ledgerRepository)
    : _ledgerRepository = ledgerRepository;

  @override
  Future<Either<Failure, List<LedgerEntity>>> call(NoParams params) {
    return _ledgerRepository.getAllLedgers();
  }
}
