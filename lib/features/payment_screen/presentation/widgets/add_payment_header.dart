import 'package:bettersplitapp/core/utils/common/buttons/primary_button.dart';
import 'package:bettersplitapp/core/utils/constants/theme.dart';
import 'package:bettersplitapp/features/home/domain/entities/user.dart';
import 'package:bettersplitapp/features/top_bar_widget/screens/top_bar.dart';
import 'package:bettersplitapp/features/trip_screen/domain/entities/trip.dart';
import 'package:flutter/material.dart';

class AddPaymentHeader extends StatelessWidget {
  final TextEditingController paymentName;
  final TripEntity trip;
  final List<UserEntity> users;
  final VoidCallback onApply;

  const AddPaymentHeader({
    super.key,
    required this.paymentName,
    required this.trip,
    required this.users,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorsConstants.accentGreen,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TopBar(title: "", onTap: () {}, backButton: true, topPadding: 16),

          ValueListenableBuilder(
            valueListenable: paymentName,
            builder: (context, paymentName, _) {
              return TopBar(
                title: paymentName.text == ""
                    ? "Payment Name"
                    : paymentName.text,
                subtitle: "Add Payment",
                topPadding: 0,
                onTap: () {},
              );
            },
          ),

          const SizedBox(height: 16),

          // Buttons row
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ).copyWith(bottom: 16),
            child: Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    onTap: () => Navigator.of(context).pop(),
                    title: "Cancel",
                    secondary: true,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(child: PrimaryButton(onTap: () => onApply())),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
