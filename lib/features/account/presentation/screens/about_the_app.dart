import 'package:bettersplitapp/core/utils/constants/theme.dart';
import 'package:bettersplitapp/features/account/presentation/blocs/cubits/cubit/about_the_app_cubit.dart';
import 'package:bettersplitapp/features/top_bar_widget/screens/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AboutTheApp extends StatelessWidget {
  const AboutTheApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AboutTheAppCubit, AboutTheAppState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: ColorsConstants.backgroundBlack,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopBar(
                backButton: true,
                title: "About the App",
                onTap: () {},
                subtitle: "A little about us",
              ),
              if (state is AboutTheAppLoading)
                Expanded(
                  child: Column(
                    children: [
                      Spacer(),
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator.adaptive(
                          backgroundColor: ColorsConstants.accentGreen,
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              if (state is AboutTheAppDone) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ).copyWith(top: 24),
                  child: Text(
                    '''BetterSplit was built for travelers who just want to focus on the trip, not the math.\n
One person tracks the expenses, everyone gets a fair split. No accounts to create,
no internet needed since everything lives on your device. \n
When it's time to settle up, share the full trip breakdown with anyone in seconds using a QR code.''',
                    style: TextStyles.fustatSemiBold.copyWith(
                      fontSize: 16,
                      color: ColorsConstants.defaultWhite,
                      letterSpacing: -0.6,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ).copyWith(top: 16),
                  child: Text(
                    '''Multi-device sync coming soon — we're working on a way to let everyone manage the ledger together, even offline. And if that doesn't pan out, we'll move to maintaining servers while still keeping it completely free.''',
                    style: TextStyles.fustatSemiBold.copyWith(
                      fontSize: 12,
                      color: ColorsConstants.defaultWhite.withValues(
                        alpha: 0.75,
                      ),
                      fontStyle: FontStyle.italic,
                      letterSpacing: -0.6,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      children: [
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ).copyWith(bottom: 32),
                          child: Column(
                            children: [
                              Text(
                                "Version: ${state.packageInfo!.version}",
                                style: TextStyles.fustatSemiBold.copyWith(
                                  fontSize: 12,
                                  color: ColorsConstants.defaultWhite
                                      .withValues(alpha: 0.7),
                                  letterSpacing: -0.6,
                                ),
                              ),
                              Text(
                                "Made with ♥ for travelers everywhere",
                                style: TextStyles.fustatSemiBold.copyWith(
                                  fontSize: 12,
                                  color: ColorsConstants.defaultWhite
                                      .withValues(alpha: 0.7),
                                  letterSpacing: -0.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
