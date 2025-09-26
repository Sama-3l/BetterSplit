import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';

part 'add_contact_state.dart';

class AddContactsCubit extends Cubit<AddContactsState> {
  final List<Contact> contacts;
  AddContactsCubit({required this.contacts})
    : super(
        AddContactsUpdate(
          contacts: contacts.map((e) => (e, 0, false)).toList(),
        ),
      );

  updateNumber(int index, int phoneIndex) {
    state.contacts[index] = (
      state.contacts[index].$1,
      phoneIndex,
      state.contacts[index].$3,
    );
    emit(AddContactsUpdate(contacts: state.contacts));
  }

  toggleSelected(int index, bool toggleSelected) {
    state.contacts[index] = (
      state.contacts[index].$1,
      state.contacts[index].$2,
      toggleSelected,
    );
    emit(AddContactsUpdate(contacts: state.contacts));
  }

  void searchContacts(String query) {
    final lowerQuery = query.toLowerCase();
    final filtered = contacts.where((contact) {
      final name = contact.displayName.toLowerCase();
      final phones = contact.phones
          .map((p) => p.number)
          .join(' ')
          .toLowerCase();
      return name.contains(lowerQuery) || phones.contains(lowerQuery);
    }).toList();
    emit(
      AddContactsUpdate(contacts: filtered.map((e) => (e, 0, false)).toList()),
    );
  }

  void resetFilter() {
    // to restore full list
    emit(
      AddContactsUpdate(contacts: contacts.map((e) => (e, 0, false)).toList()),
    );
  }

  allSelected() {
    state.allSelected = !state.allSelected;
    for (var i = 0; i < state.contacts.length; i++) {
      state.contacts[i] = (
        state.contacts[i].$1,
        state.contacts[i].$2,
        state.allSelected,
      );
    }
    emit(
      AddContactsUpdate(
        contacts: state.contacts,
        allSelected: state.allSelected,
      ),
    );
  }
}
