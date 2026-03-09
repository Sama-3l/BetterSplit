import 'package:bettersplitapp/core/utils/constants/enums.dart';
import 'package:bettersplitapp/features/home/data/usecases/get_user_by_number_usecase.dart';
import 'package:bettersplitapp/features/home/domain/entities/user.dart';
import 'package:bettersplitapp/features/home/domain/models/local/user_model_local.dart';
import 'package:bettersplitapp/features/login/data/usecases/save_user_usecase.dart';
import 'package:bettersplitapp/features/trip_screen/data/usecases/save_trip_usecase.dart';
import 'package:bettersplitapp/features/trip_screen/domain/entities/trip.dart';
import 'package:bettersplitapp/features/trip_screen/presentation/screens/add_contacts_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

part 'add_trip_state.dart';

class AddTripCubit extends Cubit<AddTripState> {
  final SaveTripUseCase saveTripUseCase;
  final SaveUserUseCase saveUserUseCase;
  final GetUserByNumberUsecase getUserByNumberUsecase;

  AddTripCubit(
    this.saveTripUseCase,
    this.saveUserUseCase,
    this.getUserByNumberUsecase,
  ) : super(AddTripInitial(users: [], selectedLogo: TripLogo.car));

  init(UserEntity currentUser) {
    state.users.clear();
    state.users.add(UserModel.fromEntity(currentUser).toJson());
    emit(AddTripUpdate(users: state.users, selectedLogo: state.selectedLogo));
  }

  changeSelectedLogo(TripLogo logo) =>
      emit(AddTripUpdate(users: state.users, selectedLogo: logo));

  addFriends(BuildContext context) async {
    if (await FlutterContacts.requestPermission()) {
      List<Contact> contacts = await FlutterContacts.getContacts(
        withProperties: true,
      );
      List<UserModel> usersAdded = [];
      usersAdded =
          await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => AddContactsScreen(contacts: contacts),
          ) ??
          <UserModel>[];
      if (usersAdded.isNotEmpty) {
        state.users.addAll((usersAdded).map((e) => e.toJson()));
      }
    }
  }

  addDummyFriends(String name, String phoneNumber) async {
    state.users.add(
      UserModel(
        id: "",
        name: name,
        userName: name,
        number: phoneNumber,
        upiID: "",
      ).toJson(),
    );
    emit(AddTripUpdate(users: state.users, selectedLogo: state.selectedLogo));
  }

  deleteFriend(int index) {
    state.users.removeAt(index);
    emit(AddTripUpdate(users: state.users, selectedLogo: state.selectedLogo));
  }

  addTrip(String name, BuildContext context) async {
    if (state.users.length > 1 && name.isNotEmpty) {
      TripEntity trip = TripEntity(
        id: Uuid().v4(),
        title: name,
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        icon: state.selectedLogo.name,
        goingOn: true,
        users: state.users
            .map((e) => UserModel.fromJson(e).toEntity())
            .toList(),
      );
      for (var user in trip.users) {
        final userExists = await getUserByNumberUsecase(user.number);
        userExists.fold((_) {}, (thisUser) async {
          if (thisUser == null) {
            await saveUserUseCase(user);
          }
        });
      }
      await saveTripUseCase(trip);
      GoRouter.of(context).pop(true);
    }
  }
}
