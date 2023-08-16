import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:signature/components.dart';
import 'package:signature/constants.dart';
import 'package:signature/cubit/main_cubit.dart';
import 'package:signature/cubit/main_state.dart';
import 'package:signature/pages/add_moment_screen/add_moment_screen.dart';
import 'package:signature/pages/onboarding_screen/onboarding_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) => Scaffold(
        body: ConditionalBuilder(
          condition: MainCubit.get(context).originalUser != null,
          builder: (context) => CustomScrollView(
            slivers: [
              /// Appbar
              SliverAppBar(
                elevation: 0,
                floating: true,
                toolbarHeight: height(ofHeight: 0.09),
                backgroundColor: Colors.transparent,
                flexibleSpace: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      /// Search Bar
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(height(ofHeight: 0.01)),
                          child: defaultTextFormField(
                            context,
                            noBorder: true,
                            hintText: 'Search your moments',
                            prefixIcon: const Icon(TablerIcons.search, color: Colors.black45,),
                            suffixIcon: Padding(
                              padding: EdgeInsets.all(height(ofHeight: 0.005)),
                              /// Profile
                              child: InkWell(
                                onTap: () {
                                  Future.delayed(
                                    const Duration(microseconds: 800),
                                        () {
                                      showGeneralDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        barrierLabel: 'Profile',
                                        transitionBuilder: (context, animation, secondaryAnimation, child) {
                                          Tween<Offset> tween;
                                          tween = Tween(begin: const Offset(0, -1), end: Offset.zero);
                                          return SlideTransition(
                                            position: tween.animate(CurvedAnimation(parent: animation, curve: Curves.easeOut),),
                                            child: child,
                                          );
                                        },
                                        pageBuilder: (context, animation, secondaryAnimation) => Center(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(vertical: height(ofHeight: 0.2), horizontal: width(ofWidth: 0.1)),
                                            child: Container(
                                              clipBehavior: Clip.antiAlias,
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(25)),
                                              ),
                                              child: Scaffold(
                                                body: SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      CircleAvatar(backgroundImage: NetworkImage(MainCubit.get(context).originalUser!.profilePic!), radius: height(ofHeight: 0.1)),
                                                      Text(MainCubit.get(context).originalUser!.name!),
                                                      Container(
                                                        child: defaultButton(
                                                            onPress: () {
                                                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => OnBoardingScreen(),), (route) => false);
                                                            },
                                                            text: 'Log out'
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );

                                },
                                child: CircleAvatar(backgroundColor: Colors.white,backgroundImage: NetworkImage(MainCubit.get(context).originalUser!.profilePic!)),
                              ),
                            ),
                            backgroundColor: primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              /// Body
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: 1, (context, index) => SingleChildScrollView(
                  child: Column(
                    children: List.generate(5, (index) => postCard(context)),
                  ),
                ),
                ),
              ),
            ],
          ),
          fallback: (context) => const Center(child: CircularProgressIndicator()),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: primaryColor,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddMomentScreen(),));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}



Widget postCard(context,) => Padding(
  padding: const EdgeInsets.all(15.0),
  child: Container(
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(15),
    ),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(profilePicUrl),
              ),
              const SizedBox(width: 10,),
              Expanded(child: Text('Amr Waleed', maxLines: 1, overflow: TextOverflow.ellipsis,)),
              const Spacer(),
              Text('2/10/2023 03:00AM'),
            ],
          ),
          const SizedBox(height: 10.0,),
          Text('whaaaaaaaaaaaaaaaaaaaaaaaaaaaaat evveeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeerrrrrrrrrrr :D'),
          const SizedBox(height: 10.0,),
          //if(model.postImage! != '')
          Center(child: Image.network(profilePicUrl, height: 200,)),
        ],
      ),
    ),
  ),
);

