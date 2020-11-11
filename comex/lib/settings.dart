import 'package:flutter/material.dart';
import 'dart:convert';
import 'Book.dart';
import 'User.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
class MyListings extends StatefulWidget {
  final CustomUser user;
  MyListings({this.user});
  @override
  _MyListingsState createState() => _MyListingsState();
}

class _MyListingsState extends State<MyListings> {
  CustomUser user;
  Timer timer;Widget altwidget;
  @override
  initState(){
    user = widget.user;
    super.initState();
  }

  Future<List<BookAPIQuery>> getBookListings() async {
    List<BookAPIQuery> books; 
    var res = await http.get("https://guarded-cove-87354.herokuapp.com/books",headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8',},);
    if(res.statusCode==200){
      books = [];
      var jsonData = json.decode(res.body);
      if(jsonData.length>=1){
        for(var i=0;i<=jsonData.length+1;i++){
          var d = jsonData["Books"][i];
          BookAPIQuery book = BookAPIQuery(
            title: d["name"],
            description: d["description"],
            image: d["thumbnail_link"],
            pages: d["pages"],
            price: d["price"]!=null ? d["price"]:0,
            authors: d["author"],
            listedBy: d["id"]!=null ? d["id"] : "unknown"
          );
          if(book.listedBy==user.username){
            books.add(book);
          }
        }
        print(books.length);
        return books; 
      }
    }   
    return null; 
  }

  @override
  Widget build(BuildContext context) {
    altwidget = Container(width:MediaQuery.of(context).size.width,child:Center(child: Container(width:50,height:50,child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(3, 163, 99, 1)),),),));
    return Scaffold(
      body:SingleChildScrollView(
        child: FutureBuilder(
          future: getBookListings(),
          builder: (context,snapshot){
            if(snapshot.hasData && snapshot.data[0]!=null){
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context,index){
                  return Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: GestureDetector(
                      onTap: null,
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
              );
            }else{
              timer = Timer(Duration(seconds: 5),(){
                setState(() {
                  altwidget = Container(
                    width:MediaQuery.of(context).size.width,
                    child: Center(child: Text("No result"),),
                  );
                });
              });
              return altwidget;
            }
          } 
        )
      )
    );
  }
}

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}