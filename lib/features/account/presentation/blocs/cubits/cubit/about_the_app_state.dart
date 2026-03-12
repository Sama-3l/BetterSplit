part of 'about_the_app_cubit.dart';

@immutable
sealed class AboutTheAppState {
  final PackageInfo? packageInfo;

  const AboutTheAppState({this.packageInfo});
}

final class AboutTheAppLoading extends AboutTheAppState {}

final class AboutTheAppDone extends AboutTheAppState {
  const AboutTheAppDone({super.packageInfo});
}
