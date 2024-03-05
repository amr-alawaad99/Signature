abstract class MainState {}

class OnBoardingInitState extends MainState {}

class RegisterScreenChanged extends MainState {}

class SignInScreenChanged extends MainState {}

class SendOTPLoadingState extends MainState {}

class OTPSentSuccessState extends MainState {}

class OTPSentErrorState extends MainState {
  final String error;

  OTPSentErrorState(this.error);
}

class VerifyOTPLoadingState extends MainState {}

class VerifyOTPSuccessState extends MainState {}

class VerifyOTPErrorState extends MainState {}

class CreateAccountLoadingState extends MainState {}

class CreateAccountSuccessState extends MainState {}

class CreateAccountErrorState extends MainState {}

class SelectPicFromGallerySuccessState extends MainState {}

class SelectPicFromGalleryErrorState extends MainState {}

class UploadProfilePicLoadingState extends MainState {}

class UploadProfilePicSuccessState extends MainState {}

class UploadProfilePicErrorState extends MainState {}

class UpdateProfileLoadingState extends MainState {}

class UpdateProfileSuccessState extends MainState {}

class UpdateProfileErrorState extends MainState {}

class GetUserDataLoadingState extends MainState {}

class GetUserDataSuccessState extends MainState {}

class SelectMultipleImagesSuccessState extends MainState {}

class SelectMultipleImagesErrorState extends MainState {}

class ClearImageSuccessState extends MainState {}

class MultipleImagesUploadedState extends MainState {}

class MultipleAssetsSelectedState extends MainState {}
class NoAssetsSelectedState extends MainState {}

class AssetRemovedFromAssetListState extends MainState {}

class UploadPostLoadingState extends MainState {}
class UploadPostSuccessState extends MainState {}

class DeletePostLoadingState extends MainState {}
class DeletePostSuccessState extends MainState {}
class DeletePostErrorState extends MainState {}


class UpdateTimeState extends MainState {}

class RefreshState extends MainState {}

class SignOutSuccessState extends MainState {}


