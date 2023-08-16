import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:rive/rive.dart';
import 'package:signature/components.dart';
import 'package:signature/pages/register_dialog_screen/register_dialog_screen.dart';
import 'package:signature/pages/sign_in_screen/sign_in_dialog_screen.dart';

import '../../cubit/main_cubit.dart';
import '../../cubit/main_state.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});


  @override
  Widget build(BuildContext context) {
    // responsive width
    double width ({double ofWidth = 1}){
      return MediaQuery.of(context).size.width * ofWidth;
    }
    // responsive height
    double height ({double ofHeight = 1}){
      return MediaQuery.of(context).size.height * ofHeight;
    }


    return BlocProvider(
      create: (context) => MainCubit(),
      child: BlocBuilder<MainCubit, MainState>(
        builder:(context, state) =>  Scaffold(
          // To not push the screen up when keyboard is open
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              /// Rive animated background
              Positioned(
                width: height(ofHeight: 0.8),
                bottom: height(ofHeight: 0.25),
                left: width(ofWidth: 0.27),
                child: Image.asset('assets/backgrounds/spline.png'),
              ),
              const RiveAnimation.asset('assets/rive/shapes.riv'),
              /// Blur effect
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                  child: const SizedBox(),
                ),
              ),
              /// Layer on top
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: height(ofHeight: 0.05),),
                          /// Title
                          Text('Sign in & Mark Your Moment!', style: Theme.of(context).textTheme.bodyLarge,),
                          SizedBox(height: height(ofHeight: 0.02),),
                          /// Caption
                          Text('Keep your important events and memories in a safe place with Signature',
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: height(ofHeight: 0.025)),),
                          SizedBox(height: height(ofHeight: 0.1),),
                          /// Phone Number Sign in Button
                          Container(
                            child: defaultButton(
                              gradientColors: [Colors.white, Colors.white],
                              onPress: () {
                                Future.delayed(
                                  const Duration(microseconds: 800),
                                  () {
                                    showGeneralDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      barrierLabel: 'Register',
                                      transitionBuilder: (context, animation, secondaryAnimation, child) {
                                        Tween<Offset> tween;
                                        tween = Tween(begin: Offset(0, -1), end: Offset.zero);
                                        return SlideTransition(
                                          position: tween.animate(CurvedAnimation(parent: animation, curve: Curves.easeOut),),
                                          child: child,
                                        );
                                      },
                                      pageBuilder: (context, animation, secondaryAnimation) {
                                        return const SignInDialogScreen();
                                      },
                                    );
                                  },
                                );
                              },
                              height: height(ofHeight: 0.07),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.phone_android, size: height(ofHeight: 0.05),),
                                  SizedBox(width: width(ofWidth: 0.02),),
                                  Text("Sign in with Phone Number", style: TextStyle(
                                    fontSize: MediaQuery.of(context).textScaleFactor * 15,
                                    fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: height(ofHeight: 0.02),),
                          /// Google Sign in Button
                          Container(
                            child: defaultButton(
                              gradientColors: [Colors.white, Colors.white],
                              onPress: () {},
                              height: height(ofHeight: 0.07),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(TablerIcons.brand_google,color: Colors.red, size: height(ofHeight: 0.05),),
                                  SizedBox(width: width(ofWidth: 0.02),),
                                  Text("Sign in with Google", style: TextStyle(
                                      fontSize: MediaQuery.of(context).textScaleFactor * 15,
                                      fontWeight: FontWeight.bold
                                  ),),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: height(ofHeight: 0.02),),
                          Text('Don\'t have an account?', style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15),),
                          /// Register text button
                          TextButton(
                              onPressed: () {
                            Future.delayed(
                              const Duration(microseconds: 800),
                              () {
                                    showGeneralDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      barrierLabel: 'Register',
                                      transitionBuilder: (context, animation, secondaryAnimation, child) {
                                        Tween<Offset> tween;
                                        tween = Tween(begin: Offset(0, -1), end: Offset.zero);
                                        return SlideTransition(
                                          position: tween.animate(CurvedAnimation(parent: animation, curve: Curves.easeOut),),
                                          child: child,
                                        );
                                      },
                                      pageBuilder: (context, animation, secondaryAnimation) {
                                        return const RegisterDialogScreen();
                                      },
                                    );
                                  },
                            );
                          }, child: const Text('Register now!')),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }




}


