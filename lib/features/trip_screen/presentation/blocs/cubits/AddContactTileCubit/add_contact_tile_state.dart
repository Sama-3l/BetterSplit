part of 'add_contact_tile_cubit.dart';

@immutable
sealed class AddContactTileState {
  final String selectedNumber;

  const AddContactTileState({required this.selectedNumber});
}

final class AddContactTileInitial extends AddContactTileState {
  const AddContactTileInitial({required super.selectedNumber});
}

final class AddContactTileUpdate extends AddContactTileState {
  const AddContactTileUpdate({required super.selectedNumber});
}
