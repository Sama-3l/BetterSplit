import 'package:bettersplitapp/core/utils/constants/theme.dart';
import 'package:bettersplitapp/features/friends/presentation/blocs/cubits/cubit/friends_page_cubit.dart';
import 'package:bettersplitapp/features/home/domain/entities/user.dart';
import 'package:bettersplitapp/features/home/domain/models/local/user_model_local.dart';
import 'package:bettersplitapp/features/top_bar_widget/screens/top_bar.dart';
import 'package:bettersplitapp/features/trip_screen/presentation/widgets/friend_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FriendsPage extends StatelessWidget {
  const FriendsPage({super.key, required this.currUser});

  final UserEntity currUser;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FriendsPageCubit, FriendsPageState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: ColorsConstants.backgroundBlack,
          body: Column(
            children: [
              TopBar(
                title: "Friends Page",
                subtitle: "People added",
                onTap: () {},
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ).copyWith(top: 24),
                  child: ListView.separated(
                    padding: EdgeInsets.zero, // ensure no extra list padding
                    separatorBuilder: (context, index) => SizedBox(height: 16),
                    itemCount: state.friends.length,
                    itemBuilder: (context, index) => FriendTile(
                      subtitle: true,
                      subtitleSize: 12,
                      titleSize: 16,
                      circleSize: 32,
                      spacing: 12,
                      user: UserModel.fromEntity(state.friends[index]).toJson(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
