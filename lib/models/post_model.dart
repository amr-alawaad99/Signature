class UserModel{
  String? uId;
  String? name;
  String? profilePic;

  UserModel({
    this.uId,
    this.name,
    this.profilePic,
  });

  UserModel.fromJson(Map<String,dynamic> json){
    uId = json['uId'];
    name = json['name'];
    profilePic = json['profilePic'];
  }

  Map<String, dynamic> toMap(){
    return{
      'uId' : uId,
      'name' : name,
      'profilePic' : profilePic,
    };
  }
}