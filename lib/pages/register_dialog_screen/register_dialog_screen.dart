import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import '../../components.dart';
import '../../constants.dart';
import '../../cubit/main_cubit.dart';
import '../../cubit/main_state.dart';
import '../home_screen/home_screen.dart';

class RegisterDialogScreen extends StatelessWidget {
  const RegisterDialogScreen({super.key});

  static final TextEditingController emailController = TextEditingController();
  static final TextEditingController passwordController = TextEditingController();
  static final TextEditingController profileNameController = TextEditingController();
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
          listener: (context, state) {
            if(state is OTPSentSuccessState){
              MainCubit.get(context).changeRegisterScreen(1);
            }
            if(state is VerifyOTPSuccessState){
              MainCubit.get(context).changeRegisterScreen(2);
            }
          },
          builder:(context, state) => Form(
            key: formKey,
            child: Scaffold(
              // To not push the screen up when keyboard is open
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.transparent,
              body:
              /// First Page
              MainCubit.get(context).registerScreenCurrentIndex == 0?
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Center(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          /// Title
                          Text(
                            'Register',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                          /// Caption
                          Text(
                            'Signature is a personal posts app where you can save your moments and favorite memories in a place that no one can touch, edit, or delete. That\'s right, not even you! In Signature, your posts cannot be deleted after one hour of posting, so make sure it truly is a moment you don’t want to forget! 😉',
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: MediaQuery.of(context).size.height * 0.02),
                          ),
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
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                          /// re-password TextFormField
                          CustomInputField(
                            hintText: "re-enter password",
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
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                          const Text('-or-'),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                          /// Google Signup Button
                          Ink(
                            height: MediaQuery.of(context).size.height * 0.07,
                            width: MediaQuery.of(context).size.height * 0.07,
                            decoration: ShapeDecoration(shape: const CircleBorder(), color: Colors.grey.shade300,),
                            child: IconButton(
                              onPressed: () {},
                              splashRadius: 30,
                              icon: Icon(TablerIcons.brand_google, color: Colors.red, size: MediaQuery.of(context).size.height * 0.05,),
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
              ) :
              /// Second Page
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /// Title
                          Text(
                            "Profile",
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: MediaQuery.of(context).size.height * 0.05),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                          /// Caption
                          Text(
                            "Get your profile ready!",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                          /// Profile Pic
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              /// Pic
                              CircleAvatar(
                                radius: MediaQuery.of(context).size.height * 0.1,
                                backgroundImage: MainCubit.get(context).profilePic == null?
                                const NetworkImage(profilePicUrl) :
                                FileImage(File(MainCubit.get(context).profilePic!.path))
                                as ImageProvider,
                              ),
                              /// Edit Button
                              Container(
                                height: MediaQuery.of(context).size.height * 0.05,
                                width: MediaQuery.of(context).size.height * 0.05,
                                decoration: ShapeDecoration(shape: const CircleBorder(), color: Colors.grey.withOpacity(0.5),),
                                child: IconButton(
                                  onPressed: () {
                                    MainCubit.get(context).selectPicFromGallery();
                                  },
                                  splashRadius: 20,
                                  padding: const EdgeInsets.only(bottom: 5),
                                  icon: Icon(TablerIcons.edit, size: MediaQuery.of(context).size.height * 0.04,),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                          /// Profile name TextFormField
                          Container(
                            child: defaultTextFormField(
                              context,
                              labelText: 'Profile Name',
                              controller: profileNameController,
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                          /// Finish Button
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30), topRight: Radius.circular(30))
                            ),
                            child: defaultButton(
                              onPress: () async {
                                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen(),), (route) => false);
                              },
                              child: state is UploadProfilePicLoadingState || state is CreateAccountLoadingState?
                              Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CircularProgressIndicator(),
                                SizedBox(width: MediaQuery.of(context).size.width * 0.02,),
                                Text('Finishing', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey),)
                              ],
                              ) :
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(TablerIcons.circle_check),
                                  SizedBox(width: MediaQuery.of(context).size.width * 0.02,),
                                  Text('Finish', style: Theme.of(context).textTheme.bodyMedium,)
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
