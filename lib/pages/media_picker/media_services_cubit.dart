import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:signature/pages/media_picker/media_service_state.dart';

class MediaServicesCubit extends Cubit<MediaServiceState>{

  MediaServicesCubit() : super(MediaServiceInitState());

  static MediaServicesCubit get(context) => BlocProvider.of(context);

  /// Load albums from your device
  Future loadAlbums(RequestType requestType) async{
    var permission = await PhotoManager.requestPermissionExtend();
    List<AssetPathEntity> albumList = [];

    if(permission.isAuth == true){
      albumList = await PhotoManager.getAssetPathList(type: requestType);
      emit(LoadAlbumsPermissionAllowed());
    } else {
      PhotoManager.openSetting();
      emit(LoadAlbumsPermissionDenied());
    }
    return albumList;
  }

  /// Load Assets from a selected Album
  Future loadAssets(AssetPathEntity selectedAlbum) async{
    List<AssetEntity> assetList = await selectedAlbum.getAssetListRange(start: 0, end: await selectedAlbum.assetCountAsync);
    emit(LoadAssetsFromSelectedAlbumState());
    return assetList;
  }
}