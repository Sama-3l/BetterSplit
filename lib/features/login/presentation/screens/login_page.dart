// lib/features/auth/presentation/pages/login_page.dart
import 'package:bettersplitapp/core/utils/common/buttons/primary_button.dart';
import 'package:bettersplitapp/core/utils/common/textfield.dart';
import 'package:bettersplitapp/core/utils/constants/theme.dart';
import 'package:bettersplitapp/features/top_bar_widget/screens/top_bar.dart';
import 'package:bettersplitapp/features/login/presentation/blocs/cubits/cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();

    return Scaffold(
      backgroundColor: ColorsConstants.backgroundBlack, // theme.backgroundBlack
      body: Column(
        children: [
          // TopBar
          TopBar(
            title: "Create Account",
            subtitle: "Get Started!",
            onTap: () {},
            topPadding: 72,
          ),

          Expanded(
            child: BlocBuilder<LoginCubit, LoginState>(
              builder: (context, state) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Action buttons (Cancel, Apply)
                      Container(
                        decoration: BoxDecoration(
                          color: ColorsConstants.accentGreen,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(32),
                            bottomRight: Radius.circular(32),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                          ).copyWith(bottom: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: PrimaryButton(
                                  secondary: true,
                                  title: "Cancel",
                                  onTap: () => cubit.clear(),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: PrimaryButton(
                                  title: "Apply",
                                  onTap: () => cubit.saveUser(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Input fields
                      InputField(
                        controller: state.nameController,
                        hintText: "Raghvendra Mishra",
                        title: 'Name',
                      ),
                      const SizedBox(height: 16),
                      InputField(
                        controller: state.usernameController,
                        hintText: "Samael",
                        title: 'Username',
                      ),
                      const SizedBox(height: 16),
                      InputField(
                        textInputType: TextInputType.number,
                        controller: state.phoneNumberController,
                        hintText: "1234-5678-90",
                        title: 'Phone Number',
                      ),
                      const SizedBox(height: 16),
                      InputField(
                        controller: state.upiIDController,
                        textCapitalization: TextCapitalization.none,
                        hintText: 'raghvendramishra2002@okaxis',
                        title: 'UPI ID',
                      ),
                    ],
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
