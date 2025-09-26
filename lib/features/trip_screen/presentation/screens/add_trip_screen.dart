import 'package:bettersplitapp/core/utils/common/textfield.dart';
import 'package:bettersplitapp/core/utils/constants/theme.dart';
import 'package:bettersplitapp/features/home/domain/entities/user.dart';
import 'package:bettersplitapp/features/trip_screen/presentation/blocs/cubits/AddTripCubit/add_trip_cubit.dart';
import 'package:bettersplitapp/features/trip_screen/presentation/widgets/add_trip_header.dart';
import 'package:bettersplitapp/features/trip_screen/presentation/widgets/add_trip_select_logo.dart';
import 'package:bettersplitapp/features/trip_screen/presentation/widgets/friend_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTripBottomSheet extends StatefulWidget {
  final UserEntity currentUser;

  const AddTripBottomSheet({super.key, required this.currentUser});

  @override
  State<AddTripBottomSheet> createState() => _AddTripBottomSheetState();
}

class _AddTripBottomSheetState extends State<AddTripBottomSheet> {
  final TextEditingController tripName = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<AddTripCubit>().init(widget.currentUser);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddTripCubit, AddTripState>(
      builder: (context, state) {
        final cubit = context.read<AddTripCubit>();
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: true,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: ColorsConstants.backgroundBlack,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: ListView(
                controller: scrollController,
                children: [
                  AddTripHeader(
                    selectedLogo: state.selectedLogo.icon,
                    users: state.users,
                    tripNameController: tripName,
                    onCancel: () {
                      Navigator.of(context).pop(false);
                    },
                    onApply: () => cubit.addTrip(tripName.text, context),
                  ),

                  AddTripSelectLogo(
                    selectedLogo: state.selectedLogo,
                    onLogoSelected: (logo) => cubit.changeSelectedLogo(logo),
                  ),
                  const SizedBox(height: 16),

                  InputField(
                    title: "Trip Name",
                    hintText: "Enter trip name",
                    controller: tripName,
                  ),
                  const SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Text(
                          "Add Friends",
                          style: TextStyles.fustatExtraBold.copyWith(
                            fontSize: 12,
                            letterSpacing: -0.5,
                            color: ColorsConstants.defaultWhite,
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () => cubit.addFriends(context),
                          child: Icon(
                            CupertinoIcons.person_crop_circle_badge_plus,
                            size: 16,
                            color: ColorsConstants.defaultWhite,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: ColorsConstants.surfaceBlack,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListView.separated(
                      controller: scrollController,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.users.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final user = state.users[index];
                        return Dismissible(
                          key: ValueKey(user["id"] ?? index),
                          direction: user["currentUser"] == true
                              ? DismissDirection.none
                              : DismissDirection.endToStart,
                          onDismissed: (_) => cubit.deleteFriend(index),
                          background: Container(
                            color: ColorsConstants.warningRed,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Icon(
                              CupertinoIcons.delete,
                              color: ColorsConstants.defaultWhite,
                            ),
                          ),
                          child: FriendTile(user: user),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
