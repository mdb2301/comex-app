import 'dart:convert';

import 'package:comex/CustomUser.dart';
import 'package:http/http.dart' as http;

class APIResponse{
  int code;String message;CustomUser user;
  APIResponse({this.code,this.message,this.user});
}

class API{

  Future<APIResponse> getUser(String firebaseId) async {
    http.Response res = await http.post("https://comex-api-mdb.herokuapp.com/getuser",
      headers: <String,String>{
        'content-type':'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String,String>{
        "firebase_id":firebaseId
      })
    );
    if(res.statusCode==200){
      if(res.body.isNotEmpty && !res.body.startsWith("<html>")){
        return APIResponse(code:0,message:"User found",user:CustomUser.fromJson(json.decode(res.body)));
      }else{
        return APIResponse(code:1,message:"Response empty or invalid");
      }
    }else{
      return APIResponse(code:1,message:"Request failed ${res.statusCode}");
    }
  }

  Future<APIResponse> addUser(CustomUser user) async {
    http.Response res = await http.post("https://comex-api-mdb.herokuapp.com/adduser",
      headers: <String,String>{
        'content-type':'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String,String>{
        "name":user.name,
        "firebase_id":user.firebaseId,
        "email":user.email,
        "fence_id":user.fenceId
      })
    );
    if(res.statusCode==200){
      if(res.body.isNotEmpty && !res.body.startsWith("<html>")){
        var j = json.decode(res.body);
        print(j);
        //return APIResponse(code:0,message:"User added",user:CustomUser.fromJson());
      }else{
        return APIResponse(code:1,message:"Response empty or invalid");
      }
    }else{
      return APIResponse(code:1,message:"Request failed ${res.statusCode}");
    }
    return APIResponse(code:1,message:"Response empty or invalid");
  }

}
