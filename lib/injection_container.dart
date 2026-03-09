import 'package:bettersplitapp/features/friends/data/usecases/delete_all_users_usecase.dart';
import 'package:bettersplitapp/features/friends/data/usecases/get_all_users_usecase.dart';
import 'package:bettersplitapp/features/friends/presentation/blocs/cubits/cubit/friends_page_cubit.dart';
import 'package:bettersplitapp/features/home/data/usecases/delete_trip_usecase.dart';
import 'package:bettersplitapp/features/home/data/usecases/get_all_ledgers_usecase.dart';
import 'package:bettersplitapp/features/home/data/usecases/get_all_trips_usecase.dart';
import 'package:bettersplitapp/features/home/data/usecases/get_user_by_number_usecase.dart';
import 'package:bettersplitapp/features/login/data/usecases/save_user_usecase.dart';
import 'package:bettersplitapp/features/home/presentation/blocs/cubits/HomeScreenCubit/home_screen_cubit.dart';
import 'package:bettersplitapp/features/main_app/presentation/blocs/cubits/MainAppCubit/main_app_cubit.dart';
import 'package:bettersplitapp/features/payment_screen/data/datasources/payment_local_datasource.dart';
import 'package:bettersplitapp/features/payment_screen/data/repo/payment_repo_impl.dart';
import 'package:bettersplitapp/features/payment_screen/domain/repo/payment_repo.dart';
import 'package:bettersplitapp/features/trip_screen/data/datasources/ledger_local_datasource.dart';
import 'package:bettersplitapp/features/trip_screen/data/datasources/trip_local_datasource.dart';
import 'package:bettersplitapp/features/trip_screen/data/repo/ledger_repo_impl.dart';
import 'package:bettersplitapp/features/trip_screen/data/repo/trip_repo_impl.dart';
import 'package:bettersplitapp/features/trip_screen/data/usecases/delete_payment_usecase.dart';
import 'package:bettersplitapp/features/trip_screen/data/usecases/get_all_payments_usecase.dart';
import 'package:bettersplitapp/features/trip_screen/data/usecases/save_trip_usecase.dart';
import 'package:bettersplitapp/features/trip_screen/data/usecases/update_trip_usecase.dart';
import 'package:bettersplitapp/features/trip_screen/domain/repo/ledger_repo.dart';
import 'package:bettersplitapp/features/trip_screen/domain/repo/trip_repo.dart';
import 'package:bettersplitapp/features/trip_screen/presentation/blocs/cubits/AddTripCubit/add_trip_cubit.dart';
import 'package:bettersplitapp/features/trip_screen/presentation/blocs/cubits/TripScreen/trip_screen_cubit.dart';
import 'package:get_it/get_it.dart';

// Data layer
import 'package:bettersplitapp/features/home/data/datasource/user_local_datasource.dart';
import 'package:bettersplitapp/features/home/data/repo/user_repo_impl.dart';

// Domain layer
import 'package:bettersplitapp/features/home/domain/repo/user_repo.dart';

// Presentation layer
import 'package:bettersplitapp/features/login/presentation/blocs/cubits/cubit/login_cubit.dart';

final sl = GetIt.instance;

/// Call this inside main() before runApp()
Future<void> initializeDependencies() async {
  // await ledgerDependencies();
  await userDependencies();
  await tripDependencies();
  await paymentDependencies();
}

Future<void> userDependencies() async {
  // data-source
  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(),
  );
  // repo
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(sl<UserLocalDataSource>()),
  );
  //use-cases
  sl.registerLazySingleton<SaveUserUseCase>(
    () => SaveUserUseCase(repository: sl<UserRepository>()),
  );
  sl.registerLazySingleton<GetAllUsersUsecase>(
    () => GetAllUsersUsecase(repository: sl<UserRepository>()),
  );
  sl.registerLazySingleton<DeleteAllUsersUsecase>(
    () => DeleteAllUsersUsecase(repository: sl<UserRepository>()),
  );
  sl.registerLazySingleton<GetUserByNumberUsecase>(
    () => GetUserByNumberUsecase(sl<UserRepository>()),
  );
  //cubits
  sl.registerFactory<LoginCubit>(
    () => LoginCubit(
      sl<SaveUserUseCase>(),
      sl<GetAllUsersUsecase>(),
      sl<DeleteAllUsersUsecase>(),
    ),
  );
  sl.registerFactory<MainAppCubit>(() => MainAppCubit(userRepository: sl()));
  sl.registerFactory<FriendsPageCubit>(
    () => FriendsPageCubit(sl<GetAllUsersUsecase>()),
  );
}

Future<void> tripDependencies() async {
  // data-source
  sl.registerLazySingleton<TripLocalDataSource>(
    () => TripLocalDataSourceImpl(),
  );
  // repo
  sl.registerLazySingleton<TripRepository>(
    () => TripRepoImpl(sl<TripLocalDataSource>()),
  );
  // use-cases
  sl.registerLazySingleton<SaveTripUseCase>(
    () => SaveTripUseCase(repository: sl<TripRepository>()),
  );
  sl.registerLazySingleton<GetAllTripsUsecase>(
    () => GetAllTripsUsecase(sl<TripRepository>()),
  );
  sl.registerLazySingleton<DeleteTripUsecase>(
    () => DeleteTripUsecase(sl<TripRepository>()),
  );
  sl.registerLazySingleton<UpdateTripUsecase>(
    () => UpdateTripUsecase(sl<TripRepository>()),
  );
  // cubit
  sl.registerFactory<HomeScreenCubit>(
    () => HomeScreenCubit(
      getAllTripsUsecase: sl(),
      deleteTripUsecase: sl(),
      updateTripUsecase: sl(),
    ),
  );
  sl.registerFactory<AddTripCubit>(
    () => AddTripCubit(
      sl<SaveTripUseCase>(),
      sl<SaveUserUseCase>(),
      sl<GetUserByNumberUsecase>(),
    ),
  );
}

Future<void> paymentDependencies() async {
  // data-source
  sl.registerLazySingleton<PaymentLocalDatasource>(
    () => PaymentLocalDatasourceImpl(),
  );
  // repo
  sl.registerLazySingleton<PaymentRepo>(
    () => PaymentRepoImpl(sl<PaymentLocalDatasource>()),
  );
  // use-cases
  sl.registerLazySingleton<GetAllPaymentsUsecase>(
    () => GetAllPaymentsUsecase(sl<PaymentRepo>()),
  );
  sl.registerLazySingleton<DeletePaymentUseCase>(
    () => DeletePaymentUseCase(sl<PaymentRepo>()),
  );
  // cubit
  sl.registerFactory<TripScreenCubit>(
    () => TripScreenCubit(
      getAllPaymentsUsecase: sl(),
      updateTripUsecase: sl(),
      deletePaymentUseCase: sl(),
    ),
  );
}

Future<void> ledgerDependencies() async {
  // data-source
  sl.registerLazySingleton<LedgerLocalDataSource>(
    () => LedgerLocalDataSourceImpl(),
  );
  // repo
  sl.registerLazySingleton<LedgerRepo>(
    () => LedgerRepoImpl(sl<LedgerLocalDataSource>()),
  );
  // use-cases
  sl.registerLazySingleton<GetAllLedgersUsecase>(
    () => GetAllLedgersUsecase(sl<LedgerRepo>()),
  );
}
