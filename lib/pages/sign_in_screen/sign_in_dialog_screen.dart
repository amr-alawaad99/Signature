import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../components.dart';
import '../../constants.dart';
import '../../cubit/main_cubit.dart';
import '../../cubit/main_state.dart';
import '../home_screen/home_screen.dart';

class SignInDialogScreen extends StatelessWidget {
  const SignInDialogScreen({super.key});

  static final TextEditingController emailController = TextEditingController();
  static final TextEditingController passwordController = TextEditingController();
  static final GlobalKey<FormState>formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(40)
        ),
        child: BlocConsumer<MainCubit, MainState>(
          listener: (context, state) async {},
          builder: (context, state) => Form(
            key: formKey,
            child: Scaffold(
              // To not push the screen up when keyboard is open
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.transparent,
              body:
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Center(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          /// Title
                          Text('Sign In', style: Theme.of(context).textTheme.bodyLarge,),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                          /// Caption
                          Text('access all favorite moments you saved and bring back the memories, save new moments and access them any time!',
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: MediaQuery.of(context).size.height * 0.02),),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                          /// Email TextFormField
                          CustomInputField(
                            labelText: "Email",
                            hintText: "Enter your email address",
                            haveBorder: true,
                            filled: true,
                            controller: emailController,
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                          /// Password TextFormField
                          CustomInputField(
                            labelText: "Password",
                            hintText: "Enter your password",
                            haveBorder: true,
                            filled: true,
                            controller: passwordController,
                            suffixIcon: true,
                            obscureText: true,
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                          /// Next Button
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30), topRight: Radius.circular(30))
                            ),
                            child: defaultButton(
                              onPress: () async {
                              },
                              child: state is SendOTPLoadingState?
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CircularProgressIndicator(),
                                  SizedBox(width: MediaQuery.of(context).size.width * 0.02,),
                                  Text('Sending OTP...', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey),)
                                ],
                              ) :
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(TablerIcons.arrow_right),
                                  SizedBox(width: MediaQuery.of(context).size.width * 0.02,),
                                  Text('Next', style: Theme.of(context).textTheme.bodyMedium,)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  /// Close Button
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: -48,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.close, color: Colors.black,),
                      ),
                    ),
                  ),
                ],
              )
            ),
          ),
        ),
      ),
    );
  }
}
