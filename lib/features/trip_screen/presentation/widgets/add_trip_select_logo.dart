import 'package:bettersplitapp/core/utils/constants/enums.dart';
import 'package:bettersplitapp/core/utils/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddTripSelectLogo extends StatelessWidget {
  final TripLogo selectedLogo;
  final ValueChanged<TripLogo> onLogoSelected;

  const AddTripSelectLogo({
    super.key,
    required this.selectedLogo,
    required this.onLogoSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trip Logo',
            style: TextStyles.fustatExtraBold.copyWith(
              fontSize: 12,
              color: ColorsConstants.defaultWhite,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: TripLogo.values.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final logo = TripLogo.values[index];
                final isSelected = logo == selectedLogo;

                return GestureDetector(
                  onTap: () => onLogoSelected(logo),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? ColorsConstants.accentGreen
                          : ColorsConstants.backgroundBlack,
                      borderRadius: BorderRadius.circular(80),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        logo.icon,
                        height: 16,
                        width: 16,
                        fit: BoxFit.contain,
                        colorFilter: ColorFilter.mode(
                          isSelected
                              ? ColorsConstants.backgroundBlack
                              : ColorsConstants.accentGreen,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
