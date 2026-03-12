import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'about_the_app_state.dart';

class AboutTheAppCubit extends Cubit<AboutTheAppState> {
  AboutTheAppCubit() : super(AboutTheAppLoading());

  init() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    emit(AboutTheAppDone(packageInfo: packageInfo));
  }
}
