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

  static final TextEditingController phoneNumberController = TextEditingController();
  static final TextEditingController phoneNumberControllerTemp = TextEditingController();
  static final List<TextEditingController> otpController = List.generate(6, (index) => TextEditingController());
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
          listener: (context, state) async {
            if(state is OTPSentSuccessState){
              MainCubit.get(context).changeSignInScreen(1);
            }
            if(state is VerifyOTPSuccessState){
              await MainCubit.get(context).getUserData();
              // reset controllers on successful login
              otpController.forEach((controller) => controller.clear());
              phoneNumberControllerTemp.clear();
              phoneNumberController.clear();
              MainCubit.get(context).signInScreenCurrentIndex = 0;
              //
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen(),), (route) => false);
            }
          },
          builder: (context, state) => Form(
            key: formKey,
            child: Scaffold(
              // To not push the screen up when keyboard is open
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.transparent,
              body:
              /// First Page
              MainCubit.get(context).signInScreenCurrentIndex == 0?
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
                          /// Phone TextFormField
                          IntlPhoneField(
                            controller: phoneNumberControllerTemp,
                            initialCountryCode: 'EG',
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: secondaryColor)),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                              labelText: 'Phone Number',
                              border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                            ),
                            onChanged: (value) {
                              phoneNumberController.text = value.completeNumber;
                            },
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
                                MainCubit.get(context).sendOTP(phoneNumberController.text);
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
                            "Verification",
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: MediaQuery.of(context).size.height * 0.05),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                          /// Caption
                          Text(
                            "Enter OTP code sent to your number ${phoneNumberController.text}",
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
                                  controller: otpController[index],
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
                                ),
                              )),
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                          /// Sign In Button
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30), topRight: Radius.circular(30))
                            ),
                            child: defaultButton(
                              onPress: () {
                                String otp = '';
                                otpController.forEach((element) {
                                  otp += element.text;
                                });
                                MainCubit.get(context).verifyOTP(verificationId: MainCubit.get(context).myVerificationId!, otpCode: otp);
                                print("/////////////////////////$otp");
                              },
                              child: state is VerifyOTPLoadingState?
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CircularProgressIndicator(),
                                  SizedBox(width: MediaQuery.of(context).size.width * 0.02,),
                                  Text('Verifying OTP', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey),)
                                ],
                              ) :
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(TablerIcons.arrow_right),
                                  SizedBox(width: MediaQuery.of(context).size.width * 0.02,),
                                  Text('Sign In', style: Theme.of(context).textTheme.bodyMedium,)
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                          /// Change phone number TextButton
                          TextButton(
                            onPressed: () {
                              MainCubit.get(context).changeSignInScreen(0);
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
