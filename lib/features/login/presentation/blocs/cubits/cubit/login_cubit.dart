import 'package:bettersplitapp/core/usecase/usecase.dart';
import 'package:bettersplitapp/core/utils/constants/theme.dart';
import 'package:bettersplitapp/features/friends/data/usecases/delete_all_users_usecase.dart';
import 'package:bettersplitapp/features/friends/data/usecases/get_all_users_usecase.dart';
import 'package:bettersplitapp/features/login/data/usecases/save_user_usecase.dart';
import 'package:bettersplitapp/features/home/domain/entities/user.dart';
import 'package:bettersplitapp/features/main_app/presentation/blocs/cubits/MainAppCubit/main_app_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final SaveUserUseCase saveUserUseCase;
  final GetAllUsersUsecase getAllUsersUsecases;
  final DeleteAllUsersUsecase deleteAllUsersUsecase;
  LoginCubit(
    this.saveUserUseCase,
    this.getAllUsersUsecases,
    this.deleteAllUsersUsecase,
  ) : super(LoginInitial());

  /// This is where you’d call your use case to persist the user
  Future<void> saveUser(BuildContext context) async {
    UserEntity user;
    if (state.nameController.text.isNotEmpty ||
        state.usernameController.text.isNotEmpty ||
        state.phoneNumberController.text.isNotEmpty ||
        state.nameController.text.length > 10 ||
        state.upiIDController.text.isNotEmpty) {
      user = UserEntity(
        id: Uuid().v4(),
        name: state.nameController.text,
        userName: state.usernameController.text,
        number: state.phoneNumberController.text,
        upiID: state.upiIDController.text,
        currentUser: true,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: ColorsConstants.onSurfaceBlack,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Alert:",
                style: TextStyles.fustatExtraBold.copyWith(
                  color: ColorsConstants.warningRed,
                  letterSpacing: -0.8,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "All Fields Are Required",
                style: TextStyles.fustatSemiBold.copyWith(
                  color: ColorsConstants.warningRed,
                  letterSpacing: -0.5,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
      return;
    }

    final result = await saveUserUseCase(user);
    result.fold((failure) {}, (_) {
      clear();
      context.read<MainAppCubit>().loadCurrentUser();
    });
  }

  Future<List<UserEntity>> getAllUsers() async {
    final users = await getAllUsersUsecases(NoParams());
    users.fold((fail) {}, (users) => users);
    return [];
  }

  Future<void> deleteAllUsers() async {
    await deleteAllUsersUsecase(NoParams());
    getAllUsers();
  }

  void clear() {
    state.nameController.clear();
    state.usernameController.clear();
    state.phoneNumberController.clear();
    state.upiIDController.clear();
    emit(LoginInitial());
  }
}
