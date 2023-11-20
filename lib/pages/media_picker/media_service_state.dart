abstract class MediaServiceState{}

class MediaServiceInitState extends MediaServiceState{}

class LoadAlbumsPermissionAllowed extends MediaServiceState{}
class LoadAlbumsPermissionDenied extends MediaServiceState{}

class AlbumsLoadedState extends MediaServiceState{}

class AssetsIsLoadingState extends MediaServiceState{}
class AssetsLoadedState extends MediaServiceState{}
class AlbumsLoadedButEmptyState extends MediaServiceState{}

class ChangeSelectedAlbumState extends MediaServiceState{}

class AssetRemovedFromSelectedListState extends MediaServiceState{}
class AssetAddedToSelectedListState extends MediaServiceState{}

class DialogVisibilityChangeState extends MediaServiceState{}