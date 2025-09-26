// ignore_for_file: must_be_immutable

part of 'add_contact_cubit.dart';

@immutable
sealed class AddContactsState {
  final List<(Contact, int, bool)> contacts;
  bool allSelected;

  AddContactsState({required this.contacts, this.allSelected = false});
}

final class AddContactsUpdate extends AddContactsState {
  AddContactsUpdate({required super.contacts, super.allSelected});
}
