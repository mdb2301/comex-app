import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:comex/bookDetails.dart';
import 'package:comex/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'Book.dart';
import 'NewListingPage.dart';
import 'User.dart';

class Home extends StatefulWidget{
  final CustomUser user;final dynamic auth;
  Home({this.user,this.auth});
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home>{
  CustomUser user;bool noBooks;
  Timer timer; dynamic auth;
  @override
  void initState(){
    user = widget.user;
    auth = widget.auth;
    getUser();
    noBooks = false;
    timer = Timer(Duration(seconds: 5),(){
      setState(() {
        noBooks = true;
      });
    });
    super.initState();
  }

  getUser() async{
    var uid = user.firebaseId.toString();
    var res = await http.get("https://guarded-cove-87354.herokuapp.com/users/$uid");
    if(res.statusCode==200){
      var jsonData = json.decode(res.body);
      setState(() {
        user = CustomUser(username: jsonData["name"],email: jsonData["email"],firebaseId: jsonData["firebase_id"]);
        print(user.username);
      });
    }else{
      print(res.body);
    }
  }

  Route details(BookAPIQuery book,int index){
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => BookDetailsPage(book:book,index:index,user:user),
      transitionsBuilder: (context, animation, secondaryAnimation, child){
        return SlideTransition(
          position: animation.drive(Tween(begin: Offset(1.0,0.0),end: Offset.zero)),
          child: child,
        );
      },
    );
  }
  Route profile(){
    var x = user.username;
    print("Home: $x");
    print(auth.runtimeType);
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => ProfilePage(user:user,auth:auth),
      transitionsBuilder: (context, animation, secondaryAnimation, child){
        return SlideTransition(
          position: animation.drive(Tween(begin: Offset(1.0,0.0),end: Offset.zero)),
          child: child,
        );
      },
    );
  }

  Route newList(){
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => NewListingPage(user:user),
      transitionsBuilder: (context, animation, secondaryAnimation, child){
        return SlideTransition(
          position: animation.drive(Tween(begin: Offset(1.0,0.0),end: Offset.zero)),
          child: child,
        );
      },
    );
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color.fromRGBO(246, 246, 246, 1),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Image.asset('assets/map-pin.png',scale: 3,),
                    ),
                    Text("Amanora Hsg Soc",style:TextStyle(fontSize: 18,color:Color.fromRGBO(69,69,69,1))),
                    Expanded(child: Container(),),
                    Padding(
                      padding: const EdgeInsets.all(18),
                      child: GestureDetector(
                        onTap: ()=>Navigator.of(context).push(profile()),
                        child: Hero(
                          tag: "profile_img",
                          child: Container(
                            width:45,height:45,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(8, 199, 68, 1),
                              borderRadius: BorderRadius.circular(25)
                            ),
                            alignment: Alignment.topLeft,
                            child: Center(child: Image.asset('assets/random_guy 3.png',width: 40,height: 40,)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top:8,left:26,right:26,bottom:17),
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search a Book",
                      hintStyle: TextStyle(color: Color.fromRGBO(69,69,69,0.3)),
                      prefixIcon: Icon(Icons.search) 
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top:20,left:10,right:10),
                      child: noBooks? 
                      Container(
                        width:MediaQuery.of(context).size.width,
                        child: Center(child: Text("No result"),),
                      ):
                      FutureBuilder(
                        future: getBookListings(),
                        builder: (context,snapshot){
                          if(snapshot.hasData){
                            return RefreshIndicator(
                              // ignore: missing_return
                              onRefresh: refresh,
                              child: ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (context,index){
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 15),
                                    child: GestureDetector(
                                      onTap: ()=>Navigator.of(context).push(details(snapshot.data[index],index)),
                                      child: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.all(8),
                                            child: Hero(
                                              tag: index.toString(),
                                              child: Image.network(snapshot.data[index].image,scale:1.8),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(width:180,child: Text(snapshot.data[index].title,style:TextStyle(fontSize: 16))),
                                                Container(width:180,child: Text(snapshot.data[index].authors,style:TextStyle(color: Color.fromRGBO(69,69,69,0.5)))),
                                                Padding(
                                                  padding: EdgeInsets.only(top:20),
                                                  child: Container(width:180,child: Text("Listed by:",style:TextStyle(color: Color.fromRGBO(69,69,69,0.9)))),
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: EdgeInsets.only(top:8,bottom:8),
                                                      child: Container(
                                                        width:24,height:24,
                                                        decoration: BoxDecoration(
                                                          color: Color.fromRGBO(8, 199, 68, 1),
                                                          borderRadius: BorderRadius.circular(25)
                                                        ),
                                                        alignment: Alignment.topLeft,
                                                        child: Center(child: Image.asset('assets/random_guy 3.png',width: 22,height: 20,)),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(top:8,left:8,bottom:8),
                                                      child: Text(snapshot.data[index].listedBy,style: TextStyle(color: Color.fromRGBO(69,69,69,0.95)),)
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left:10),
                                            child: Column(
                                              children: <Widget>[
                                                Image.asset("assets/dollar_2.png",scale:2.5),
                                                Text(snapshot.data[index].price.toString(),style: TextStyle(fontSize: 20),),
                                                Text("COINS")
                                              ],
                                            )
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          } else {
                            return Container(width:MediaQuery.of(context).size.width,child:Center(child: Container(width:50,height:50,child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(3, 163, 99, 1)),),),));
                          }
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
            Positioned(
              bottom:10,left:100,right:100,
              child: GestureDetector(
                onTap: ()=>Navigator.of(context).push(newList()),
                child: Container(
                  height: 48,
                  alignment:Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      colors: [Color.fromRGBO(3, 163, 99, 1),Color.fromRGBO(8, 199, 68, 1)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight
                    )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right:10,left:10),
                          child: Text("New Listing",style:TextStyle(color:Colors.white)),
                        ),
                        Icon(Icons.add,size: 25,color: Colors.white)
                      ],
                    ),
                  )
                ),
              )
            )
          ],
        )
      ),
    );
  }

  Future<void>refresh() async{
    setState(() {
      build(context);
    });
  }

  Future<List<BookAPIQuery>> getBookListings() async {
    List<BookAPIQuery> books; 
    var res = await http.get("https://guarded-cove-87354.herokuapp.com/books",headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8',},);
    if(res.statusCode==200){
      books = [];
      var jsonData = json.decode(res.body);
      if(jsonData.length>1){
        for(var i=0;i<=jsonData.length+1;i++){
          var d = jsonData["Books"][i];
          BookAPIQuery book = BookAPIQuery(
            title: d["name"],
            description: d["description"],
            image: d["thumbnail_link"],
            pages: d["pages"],
            price: d["price"]!=null ? d["price"]:0,
            authors: d["author"],
            listedBy: d["firebase_id"]!=null ? d["id"] : "unknown"
          );
          if(book.listedBy!="unknown"){
            var userres = await http.get("https://guarded-cove-87354.herokuapp.com/users/"+book.listedBy.toString());
            if(res.statusCode==200){
              var jsonRes = json.decode(userres.body);
              if(jsonRes !=null){
                for(var i=0;i<=jsonRes.length+1;i++){
                  var d = jsonRes["users"][i];
                  CustomUser user = CustomUser(
                    firebaseId: d["firebaseId"],
                    username: d["name"]
                  );
                  if(user.firebaseId==book.listedBy){
                    book.listedBy = user.username;
                    break;
                  }
                }
              } 
            }
          }
          books.add(book);
        }
        print(books.length);
        return books; 
      }
    }
    return null;    
  }


}

