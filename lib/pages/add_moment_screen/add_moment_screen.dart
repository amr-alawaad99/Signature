
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:signature/constants.dart';
import 'package:signature/cubit/main_cubit.dart';

import '../../components.dart';

class AddMomentScreen extends StatelessWidget {
  AddMomentScreen({super.key});

  static final TextEditingController textController = TextEditingController();
  final String dateTimeNow = DateTime.now().toString().substring(0,19);


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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextFormField(
              maxLines: 15,
              minLines: 1,
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
            if(MainCubit.get(context).imageFileList!.isNotEmpty)
              Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height*0.43,
                child: GridView.builder(
                  itemCount: MainCubit.get(context).imageFileList!.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                  itemBuilder: (context, index) =>
                      Padding(
                        padding:
                        const EdgeInsets.all(2.0),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(File(MainCubit.get(context).imageFileList![index].path),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              right: 0,
                              child: IconButton(
                                onPressed: () {
                                  MainCubit.get(context).clearImage(index);
                                },
                                icon: const Icon(Icons.highlight_remove_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                ),
              ),
            )
          ],
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
          MainCubit.get(context).selectImages();
        },
      ),
    );
  }
}
