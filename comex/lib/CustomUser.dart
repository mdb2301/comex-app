class CustomUser{
  String name,email,firebaseId,fenceId;
  int coins,listings,exchanges;
  bool updated;
  DateTime dateJoined;
  CustomUser({this.name,this.email,this.firebaseId,this.fenceId,this.coins,this.listings,this.exchanges,this.updated,this.dateJoined});

  factory CustomUser.fromJson(Map<String,dynamic> json){
    return CustomUser(
      name: json["name"],
      email: json["email"],
      firebaseId:json["firebase_id"],
      fenceId:json["fenceId"],
      coins:json["coins"],
      listings:json["listings"],
      exchanges:json["exchanges"],
      updated:json["updated"],
      dateJoined:json["date__joined"]
    );
  }
}