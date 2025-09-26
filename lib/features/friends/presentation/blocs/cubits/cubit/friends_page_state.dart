part of 'friends_page_cubit.dart';

@immutable
sealed class FriendsPageState {
  final List<UserEntity> friends;

  const FriendsPageState({required this.friends});
}

final class FriendsPageUpdate extends FriendsPageState {
  const FriendsPageUpdate({required super.friends});
}
