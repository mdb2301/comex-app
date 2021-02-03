import 'dart:convert';

import 'package:comex/Book.dart';
import 'package:comex/CustomUser.dart';
import 'package:http/http.dart' as http;

class APIResponse{
  int code;String message;CustomUser user;dynamic book;
  APIResponse({this.code,this.message,this.user,this.book});
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
        var j = json.decode(res.body);
        if(j["code"]==11){
          return APIResponse(code:0,message:"User found",user:CustomUser.fromJson(j));
        }else{
          return APIResponse(code:1,message:"${j["code"]}:${j["msg"]}");
        }
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
      body: jsonEncode(<String,dynamic>{
        "name":user.name,
        "firebase_id":user.firebaseId,
        "email":user.email,
        "fence_id":"1"//user.fenceId,
      })
    );
    if(res.statusCode==200){
      if(res.body.isNotEmpty && !res.body.startsWith("<html>")){
        var j = json.decode(res.body);
        if(j["code"]==11){
          print(j["id"]);
          return APIResponse(code:0,message:"User added",user:CustomUser.fromJson(j));
        }else{
          if(j["code"]==14){
            return APIResponse(code:2,message:"Already exists");
          }else{
            return APIResponse(code:1,message:"Failed. ${j["code"]}:${j["msg"]}");
          }
        }
      }else{
        return APIResponse(code:1,message:"Response empty or invalid");
      }
    }else{
      return APIResponse(code:1,message:"Request failed ${res.statusCode}");
    }
  }

  Future<APIResponse> addBook(CustomUser user,BookAPIQuery book,int price) async {
    http.Response res = await http.post("https://comex-api-mdb.herokuapp.com/addbook",
      headers: <String,String>{
        'content-type':'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String,dynamic>{
        "title":book.title,
        "authors":book.authors,
        "etag":book.etag,
        "pages":book.pages,
        "description":book.description,
        "avg_rating":book.rating,
        "thumb_link":book.image,
        "google_link":book.infoLink,
        "price":price,
        "uploaded_by":user.firebaseId
      })
    );
    if(res.statusCode==200){
      if(res.body.isNotEmpty && !res.body.startsWith("<html>")){
        var j = json.decode(res.body);
        if(j["code"]==11){
          print(j["id"]);
          return APIResponse(code:0,message:"Book added");
        }
        return APIResponse(code:1,message:j["msg"].toString());
      }else{
        return APIResponse(code:1,message:"Response empty or invalid.");
      }
    }else{
      return APIResponse(code:1,message:"Request failed ${res.statusCode}");
    }
  }

  Future<APIResponse> getBooksInFence(String fenceId) async {
    http.Response res = await http.post("https://comex-api-mdb.herokuapp.com/booksinfence",
      headers: <String,String>{
        'content-type':'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String,String>{
        "fence_id":fenceId
      })
    );
    if(res.statusCode==200){
      if(res.body.isNotEmpty && !res.body.startsWith("<html>")){
        var j = json.decode(res.body);
        if(j["code"]==31){
          return APIResponse(code:0,message:"Books found",book:parseBooks(j["books"]));
        }else{
          print("${j["code"]}:${j["msg"]}");
          return APIResponse(code:1,message:"${j["code"]}:${j["msg"]}");
        }
      }else{
        print(res.body);
        return APIResponse(code:1,message:"Response empty or invalid");
      }
    }else{
      return APIResponse(code:1,message:"Request failed ${res.statusCode}");
    }
  }

  Future<APIResponse> getBooksByUser(String firebaseId) async {
    http.Response res = await http.post("https://comex-api-mdb.herokuapp.com/booksbyuser",
      headers: <String,String>{
        'content-type':'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String,String>{
        "firebase_id":firebaseId
      })
    );
    if(res.statusCode==200){
      if(res.body.isNotEmpty && !res.body.startsWith("<html>")){
        var j = json.decode(res.body);
        if(j["code"]==31){
          return APIResponse(code:0,message:"Books found",book:parseBooks(j["books"]));
        }else{
          if(j["code"]==30){
            return APIResponse(code:2,message:"No Books");
          }
          print("${j["code"]}:${j["msg"]}");
          return APIResponse(code:1,message:"${j["code"]}:${j["msg"]}");
        }
      }else{
        print(res.body);
        return APIResponse(code:1,message:"Response empty or invalid");
      }
    }else{
      return APIResponse(code:1,message:"Request failed ${res.statusCode}");
    }
  }

  Future<APIResponse> getListings(String firebaseId) async {
    http.Response res = await http.post("https://comex-api-mdb.herokuapp.com/listings",
      headers: <String,String>{
        'content-type':'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String,String>{
        "firebase_id":firebaseId
      })
    );
    if(res.statusCode==200){
      if(res.body.isNotEmpty && !res.body.startsWith("<html>")){
        var j = json.decode(res.body);
        if(j["code"]==31){
          return APIResponse(code:0,message:"Books found",book:parseBooks(j["books"]));
        }else{
          if(j["code"]==30){
            return APIResponse(code:2,message:"No Books");
          }
          print("${j["code"]}:${j["msg"]}");
          return APIResponse(code:1,message:"${j["code"]}:${j["msg"]}");
        }
      }else{
        print(res.body);
        return APIResponse(code:1,message:"Response empty or invalid");
      }
    }else{
      return APIResponse(code:1,message:"Request failed ${res.statusCode}");
    }
  }

  Future<APIResponse> getExchanges(String firebaseId) async {
    http.Response res = await http.post("https://comex-api-mdb.herokuapp.com/exchanges",
      headers: <String,String>{
        'content-type':'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String,String>{
        "firebase_id":firebaseId
      })
    );
    if(res.statusCode==200){
      if(res.body.isNotEmpty && !res.body.startsWith("<html>")){
        var j = json.decode(res.body);
        if(j["code"]==31){
          return APIResponse(code:0,message:"Books found",book:parseBooks(j["books"]));
        }else{
          if(j["code"]==30){
            return APIResponse(code:2,message:"No Books");
          }
          print("${j["code"]}:${j["msg"]}");
          return APIResponse(code:1,message:"${j["code"]}:${j["msg"]}");
        }
      }else{
        print(res.body);
        return APIResponse(code:1,message:"Response empty or invalid");
      }
    }else{
      return APIResponse(code:1,message:"Request failed ${res.statusCode}");
    }
  }

  serverEntry(Map<String,dynamic> map) async {
    String name = await getUserName(map["uploaded_by"]);
    return BookAPIQuery(
      title: map["title"],
      authors: map["authors"],
      pages: map["pages"],
      description: map["description"],
      uploadedOn: map["uploaded_on"],
      uploadedBy: name,
      price: map["price"],
      rating: map["rating"],
      infoLink: map["infoLink"],
      image: map["image"],
      taken: map["taken"],
      etag: map["etag"]
    );
  }

  List<BookAPIQuery> parseBooks(List<dynamic> list) {
    List<BookAPIQuery> books = List<BookAPIQuery>();
    list.forEach((element) async {books.add(await serverEntry(element));});
    return books;
  }

}

Future<String> getUserName(String firebaseId) async {
  final res = await API().getUser(firebaseId);
  if(res.code==0){
    return res.user.name;
  }else{
    return "";
  }
}
