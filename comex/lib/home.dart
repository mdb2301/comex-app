import 'dart:convert';

import 'package:comex/bookDetails.dart';
import 'package:comex/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'Book.dart';
import 'User.dart';

class Home extends StatefulWidget{
  final CustomUser user;
  Home({this.user});
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home>{
  CustomUser user;

  @override
  void initState(){
    user = widget.user;
    super.initState();
  }
  Route details(Book book,int index){
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => BookDetailsPage(book:book,index:index),
      transitionsBuilder: (context, animation, secondaryAnimation, child){
        return SlideTransition(
          position: animation.drive(Tween(begin: Offset(1.0,0.0),end: Offset.zero)),
          child: child,
        );
      },
    );
  }
  Route profile(){
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => ProfilePage(user:user),
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
                        onTap: null,//()=>Navigator.of(context).push(profile()),
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
                      padding: EdgeInsets.only(top:20,left:20,right:20),
                      child: FutureBuilder(
                        future: getBookListings(),
                        builder: (context,snapshot){
                          if(snapshot.hasData){
                            return ListView.builder(
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
                                            child: Image.asset(snapshot.data[index].image,scale:1.8)
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(width:180,child: Text(snapshot.data[index].name,style:TextStyle(fontSize: 16))),
                                              Container(width:180,child: Text(snapshot.data[index].author,style:TextStyle(color: Color.fromRGBO(69,69,69,0.5)))),
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
                            );
                          } else {
                            return Container(
                              child: CircularProgressIndicator()
                            );
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
              )
            )
          ],
        )
      ),
    );
  }

  Future<List<Book>> getBookListings() async {
    var file = await DefaultAssetBundle.of(context).loadString('assets/books.json');
    var jsonResponse = json.decode(file);
    List<Book> books = [];
    for(var i in jsonResponse){
      Book book = Book(
        name: i["name"],
        author: i["author"],
        price: i["price"],
        listedBy: i["listedBy"],
        image: i["image"],
        description: i["description"]
      );
      books.add(book);
    }
    return books;
  }


}

