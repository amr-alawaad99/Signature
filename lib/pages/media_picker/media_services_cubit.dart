//
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:photo_manager/photo_manager.dart';
// import 'package:signature/pages/media_picker/media_service_state.dart';
//
// class MediaServicesCubit extends Cubit<MediaServiceState>{
//
//   MediaServicesCubit() : super(MediaServiceInitState());
//
//   static MediaServicesCubit get(context) => BlocProvider.of(context);
//
//   /// Load albums from your device
//   Future loadAlbums(RequestType requestType) async{
//     var permission = await PhotoManager.requestPermissionExtend();
//     List<AssetPathEntity> albumList = [];
//
//     if(permission.isAuth == true){
//       albumList = await PhotoManager.getAssetPathList(type: requestType);
//       emit(LoadAlbumsPermissionAllowed());
//     } else {
//       PhotoManager.openSetting();
//       emit(LoadAlbumsPermissionDenied());
//     }
//     return albumList;
//   }
//
//   /// Load Assets from a selected Album
//   Future loadAssets(AssetPathEntity selectedAlbum) async{
//     emit(AssetsIsLoadingState());
//     List<AssetEntity> assetList = await selectedAlbum.getAssetListRange(start: 0, end: selectedAlbum.assetCount);
//     return assetList;
//   }
//
//
//   /// Get First Album
//   AssetPathEntity? selectedAlbum;
//   List<AssetPathEntity> albumList = [];
//   List<AssetEntity> assetList = [];
//   Future<void> getFirstAlbum({
//     required RequestType requestType,
// }) async {
//     await loadAlbums(requestType).then((value) {
//       albumList = value;
//       selectedAlbum = value[0];
//       emit(AlbumsLoadedState());
//       loadAssets(selectedAlbum!).then((value) {
//         assetList = value;
//         emit(AssetsLoadedState());
//       });
//     });
//   }
//
//
//   /// Change Selected Album
//   changeSelectedAlbum({
//     required AssetPathEntity? value,
// }){
//     selectedAlbum = value;
//     loadAssets(selectedAlbum!).then((value) {
//       assetList = value;
//       emit(ChangeSelectedAlbumState());
//     });
//   }
//
//   /// add selected assets to a list
//   List<AssetEntity> selectedAssetList = [];
//   void selectAsset({
//     required int maxCount,
//     required AssetEntity assetEntity,
// }){
//     if(selectedAssetList.contains(assetEntity)){
//       selectedAssetList.remove(assetEntity);
//       emit(AssetRemovedFromSelectedListState());
//     } else if(selectedAssetList.length < maxCount){
//       selectedAssetList.add(assetEntity);
//       emit(AssetAddedToSelectedListState());
//     }
//   }
//
//   /// Convert seconds to HH:MM:SS format
//   String secondsToTime(int seconds){
//     int hours;
//     int min;
//     int sec;
//     sec = seconds%60;
//     if((seconds/60).truncate() < 60){
//       min = (seconds/60).truncate();
//       hours = 0;
//     } else {
//       hours = ((seconds/60).truncate() / 60).truncate();
//       min = (seconds/60).truncate() % 60;
//     }
//     return '${hours>0?'${hours.toString().padLeft(2, '0')}:' : ''}${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
//   }
//
//
//
// }