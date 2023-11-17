class PostModel{
  String? uId;
  String? dateTime;
  String? text;
  String? urls;
  bool? isEditable;

  PostModel({
    this.uId,
    this.dateTime,
    this.text,
    this.urls,
    this.isEditable,
  });

  PostModel.fromJson(Map<String,dynamic> json){
    uId = json['uId'];
    dateTime = json['dateTime'];
    text = json['text'];
    urls = json['urls'];
    isEditable = json['isEditable'];
  }

  Map<String, dynamic> toMap(){
    return{
      'uId' : uId,
      'dateTime' : dateTime,
      'text' : text,
      'urls' : urls,
      'isEditable' : isEditable,
    };
  }
}