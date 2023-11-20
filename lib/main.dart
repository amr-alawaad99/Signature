import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signature/constants.dart';
import 'package:signature/cubit/main_state.dart';
import 'package:signature/pages/home_screen/home_screen.dart';
import 'package:signature/pages/onboarding_screen/onboarding_screen.dart';

import 'bloc_observer.dart';
import 'cache_helper.dart';
import 'cubit/main_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();
  Bloc.observer = MyBlocObserver();


  uID = CacheHelper.getData(key: 'uId') ?? '';

  Widget widget;

  print("GGG $uID");
  if (uID == '') {
    widget = const OnBoardingScreen();
  } else {
    widget = const HomeScreen();
  }

  runApp(MyApp(widget));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;
  const MyApp(this.startWidget, {super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) {
          if(uID == ''){
            return MainCubit();
          } else {
            return MainCubit()..getUserData();
          }
        },),
      ],
      child: BlocBuilder<MainCubit, MainState>(
        builder: (context, state) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: false, // flutter 3.16 update fks up the UI with the new Material3 so we disable it
            fontFamily: 'Poppins',
            textTheme: TextTheme(
              bodyLarge: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.07,
                fontWeight: FontWeight.bold,
                wordSpacing: 2
              ),
              bodyMedium: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.023,
              ),
              bodySmall: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.02,
              )
            )
          ),
          home: startWidget,
        ),
      ),
    );
  }
}
