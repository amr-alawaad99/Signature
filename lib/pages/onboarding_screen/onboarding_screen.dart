import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:rive/rive.dart';
import 'package:signature/components.dart';
import 'package:signature/constants.dart';
import 'package:signature/pages/home_screen/home_screen.dart';
import 'package:signature/pages/onboarding_screen/cubit/on_boarding_state.dart';
import 'package:signature/pages/onboarding_screen/cubit/on_boarding_cubit.dart';

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
      create: (context) => OnBoardingCubit(),
      child: BlocBuilder<OnBoardingCubit, OnBoardingState>(
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
                          Text('Sign in & Mark Your Moments!', style: Theme.of(context).textTheme.bodyLarge,),
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
                                      () {phoneSignIn(context);},
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
                          /// Register text button
                          Text('Don\'t have an account?', style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15),),
                          TextButton(onPressed: () {
                            Future.delayed(
                              const Duration(microseconds: 800),
                                  () {register(context);},
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


Future<Object?> phoneSignIn(context) => showGeneralDialog(
  context: context,
  barrierDismissible: true,
  barrierLabel: 'Sign in',
  transitionBuilder: (context, animation, secondaryAnimation, child) {
    Tween<Offset> tween;
    tween = Tween(begin: const Offset(0, -1), end: Offset.zero);
    return SlideTransition(
      position: tween.animate(CurvedAnimation(parent: animation, curve: Curves.easeOut),),
      child: child,
    );
  },
  pageBuilder: (context, animation, secondaryAnimation) => Center(
    child: Container(
      height: MediaQuery.of(context).size.height * 0.8,
      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
      padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(40)
      ),
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          // To not push the screen up when keyboard is open
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: Stack(
            clipBehavior: Clip.none,
            children: [
              Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text('Sign In', style: Theme.of(context).textTheme.bodyLarge,),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                      Text('access all favorite moments you saved and bring back the memories, save new moments and access them any time!',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: MediaQuery.of(context).size.height * 0.02),),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.08,
                        child: defaultTextFormField(
                          context,
                          labelText: 'Phone Number',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30), topRight: Radius.circular(30))
                        ),
                        child: defaultButton(
                          onPress: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(TablerIcons.arrow_right),
                              SizedBox(width: MediaQuery.of(context).size.width * 0.02,),
                              Text('Sign in', style: Theme.of(context).textTheme.bodyMedium,)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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


Future<Object?> register(context) => showGeneralDialog(
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
    return Center(
    child: Container(
      height: MediaQuery.of(context).size.height * 0.8,
      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
      padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(40)
      ),
      child: GestureDetector(
        onTap: () {
          // to dismiss keyboard on tapping out of the TFF
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: BlocBuilder<OnBoardingCubit, OnBoardingState>(
          builder:(context, state) => Scaffold(
            // To not push the screen up when keyboard is open
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            body:
            OnBoardingCubit.get(context).currentIndex == 0?
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
                          'access all favorite moments you saved and bring back the memories, save new moments and access them any time!',
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: MediaQuery.of(context).size.height * 0.02),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                        /// Phone TextFormField
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.08,
                          child: defaultTextFormField(
                            context,
                            labelText: 'Phone Number',
                            keyboardType: TextInputType.number,
                          ),
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
                            onPress: () {
                              OnBoardingCubit.get(context).changeRegisterScreen(1);
                            },
                            child: Row(
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
                            padding: const EdgeInsets.only(bottom: 5),
                            icon: Icon(TablerIcons.brand_google, color: Colors.red, size: MediaQuery.of(context).size.height * 0.05,),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
            OnBoardingCubit.get(context).currentIndex == 1?
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
                          "Verification",
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: MediaQuery.of(context).size.height * 0.05),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                        /// Caption
                        Text(
                          "Enter OTP code sent to your number +201093247769",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                        /// OTP TextFormField
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.07,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(6, (index) => SizedBox(
                              width: MediaQuery.of(context).size.width * 0.12,
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: const InputDecoration(
                                  enabledBorder: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
                                ),
                                onChanged: (value) {
                                  if(value.isNotEmpty){
                                    FocusScope.of(context).nextFocus();
                                  } else if(value.isEmpty){
                                    FocusScope.of(context).previousFocus();
                                  }
                                },
                                onTap: () {
                                  print(1);
                                },
                              ),
                            )),
                          ),
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
                            onPress: () {
                              OnBoardingCubit.get(context).changeRegisterScreen(2);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(TablerIcons.arrow_right),
                                SizedBox(width: MediaQuery.of(context).size.width * 0.02,),
                                Text('Next', style: Theme.of(context).textTheme.bodyMedium,)
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                        /// Change phone number TextButton
                        TextButton(
                          onPressed: () {
                            OnBoardingCubit.get(context).changeRegisterScreen(0);
                          },
                          child: Text(
                            "Change Phone Number",
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.blue),
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
                            CircleAvatar(
                              radius: MediaQuery.of(context).size.height * 0.1,
                              backgroundImage: NetworkImage(profilePicUrl),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.05,
                              width: MediaQuery.of(context).size.height * 0.05,
                              decoration: ShapeDecoration(shape: const CircleBorder(), color: Colors.grey.withOpacity(0.5),),
                              child: IconButton(
                                onPressed: () {},
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
                            labelText: 'Profile Name'
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30), topRight: Radius.circular(30))
                          ),
                          child: defaultButton(
                            onPress: () {
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen(),), (route) => false);
                            },
                            child: Row(
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
  },
);