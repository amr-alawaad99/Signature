class UserModel{
  String? uId;
  String? name;
  String? profilePic;
  String? phoneNumber;

  UserModel({
    this.uId,
    this.name,
    this.profilePic,
    this.phoneNumber,
  });

  UserModel.fromJson(Map<String,dynamic> json){
    uId = json['uId'];
    name = json['name'];
    profilePic = json['profilePic'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toMap(){
    return{
      'uId' : uId,
      'name' : name,
      'profilePic' : profilePic,
      'phoneNumber' : phoneNumber,
    };
  }
}