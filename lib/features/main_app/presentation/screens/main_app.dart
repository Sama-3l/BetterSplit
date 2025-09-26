import 'package:bettersplitapp/core/utils/common/custom_tab_bar.dart';
import 'package:bettersplitapp/core/utils/constants/theme.dart';
import 'package:bettersplitapp/features/account/presentation/screens/account.dart';
import 'package:bettersplitapp/features/friends/presentation/screens/friends.dart';
import 'package:bettersplitapp/features/home/presentation/screens/home_page.dart';
import 'package:bettersplitapp/features/login/presentation/screens/login_page.dart';
import 'package:bettersplitapp/features/main_app/presentation/blocs/cubits/MainAppCubit/main_app_cubit.dart';
import 'package:bettersplitapp/features/qr/presentation/screens/qr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContentView extends StatelessWidget {
  const ContentView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainAppCubit, MainAppState>(
      builder: (context, state) {
        if (state is MainAppLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: ColorsConstants.accentGreen,
            ),
          );
        }
        if (state.user == null) {
          return LoginPage();
        }

        final mainAppCubit = context.read<MainAppCubit>();
        final currentIndex = state.tab; // int now

        return DefaultTabController(
          length: 4,
          initialIndex: currentIndex,
          child: Builder(
            builder: (context) {
              final tabController = DefaultTabController.of(context);

              // keep cubit in sync when swiping
              tabController.addListener(() {
                if (!tabController.indexIsChanging) {
                  mainAppCubit.changeTab(tabController.index);
                }
              });

              return Scaffold(
                backgroundColor: ColorsConstants.backgroundBlack,
                body: Stack(
                  children: [
                    // your pages
                    TabBarView(
                      controller: tabController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        HomePage(user: state.user!),
                        FriendsPage(currUser: state.user!),
                        AccountPage(currUser: state.user!),
                        const QRPage(),
                      ],
                    ),
                    // the floating tab bar
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: CustomTabBar(
                        selectedIndex: currentIndex,
                        onTabSelected: (index) {
                          mainAppCubit.changeTab(index);
                          tabController.index = index;
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
