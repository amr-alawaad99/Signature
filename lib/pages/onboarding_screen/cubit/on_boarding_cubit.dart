import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signature/pages/onboarding_screen/cubit/on_boarding_state.dart';

class OnBoardingCubit extends Cubit<OnBoardingState>{

  OnBoardingCubit() : super(OnBoardingInitState());


  static OnBoardingCubit get(context) => BlocProvider.of(context);

  //  Cubit for BottomNavBar
  int currentIndex = 0;

  void changeRegisterScreen(int index) {
    currentIndex = index;
    emit(RegisterScreenChanged());
  }





}