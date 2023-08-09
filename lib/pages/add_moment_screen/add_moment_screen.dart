
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:signature/constants.dart';

import '../../components.dart';

class AddMomentScreen extends StatelessWidget {

  var textController = TextEditingController();
  var dateTimeNow = DateTime.now().toString().substring(0,19);

  AddMomentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "New Event",
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 23),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: defaultButton(
              onPress: () {

              },
              width: 100,
              gradientColors: [primaryColor, primaryColor],
              text: "Post",
            ),
          ),
        ],
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              // if(state is SocialCreatePostLoadingState)
              //   const LinearProgressIndicator(),
              // if(state is SocialCreatePostLoadingState)
              //   const SizedBox(
              //     height: 10.0,
              //   ),
              TextFormField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "What is happening!",
                  hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                ),
                controller: textController,
              ),
              // if(HomeCubit.get(context).postImage != null)
              //   Stack(
              //     alignment: AlignmentDirectional.bottomStart,
              //     children: [
              //       Align(
              //         alignment: AlignmentDirectional.topCenter,
              //         child: Stack(
              //           alignment: AlignmentDirectional.topEnd,
              //           children: [
              //             Container(
              //               height: 140.0,
              //               width: double.infinity,
              //               decoration: BoxDecoration(
              //                 image: DecorationImage(
              //                   image: FileImage(HomeCubit.get(context).postImage!),
              //                   fit: BoxFit.cover,
              //                 ),
              //                 borderRadius: BorderRadius.circular(4.0,
              //                 ),
              //               ),
              //             ),
              //             IconButton(
              //               onPressed: () {
              //                 HomeCubit.get(context).removePostImage();
              //               },
              //               icon: const CircleAvatar(
              //                 child: Icon(
              //                   Icons.close,
              //                   size: 20.0,
              //                 ),
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
            ],
          ),
        ),
      ),
      bottomSheet: InkWell(
        child: Container(
          height: 60,
          width: double.infinity,
          decoration: const BoxDecoration(
              border: BorderDirectional(top: BorderSide(color: Colors.grey))
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Icon(
                  TablerIcons.photo,
                  color: Colors.green,
                  size: 40,
                ),
              ),
              SizedBox(width: 15,),
              Text("Gallery", style: TextStyle( fontFamily: 'Inspiration' ,fontSize: 35, fontWeight: FontWeight.bold),),
            ],
          ),
        ),
        onTap: () {
          // HomeCubit.get(context).getPostImage();
        },
      ),
    );
  }
}
