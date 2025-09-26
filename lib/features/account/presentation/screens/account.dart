import 'package:bettersplitapp/core/utils/constants/theme.dart';
import 'package:bettersplitapp/features/home/domain/entities/user.dart';
import 'package:bettersplitapp/features/top_bar_widget/screens/top_bar.dart';
import 'package:bettersplitapp/features/top_bar_widget/screens/top_bar_widgets.dart';
import 'package:flutter/material.dart';

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
          TopBarWidgets(currentTab: 2, debts: [], user: currUser),
        ],
      ),
    );
  }
}
