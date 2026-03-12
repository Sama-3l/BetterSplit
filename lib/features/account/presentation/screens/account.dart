import 'package:bettersplitapp/core/utils/constants/theme.dart';
import 'package:bettersplitapp/features/account/presentation/widgets/menu_tile.dart';
import 'package:bettersplitapp/features/home/domain/entities/user.dart';
import 'package:bettersplitapp/features/main_app/presentation/blocs/cubits/MainAppCubit/main_app_cubit.dart';
import 'package:bettersplitapp/features/top_bar_widget/screens/top_bar.dart';
import 'package:bettersplitapp/features/top_bar_widget/screens/top_bar_widgets.dart';
import 'package:bettersplitapp/routes/app_route_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key, required this.currUser});

  final UserEntity currUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsConstants.backgroundBlack,
      body: Column(
        children: [
          TopBar(title: "Account", onTap: () {}),
          TopBarWidgets(
            currentTab: 2,
            debts: [],
            user: currUser,
            onSwiped: (ledger) {},
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView(
                padding: EdgeInsets.only(top: 24),
                children: [
                  MenuTile(
                    title: "About the app",
                    icon: CupertinoIcons.info,
                    onTap: () =>
                        GoRouter.of(context).pushNamed(Routes.aboutTheApp),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Divider(
                      color: ColorsConstants.defaultWhite.withValues(
                        alpha: 0.7,
                      ),
                      thickness: 0.2,
                      height: 0.2,
                    ),
                  ),
                  MenuTile(
                    title: "Delete Account",
                    icon: CupertinoIcons.delete,
                    warningTile: true,
                    onTap: () {
                      Hive.deleteFromDisk();
                      context.read<MainAppCubit>().logout();
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Divider(
                      color: ColorsConstants.defaultWhite.withValues(
                        alpha: 0.7,
                      ),
                      thickness: 0.2,
                      height: 0.2,
                    ),
                  ),
                  MenuTile(
                    title: "Logout",
                    warningTile: true,
                    onTap: () {
                      context.read<MainAppCubit>().logout();
                    },
                    icon: CupertinoIcons.delete_left_fill,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
