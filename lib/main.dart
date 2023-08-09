import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signature/pages/onboarding_screen/cubit/on_boarding_cubit.dart';
import 'package:signature/pages/onboarding_screen/onboarding_screen.dart';

import 'bloc_observer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => OnBoardingCubit(),),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
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
        home: const OnBoardingScreen(),
      ),
    );
  }
}
