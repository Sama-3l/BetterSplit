import 'package:bettersplitapp/features/home/domain/entities/user.dart';
import 'package:bettersplitapp/features/home/domain/repo/user_repo.dart';
import 'package:bettersplitapp/features/trip_screen/domain/entities/trip.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'main_app_state.dart';

class MainAppCubit extends Cubit<MainAppState> {
  final UserRepository userRepository;
  final int currentIndex;

  MainAppCubit({this.currentIndex = 0, required this.userRepository})
    : super(MainAppLoading(user: null, trips: []));

  Future<void> loadCurrentUser() async {
    final user = await userRepository.getCurrentUser();
    user.fold(
      (failure) {
        // handle failure (maybe emit error state)
      },
      (user) {
        emit(MainAppUpdate(user: user, trips: []));
      },
    );
  }

  void changeTab(tabIndex) =>
      emit(ChangeTabState(user: state.user, trips: state.trips, tab: tabIndex));

  void logout() async {
    await userRepository.updateUser(state.user!.copyWith(currentUser: false));
    emit(MainAppUpdate(trips: [], user: null));
  }
}
