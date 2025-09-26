import 'package:bettersplitapp/core/utils/common/buttons/toggle_button.dart';
import 'package:bettersplitapp/core/utils/constants/theme.dart';
import 'package:bettersplitapp/features/trip_screen/presentation/blocs/cubits/AddContactTileCubit/add_contact_tile_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class AddContactTile extends StatefulWidget {
  final Contact user;
  final ValueChanged<double>? onHeightMeasured;
  final Function(String number) onUpdateSelectedNumber;
  final Function(bool selected) onSelected;
  final bool selected;
  final bool indexZero;

  const AddContactTile({
    super.key,
    required this.user,
    this.onHeightMeasured,
    required this.onUpdateSelectedNumber,
    required this.selected,
    required this.onSelected,
    this.indexZero = false,
  });

  @override
  State<AddContactTile> createState() => _AddContactTileState();
}

class _AddContactTileState extends State<AddContactTile> {
  @override
  Widget build(BuildContext context) {
    final userName = widget.user.displayName;
    final phones = widget.user.phones;
    final numbers = phones.map((p) => p.number).toList();

    return BlocProvider(
      create: (context) => AddContactTileCubit(
        selectedNumber: phones.isNotEmpty ? phones.first.number : "",
      ),
      child: BlocBuilder<AddContactTileCubit, AddContactTileState>(
        builder: (context, state) {
          final cubit = context.read<AddContactTileCubit>();
          return Row(
            children: [
              Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: ColorsConstants.defaultWhite,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ColorsConstants.backgroundBlack,
                    width: 1,
                  ),
                ),
                child: Text(
                  widget.indexZero
                      ? "A"
                      : userName.isNotEmpty
                      ? userName[0]
                      : '',
                  style: TextStyles.fustatBold.copyWith(
                    fontSize: 12,
                    color: ColorsConstants.backgroundBlack,
                  ),
                ),
              ),
              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  widget.indexZero ? "All" : userName,
                  style: TextStyles.fustatExtraBold.copyWith(
                    fontSize: 12,
                    color: ColorsConstants.defaultWhite,
                    letterSpacing: -0.5,
                  ),
                ),
              ),

              if (!widget.indexZero)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: ColorsConstants.surfaceBlack,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    dropdownColor: ColorsConstants.surfaceBlack,
                    value: state.selectedNumber,
                    icon: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Icon(
                        CupertinoIcons.chevron_down,
                        size: 12,
                        color: ColorsConstants.defaultWhite,
                      ),
                    ),
                    underline: const SizedBox(),
                    items: numbers.map((number) {
                      return DropdownMenuItem<String>(
                        value: number,
                        child: Text(
                          number,
                          style: TextStyles.fustatMedium.copyWith(
                            fontSize: 12,
                            color: ColorsConstants.defaultWhite,
                            letterSpacing: -0.5,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      cubit.updateSelectedNumber(value!);
                      widget.onUpdateSelectedNumber(value);
                    },
                  ),
                ),
              const SizedBox(width: 16),

              SmallToggleButton(
                initialValue: widget.selected,
                onChanged: (value) {
                  widget.onSelected(value);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
