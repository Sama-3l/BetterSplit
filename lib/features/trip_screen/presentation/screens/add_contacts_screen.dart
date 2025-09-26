import 'package:bettersplitapp/core/utils/common/buttons/circular_button.dart';
import 'package:bettersplitapp/core/utils/common/textfield.dart';
import 'package:bettersplitapp/core/utils/constants/theme.dart';
import 'package:bettersplitapp/features/home/domain/models/local/user_model_local.dart';
import 'package:bettersplitapp/features/trip_screen/presentation/blocs/cubits/AddContactCubit/add_contact_cubit.dart';
import 'package:bettersplitapp/features/trip_screen/presentation/widgets/add_contact_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class AddContactsScreen extends StatelessWidget {
  AddContactsScreen({super.key, required this.contacts});

  final List<Contact> contacts;
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddContactsCubit(contacts: contacts),
      child: BlocBuilder<AddContactsCubit, AddContactsState>(
        builder: (context, state) {
          final cubit = context.read<AddContactsCubit>();
          final thisContacts = state.contacts;
          final focusNotifier = ValueNotifier<bool>(focusNode.hasFocus);

          focusNode.addListener(() {
            focusNotifier.value = focusNode.hasFocus;
          });
          return FractionallySizedBox(
            heightFactor: 0.75,
            child: Container(
              decoration: BoxDecoration(
                color: ColorsConstants.backgroundBlack,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ColorsConstants.accentGreen,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                    ),
                    child: Row(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: CircularButton(
                            icon: CupertinoIcons.arrow_left,
                            onTap: () => GoRouter.of(context).pop([]),
                            color: ColorsConstants.backgroundBlack,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Add Friends',
                          style: TextStyles.fustatBold.copyWith(
                            fontSize: 24,
                            letterSpacing: -0.8,
                          ),
                        ),
                        const Spacer(),
                        CircularButton(
                          icon: CupertinoIcons.check_mark,
                          onTap: () {
                            GoRouter.of(context).pop(
                              state.contacts.where((e) => e.$3).map((e) {
                                String number = "";
                                for (var num
                                    in e.$1.phones[e.$2].number.characters) {
                                  if ((num.codeUnitAt(0) >= "0".codeUnitAt(0) &&
                                          num.codeUnitAt(0) <=
                                              "9".codeUnitAt(0)) ||
                                      num.codeUnitAt(0) == "+".codeUnitAt(0)) {
                                    number += num;
                                  }
                                }
                                return UserModel(
                                  id: Uuid().v4(),
                                  name: e.$1.displayName,
                                  userName: e.$1.displayName.split(' ')[0],
                                  number: number,
                                  upiID: "",
                                );
                              }).toList(),
                            );
                          },
                          color: ColorsConstants.backgroundBlack,
                        ),
                      ],
                    ),
                  ),

                  /// NEEDS AN ALREADY ADDED FRIENDS LIST -> GetAllUsersUseCase
                  /// AND A SEARCH BAR THAT FINDS USERS AND FILTERS IN BOTH LISTS
                  ValueListenableBuilder(
                    valueListenable: focusNotifier,
                    builder: (context, value, child) {
                      return Padding(
                        padding: const EdgeInsets.all(
                          16.0,
                        ).copyWith(bottom: 24),
                        child: InputField(
                          padding: EdgeInsets.zero,
                          focusNode: focusNode,
                          prefixIcon: Align(
                            alignment: Alignment(0.5, 0),
                            child: Icon(
                              CupertinoIcons.search,
                              size: 12,
                              color: value
                                  ? ColorsConstants.defaultWhite
                                  : ColorsConstants.defaultWhite.withValues(
                                      alpha: 0.5,
                                    ),
                            ),
                          ),
                          onChanged: (value) => cubit.searchContacts(value),
                          controller: controller,
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: AddContactTile(
                      user: contacts[0],
                      selected: state.allSelected,
                      /* handle state.allSelected if you have */
                      onUpdateSelectedNumber: (value) {},
                      onSelected: (value) => cubit.allSelected(),
                      indexZero: true,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView.separated(
                        itemCount: thisContacts.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final contactKey = ValueKey(
                            thisContacts[index].$1.id,
                          );

                          return AddContactTile(
                            key: contactKey,

                            user: thisContacts[index].$1,
                            selected: thisContacts[index].$3,
                            onUpdateSelectedNumber: (value) =>
                                cubit.updateNumber(
                                  index - 1,
                                  thisContacts[index]
                                      .$1 // contact
                                      .phones
                                      .indexWhere((e) => e.number == value),
                                ),
                            onSelected: (value) =>
                                cubit.toggleSelected(index, value),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
