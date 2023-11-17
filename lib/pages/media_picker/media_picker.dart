import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:signature/pages/media_picker/media_service_state.dart';
import 'package:signature/pages/media_picker/media_services_cubit.dart';

class MediaPicker extends StatelessWidget {
  final int maxCount;
  final RequestType requestType;
  const MediaPicker(this.maxCount, this.requestType, {super.key});


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MediaServicesCubit()..getFirstAlbum(requestType: requestType),
      child: BlocBuilder<MediaServicesCubit, MediaServiceState>(
        builder: (context, state) {
          return ConditionalBuilder(
            condition: MediaServicesCubit.get(context).assetList.isNotEmpty,
            builder: (context) => Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                elevation: 0,
                title: DropdownButton<AssetPathEntity>(
                  value: MediaServicesCubit.get(context).selectedAlbum,
                  onChanged: (AssetPathEntity? value){
                    MediaServicesCubit.get(context).changeSelectedAlbum(value: value);
                  },
                  items: MediaServicesCubit.get(context).albumList.map<DropdownMenuItem<AssetPathEntity>>((AssetPathEntity album) {
                    return DropdownMenuItem<AssetPathEntity>(
                      value: album,
                      child: Text(
                        '${album.name} (${album.assetCount})',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13),
                      ),
                    );
                  }).toList(),
                ),
                actions: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context, MediaServicesCubit.get(context).selectedAssetList);
                    },
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: Text('OK'),
                      ),
                    ),
                  )
                ],
              ),
              body: state is AssetsIsLoadingState?
              const Center(child: CircularProgressIndicator(),) :
              GridView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: MediaServicesCubit.get(context).assetList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) {
                  AssetEntity assetEntity = MediaServicesCubit.get(context).assetList[index];
                  return Padding(
                    padding: const EdgeInsets.all(2),
                    child: GestureDetector(
                      /// Show asset as Dialog on long press
                      onLongPress: () => showDialog(context: context,
                        builder: (context) => AlertDialog(
                            contentPadding: EdgeInsets.zero, insetPadding: EdgeInsets.zero,
                            content: AssetEntityImage(assetEntity, fit: BoxFit.cover,),
                        ),
                      ),
                      child: assetWidget(context, assetEntity),
                    ),
                  );
                },
              ),
            ),
            fallback: (context) => Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                elevation: 0,
                title:  DropdownButton(items: const [DropdownMenuItem(child: Text('Recent'))], onChanged: (value) {},),
              ),
              body: const Center(child: CircularProgressIndicator()),
            ),
          );
        }
      ),
    );
  }


  Widget assetWidget(context, AssetEntity assetEntity) => Stack(
    children: [
      /// Build Asset
      Positioned.fill(
        child: Padding(
          padding: EdgeInsets.all(MediaServicesCubit.get(context).selectedAssetList.contains(assetEntity) == true? 5 : 0),
          child: GestureDetector(
            onTap: () => MediaServicesCubit.get(context).selectAsset(assetEntity: assetEntity, maxCount: maxCount),
            child: AssetEntityImage(
              assetEntity,
              isOriginal: false,
              thumbnailSize: const ThumbnailSize.square(150),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.error, color: Colors.red,)),
            ),
          ),
        ),
      ),
      /// Video Icon on the Video Assets
      if(assetEntity.type == AssetType.video)
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(MediaServicesCubit.get(context).secondsToTime(assetEntity.duration), style: const TextStyle(color: Colors.white)),
            ),
          ),
        ),
      /// Selected Asset Indicator Icon
      Positioned.fill(
        child: Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            onTap: () {
              MediaServicesCubit.get(context).selectAsset(assetEntity: assetEntity, maxCount: maxCount);
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  color: MediaServicesCubit.get(context).selectedAssetList.contains(assetEntity)? Colors.blue : Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    '${MediaServicesCubit.get(context).selectedAssetList.indexOf(assetEntity) + 1}',
                    style: TextStyle(
                      color: MediaServicesCubit.get(context).selectedAssetList.contains(assetEntity)? Colors.white : Colors.transparent,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );

}
