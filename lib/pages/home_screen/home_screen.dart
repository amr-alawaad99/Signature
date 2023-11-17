import 'dart:async';
import 'dart:io';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:signature/components.dart';
import 'package:signature/constants.dart';
import 'package:signature/cubit/main_cubit.dart';
import 'package:signature/cubit/main_state.dart';
import 'package:signature/models/post_model.dart';
import 'package:signature/models/user_model.dart';
import 'package:signature/pages/add_moment_screen/add_moment_screen.dart';
import 'package:signature/pages/media_viewer/media_viewer_from_url.dart';
import 'package:signature/pages/onboarding_screen/onboarding_screen.dart';

import '../media_viewer/media_viewer.dart';

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
      builder: (context, state) {
        return ConditionalBuilder(
          condition: MainCubit.get(context).originalUser != null,
          builder: (context) => Scaffold(
            body: CustomScrollView(
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
                StreamBuilder<List<PostModel>>(
                    stream: MainCubit.get(context).getPosts(),
                    builder: (context, snapshot) {
                      if(snapshot.hasError){
                        return Text('Something went wrong! ${snapshot.error}');
                      } else if(snapshot.hasData){
                        final posts = snapshot.data!.reversed;
                        return SliverList.list(
                          children: posts.map((e) {
                            return postCard(context, MainCubit.get(context).originalUser!, e);
                          }).toList(),
                        );
                      } else {
                        return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
                      }
                    },
                  ),

              ],
            ),

            floatingActionButton: FloatingActionButton(
              backgroundColor: primaryColor,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddMomentScreen(),));
              },
              child: const Icon(Icons.add),
            ),
          ),
          fallback: (context) => const CircularProgressIndicator(),

        );},
    );
  }
}

enum UrlType { IMAGE, VIDEO, UNKNOWN }

UrlType getUrlType(String url) {
  Uri uri = Uri.parse(url);
  String typeString = uri.path.substring(uri.path.length - 3).toLowerCase();
  if (typeString == "jpg" || typeString == 'peg') {
    return UrlType.IMAGE;
  }
  if (typeString == "mp4") {
    return UrlType.VIDEO;
  } else {
    return UrlType.UNKNOWN;
  }
}


// to get the time from ntp API
DateTime ntpTime = DateTime.now();
Future localNTPTime() async {
  ntpTime = await NTP.now();
}

Widget postCard(context,UserModel userModel , PostModel postModel,) => Padding(
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
          /// avatar, name, time, and dialog button
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(userModel.profilePic!),
              ),
              const SizedBox(width: 10,),
              Expanded(child: Text(userModel.name!, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold),)),
              SizedBox(width: MediaQuery.of(context).size.width * 0.03,),
              Text(DateFormat.jm().format(DateTime.parse(postModel.dateTime!).toLocal()).toString()),
              SizedBox(width: MediaQuery.of(context).size.width * 0.03,),
              // postModel.isEditable == true?
              IconButton(
                onPressed: () async {
                  await localNTPTime();
                  /// to check if the post was posted 30min ago or longer
                  if(ntpTime.toUtc().difference(DateTime.parse(postModel.dateTime!)).inMinutes >= 30) {
                    showDialog(
                      context: context,
                      builder: (context) => Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              MaterialButton(
                                onPressed: () {},
                                child: Text("Open"),
                                minWidth: MediaQuery.of(context).size.width * 0.7,
                                height: MediaQuery.of(context).size.width * 0.1,
                              ),
                              Divider(color: Colors.grey,),
                              Container(
                                height: MediaQuery.of(context).size.width * 0.1,
                                child: Center(
                                  child: Text("This post can not be deleted!",
                                  style: Theme.of(context).textTheme.labelLarge,
                                  textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  else {
                    showDialog(
                      context: context,
                      builder: (context) => Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              MaterialButton(
                                onPressed: () {},
                                child: Text("Open"),
                                minWidth: MediaQuery.of(context).size.width * 0.7,
                                height: MediaQuery.of(context).size.width * 0.1,
                              ),
                              Divider(color: Colors.grey,),
                              MaterialButton(
                                onPressed: () {},
                                child: Text("Delete Post"),
                                minWidth: MediaQuery.of(context).size.width * 0.7,
                                height: MediaQuery.of(context).size.width * 0.1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
              },
                icon: const Icon(TablerIcons.dots_vertical),
              ),

            ],
          ),
          /// text and pics/vid
          if(postModel.text! != '')
            const SizedBox(height: 10.0,),
          if(postModel.text! != '')
            Text(postModel.text!),
          const SizedBox(height: 10.0,),
          if(postModel.urls != '')
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemCount: postModel.urls!.split(',').length -1 > 4? 4 : postModel.urls!.split(',').length -1,
              itemBuilder: (context, index) {
                List<String> urls = postModel.urls!.split(',');
                urls.removeLast();
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) =>
                          Scaffold(
                            appBar: AppBar(),
                            body: PageView.builder(
                              itemCount: urls.length,
                              controller: PageController(initialPage: index),
                              itemBuilder: (context, index) => MediaViewerFromURL(
                                  url: urls[index],assetType: getUrlType(urls[index]) == UrlType.IMAGE? AssetType.image : AssetType.video
                              ),
                            ),
                          ),
                      ),
                    );
                  },
                  child: getUrlType(urls[index]) == UrlType.IMAGE? Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: urls.length > 4 && index == 3? Stack(
                      children: [
                        Image.network(urls[index], fit: BoxFit.cover, filterQuality: FilterQuality.none, width: double.infinity, height: double.infinity,),
                        Center(
                          child: Container(
                            color: Colors.black.withOpacity(0.5),
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("+${urls.length - 3}", style: TextStyle(fontSize: 50, color: Colors.white,), textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                        ),
                      ],):Image.network(urls[index], fit: BoxFit.cover, filterQuality: FilterQuality.none),
                  ) :
                  Stack(
                    fit: StackFit.expand,
                    alignment: Alignment.center,
                    children: [
                      FutureBuilder(
                        future: MainCubit.get(context).getVideoThumbnail(urls[index]),
                        builder:(context, snapshot) {
                          if(snapshot.hasError){
                            return Text('Something went wrong! ${snapshot.error}');
                          } else if (snapshot.hasData) {
                            return Image.file(
                              File(snapshot.data!), fit: BoxFit.cover,);
                          } else {
                            return Container( height: MediaQuery.of(context).size.aspectRatio, color: Colors.grey.withOpacity(0.8),);
                          }

                        }
                      ),
                      Icon(Icons.play_arrow, color: Colors.grey.withOpacity(0.8), size: MediaQuery.of(context).size.aspectRatio * 250,)
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    ),
  ),
);

