import 'package:bettersplitapp/core/usecase/usecase.dart';
import 'package:bettersplitapp/features/friends/data/usecases/get_all_users_usecase.dart';
import 'package:bettersplitapp/features/home/domain/entities/user.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'friends_page_state.dart';

class FriendsPageCubit extends Cubit<FriendsPageState> {
  final GetAllUsersUsecase getAllUsersUsecase;
  FriendsPageCubit(this.getAllUsersUsecase)
    : super(FriendsPageUpdate(friends: []));

  initialize() async {
    final result = await getAllUsersUsecase(NoParams());
    result.fold((_) {}, (friends) {
      emit(
        FriendsPageUpdate(
          friends: friends.where((e) => !e.currentUser).toList(),
        ),
      );
    });
  }
}
