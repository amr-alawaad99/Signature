
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:ntp/ntp.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:signature/constants.dart';
import 'package:signature/cubit/main_cubit.dart';
import 'package:signature/cubit/main_state.dart';
import 'package:signature/pages/media_viewer/media_viewer.dart';

import '../../components.dart';

class AddMomentScreen extends StatelessWidget {
  AddMomentScreen({super.key});

  static final TextEditingController textController = TextEditingController();
  final String dateTimeNow = DateTime.now().toString().substring(0,19);

  // to get the time from ntp API
  DateTime ntpTime = DateTime.now();
  Future localNTPTime() async {
    ntpTime = await NTP.now();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainState>(
      listener: (context, state) {
        if(state is UploadPostSuccessState){
          MainCubit.get(context).selectedAssets = [];
          textController.text = '';
          Navigator.pop(context);
        }
      },
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: Text(
            "New Event",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 23),
          ),
          actions: [
            if(state is UploadPostLoadingState)
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: defaultButton(
                  onPress: () async {},
                  width: 100,
                  gradientColors: [primaryColor, primaryColor],
                  child: const CircularProgressIndicator(color: Colors.white,),
                ),
              ),
            if(state is !UploadPostLoadingState)
              Padding(
              padding: const EdgeInsets.all(4.0),
              child: defaultButton(
                onPress: () async {
                  List<AssetEntity> list = MainCubit.get(context).selectedAssets;
                  List<File> files = [];
                  for (AssetEntity element in list) {
                    File? file = await element.file;
                    files.add(file!);
                  }
                  await localNTPTime();
                  await MainCubit.get(context).uploadPost(
                    file: files,
                    dateTime: ntpTime.toUtc().toString(),
                    text: textController.text,
                  );
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
              /// Post input text
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
              /// Post Images/Videos
              if(MainCubit.get(context).selectedAssets.isNotEmpty)
                Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height*0.43,
                  child: GridView.builder(
                    itemCount: MainCubit.get(context).selectedAssets.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      AssetEntity assetEntity = MainCubit.get(context).selectedAssets[index];
                      List<File> files = MainCubit.get(context).files;
                      return Padding(
                        padding:
                        const EdgeInsets.all(2.0),
                        child: Stack(
                          children: [
                            /// Images Builder
                            Positioned.fill(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) =>
                                          Scaffold(
                                            appBar: AppBar(),
                                            body: PageView.builder(
                                              itemCount: files.length,
                                              controller: PageController(initialPage: index),
                                              itemBuilder: (context, index) => MediaViewer(
                                                  file: files[index],assetType: MainCubit.get(context).selectedAssets[index].type
                                              ),
                                            ),
                                          ),
                                      ),
                                  );
                                },
                                child: AssetEntityImage(
                                  assetEntity,
                                  isOriginal: false,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.error, color: Colors.red,),),
                                ),
                              ),
                            ),
                            /// Video Icon On Video Assets
                            if(assetEntity.type == AssetType.video)
                              const Positioned.fill(
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Icon(Icons.video_camera_back, color: Colors.red,),
                                ),
                              ),
                              ),
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: () {
                                    MainCubit.get(context).removeAssetFromList(index: index);
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(Icons.close, color: Colors.white,),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  ),
                ),
              )
            ],
          ),
        ),
        /// Open Gallery BottomSheet
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
            // MainCubit.get(context).selectImages();
            MainCubit.get(context).pickAssets(context, maxCount: 10, requestType: RequestType.common);
          },
        ),
      ),
    );
  }
}
