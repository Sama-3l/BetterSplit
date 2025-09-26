// ignore_for_file: must_be_immutable

part of 'login_cubit.dart';

@immutable
sealed class LoginState {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController upiIDController = TextEditingController();
}

final class LoginInitial extends LoginState {}
