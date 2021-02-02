import 'package:encrypt/encrypt.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageResponse{
  String message;int code;
  StorageResponse({this.code,this.message});
}

class Encryption{
  encrypt(String data){
    final enc = Encrypter(AES(Key.fromUtf8("2OmuvKIRKlVHf@4wGXAS61cyl&32hB!e")));
    final iv = IV.fromUtf8("jrjrZF1ljSty@N@c");
    return enc.encrypt(data,iv:iv).base64;
  }
  decrypt(String data){
    final enc = Encrypter(AES(Key.fromUtf8("2OmuvKIRKlVHf@4wGXAS61cyl&32hB!e")));
    final iv = IV.fromUtf8("jrjrZF1ljSty@N@c");
    return enc.decrypt64(data,iv:iv);
  }
}

class Storage{
  Future<StorageResponse> write(String firebaseId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool res = await pref.setBool("loggedIn", true);
    if(res){
      res = await pref.setString("uid", Encryption().encrypt(firebaseId));
      if(res){
        return StorageResponse(code:1,message:"Stored");
      }
    }
    return StorageResponse(code:0,message:"Failed");
  }
}