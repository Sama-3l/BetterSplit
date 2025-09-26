import 'package:bettersplitapp/features/friends/presentation/blocs/cubits/cubit/friends_page_cubit.dart';
import 'package:bettersplitapp/features/home/domain/models/local/user_model_local.dart';
import 'package:bettersplitapp/features/login/presentation/blocs/cubits/cubit/login_cubit.dart';
import 'package:bettersplitapp/features/main_app/presentation/blocs/cubits/MainAppCubit/main_app_cubit.dart';
import 'package:bettersplitapp/features/payment_screen/domain/models/local/payment_model_local.dart';
import 'package:bettersplitapp/features/payment_screen/domain/models/local/user_share_model_local.dart';
import 'package:bettersplitapp/features/top_bar_widget/SliderAnimationCubit/slider_animation_cubit.dart';
import 'package:bettersplitapp/features/trip_screen/domain/models/local/ledger_model_local.dart';
import 'package:bettersplitapp/features/trip_screen/domain/models/local/trip_model_local.dart';
import 'package:bettersplitapp/features/trip_screen/presentation/blocs/cubits/AddTripCubit/add_trip_cubit.dart';
import 'package:bettersplitapp/injection_container.dart';
import 'package:bettersplitapp/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(TripModelAdapter());
  Hive.registerAdapter(PaymentModelAdapter());
  Hive.registerAdapter(UserShareModelAdapter());
  Hive.registerAdapter(LedgerModelAdapter());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHive();
  await initializeDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<LoginCubit>()..getAllUsers()),
        BlocProvider(
          create: (context) => sl<MainAppCubit>()..loadCurrentUser(),
        ),
        BlocProvider(create: (context) => SliderAnimationCubit()),
        BlocProvider(create: (context) => sl<AddTripCubit>()),
        BlocProvider(create: (context) => sl<FriendsPageCubit>()..initialize()),
        // BlocProvider(create: (context) => AddPaymentCubit()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter().router,
      ),
    );
  }
}
