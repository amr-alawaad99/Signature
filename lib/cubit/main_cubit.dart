import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:signature/constants.dart';
import 'package:signature/models/post_model.dart';
import 'package:signature/models/user_model.dart';
import 'package:signature/pages/media_picker/media_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../components.dart';
import '../cache_helper.dart';
import 'main_state.dart';

class MainCubit extends Cubit<MainState>{

  MainCubit() : super(OnBoardingInitState());


  static MainCubit get(context) => BlocProvider.of(context);

  /// Change Sign In Screen
  int signInScreenCurrentIndex = 0;

  void changeSignInScreen(int index) {
    signInScreenCurrentIndex = index;
    emit(SignInScreenChanged());
  }

  /// Change Register Screen
  int registerScreenCurrentIndex = 0;

  void changeRegisterScreen(int index) {
    registerScreenCurrentIndex = index;
    emit(RegisterScreenChanged());
  }

  /// Send OTP to phone number
  String? myVerificationId;
  void sendOTP(String phoneNumber) async {
    emit(SendOTPLoadingState());
    FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,

        verificationCompleted: (PhoneAuthCredential credential) async {
          print("VERFICATION COMPLETED SUCCESSFULLLLLLLLLLLLLLLYYYYYYYYYYY");
        },

        verificationFailed: (FirebaseAuthException e) {
          if (e.code == "invalid-phone-number") {
            showToast(message: "Invalid phone number", toastColor: Colors.red);
            emit(OTPSentErrorState(e.toString()));
          } else {
            showToast(message: e.message.toString(), toastColor: Colors.red);
            emit(OTPSentErrorState(e.toString()));
          }
        },

        codeSent: (verificationId, forceResendingToken) {
          myVerificationId = verificationId;
          showToast(
              message: "a verification code has been sent to your phone number",
              toastColor: Colors.greenAccent);
          emit(OTPSentSuccessState());
        },

        codeAutoRetrievalTimeout: (verificationId) {},

        timeout: const Duration(seconds: 60));
  }

  /// Verify OTP
  void verifyOTP({
    required String verificationId,
    required String otpCode,
  }) async {
    emit(VerifyOTPLoadingState());
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otpCode,
    );
    FirebaseAuth.instance.signInWithCredential(credential).then((value) {
      uID = value.user!.uid;
      CacheHelper.saveData(key: 'uId', value: value.user!.uid);
      emit(VerifyOTPSuccessState());
    }).catchError((error) {
          emit(VerifyOTPErrorState());
          showToast(message: error.toString(), toastColor: Colors.red);
    });
  }

  /// Choose Pic from device using ImagePicker
  File? profilePic;
  ImagePicker picker = ImagePicker();

  Future<void> selectPicFromGallery() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      profilePic = File(image.path);
      emit(SelectPicFromGallerySuccessState());
    } else {
      print('select pic from gallery ERROR!');
      emit(SelectPicFromGalleryErrorState());
    }
  }

  /// Upload picked picture to Firebase storage
  String? picUrl;
  Future<void> uploadProfilePic() async {
    emit(UploadProfilePicLoadingState());
    await FirebaseStorage.instance
        .ref()
        .child(
        'users/$uID/profile_pictures/${Random().nextInt(999999)}${Uri.file(profilePic!.path).pathSegments.last}')
        .putFile(profilePic!)
        .then((value) async {
      await value.ref.getDownloadURL().then((value2) {
        picUrl = value2;
        emit(UpdateProfileSuccessState());
      }).catchError((error) {
        print('1:');
        emit(UploadProfilePicErrorState());
      });
    }).catchError((error) {
      print("2:");
      emit(UploadProfilePicErrorState());
    });
  }

  /// Create User in the DB (Firestore)
  createUser({
    required String name,
    required String profilePic,
}) async {
    emit(CreateAccountLoadingState());
    String uId = FirebaseAuth.instance.currentUser!.uid;
    UserModel userModel = UserModel(uId: uId, name: name, profilePic: profilePic);
    await FirebaseFirestore.instance.collection('users').doc(uId).set(userModel.toMap()).then((value) {
      uID = uId;
      emit(CreateAccountSuccessState());
    }).catchError((error){
      emit(CreateAccountErrorState());
    });
  }

  ///Get User Data from Firebase FireStore
  UserModel? originalUser;

  getUserData() async {
    emit(GetUserDataLoadingState());
    await FirebaseFirestore.instance.collection("users").doc(uID).get().then((value) {
      originalUser = UserModel.fromJson(value.data()!);
      emit(GetUserDataSuccessState());
    });
  }

  /// Update User Profile
  void updateUserProfile({
    required String name,
    required String profilePic,
}){
    emit(UpdateProfileLoadingState());
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'name' : name, 'profilePic' : profilePic}).then((value) {
          emit(UpdateProfileSuccessState());
    }).catchError((error){
      emit(UpdateProfileErrorState());
    });
  }

  /// Select Multiple assets from your Gallery
  List<AssetEntity> selectedAssets = [];
  List<File> files = [];
  Future pickAssets(context, {
    required int maxCount,
    required RequestType requestType,
}) async {
    final List<AssetEntity> result = await Navigator.push(context, MaterialPageRoute(builder: (context) => MediaPicker(maxCount, requestType),));
    if(result.isNotEmpty){
      selectedAssets = result;
      files = [];
      for(int i = 0; i < selectedAssets.length; i++){
        File? file = await selectedAssets[i].file;
        files.add(file!);
      }
      emit(MultipleAssetsSelectedState());
    }
}

  /// Remove Asset from Asset List
  void removeAssetFromList({
    required int index,
}){
    selectedAssets.removeAt(index);
    emit(AssetRemovedFromAssetListState());
  }


  /// Upload post to DB and Pic to Firebase Storage
  Future<void> uploadPost({
    required List<File> file,
    required String dateTime,
    required String text,
  }) async {
    String urls = '';
    emit(UploadPostLoadingState());
    for (File element in file) {
      await FirebaseStorage.instance.ref()
          // Upload File to Firebase Storage
          .child('users/$uID/profile_pictures/${Random().nextInt(999999)}${Uri.file(element.path).pathSegments.last}')
          .putFile(element).then((value1) async {
            // Get File Url
            await value1.ref.getDownloadURL().then((value2) {
              urls += '$value2,';
            });
      }).catchError((error){
        print(error);
      });
    }
    PostModel postModel = PostModel(
      uId: '',
      text: text?? '',
      dateTime: dateTime,
      urls: urls,
      isEditable: true
    );
    await FirebaseFirestore.instance.collection('users').doc(uID).collection('posts').add(postModel.toMap()).then((value) {
      value.update({'uId' : value.id});
      emit(UploadPostSuccessState());
    });
  }

  /// Get Posts as stream
  Stream<List<PostModel>> getPosts() {
    return FirebaseFirestore.instance.collection('users').doc(uID).collection('posts').orderBy('dateTime')
        .snapshots().map((event) {
       return event.docs.map((e) => PostModel.fromJson(e.data())).toList();
    });
  }


  Future<String?> getVideoThumbnail (String url) async {

    String? thumbTempPath = await VideoThumbnail.thumbnailFile(
      video: url,
      imageFormat: ImageFormat.WEBP,
    );
    return thumbTempPath;
  }


}