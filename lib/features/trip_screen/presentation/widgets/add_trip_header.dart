import 'package:bettersplitapp/core/utils/common/buttons/circular_button.dart';
import 'package:bettersplitapp/core/utils/common/buttons/primary_button.dart';
import 'package:bettersplitapp/core/utils/constants/theme.dart';
import 'package:bettersplitapp/features/trip_screen/presentation/widgets/horizontal_users_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

class AddTripHeader extends StatelessWidget {
  final TextEditingController tripNameController;
  final String selectedLogo;
  final List<Map<String, dynamic>> users;
  final VoidCallback onCancel;
  final VoidCallback onApply;

  const AddTripHeader({
    super.key,
    required this.tripNameController,
    required this.selectedLogo,
    required this.users,
    required this.onCancel,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorsConstants.accentGreen,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back Button
          Align(
            alignment: Alignment.centerLeft,
            child: CircularButton(
              icon: CupertinoIcons.arrow_left,
              onTap: () => onCancel(),
              color: ColorsConstants.backgroundBlack,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ValueListenableBuilder<TextEditingValue>(
                      valueListenable: tripNameController,
                      builder: (context, value, _) {
                        return Text(
                          value.text.isEmpty ? 'Trip Name' : value.text,
                          style: TextStyles.fustatBold.copyWith(
                            fontSize: 24,
                            letterSpacing: -0.8,
                          ),
                        );
                      },
                    ),

                    if (users.isNotEmpty)
                      SizedBox(
                        height: 40,
                        child: HorizontalFriendsList(
                          initials: users
                              .map((e) => e['userName'][0] as String)
                              .toList(),
                          ltr: true,
                        ),
                      ),
                  ],
                ),
              ),

              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: ColorsConstants.backgroundBlack,
                  borderRadius: BorderRadius.circular(64),
                ),
                child: Center(
                  child: SizedBox(
                    height: 24,
                    width: 24,
                    child: SvgPicture.asset(
                      selectedLogo,
                      colorFilter: ColorFilter.mode(
                        ColorsConstants.accentGreen,
                        BlendMode.srcIn,
                      ),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  title: "Cancel",
                  secondary: true,
                  onTap: () => onCancel(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(child: PrimaryButton(onTap: () => onApply())),
            ],
          ),
        ],
      ),
    );
  }
}
