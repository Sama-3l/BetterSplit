import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'add_contact_tile_state.dart';

class AddContactTileCubit extends Cubit<AddContactTileState> {
  final String selectedNumber;
  AddContactTileCubit({required this.selectedNumber})
    : super(AddContactTileInitial(selectedNumber: selectedNumber));

  updateSelectedNumber(String selectedNumber) =>
      emit(AddContactTileUpdate(selectedNumber: selectedNumber));
}
