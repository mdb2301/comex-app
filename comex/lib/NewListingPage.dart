import 'dart:convert';

import 'package:comex/Book.dart';
import 'package:comex/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NewListingPage extends StatefulWidget{
  final CustomUser user;
  NewListingPage({this.user});
  NewListing createState()=>NewListing();
}

class NewListing extends State<NewListingPage>{
  bool searched; BookAPIQuery bookdata;
  String queryText; int price;
  TextEditingController ctrl,textctrl;
  @override
  void initState(){
    searched = false;
    ctrl = TextEditingController();
    price = 12;
    textctrl = TextEditingController(text: price.toString());
    super.initState();
  }

  Widget build(BuildContext context){
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(246, 246, 246, 1),
        body: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 5,bottom:5),
                child: SingleChildScrollView(
                  child: Column(
                      children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(left:20,top:20),
                                  child: GestureDetector(
                                    onTap: ()=>Navigator.of(context).pop(),
                                    child: Icon(Icons.arrow_back,size: 30,)
                                  ),
                                )
                              ),                    
                              Container(                 
                                child: Padding(
                                padding: const EdgeInsets.only(right:20,top:20),
                                child: GestureDetector(
                                  onTap: null,
                                  child: Icon(Icons.bookmark_border,size:30),
                                  // on tap Icons.bookmark
                                ),
                              )
                            )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top:60,left:45,right:20,bottom:17),
                            child: Container(  
                              child: TextField(
                                controller: ctrl,
                                onChanged: (value){
                                  setState(() {
                                    queryText = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  fillColor: Color.fromRGBO(69,69,69,1),
                                  border: InputBorder.none,
                                  hintText: "Search a Book",
                                  hintStyle: TextStyle(color: Color.fromRGBO(69,69,69,0.5)),
                                  suffixIcon: Container(
                                    width:40,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black38),
                                      borderRadius: BorderRadius.circular(23)
                                    ),
                                    child: GestureDetector(
                                      onTap: searchBook,
                                      child: Icon(Icons.search),
                                    ),
                                  ) 
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: searched,
                            child: Padding(
                                padding: EdgeInsets.only(top:20,bottom:20),
                                child: Container(
                                  
                                  child: bookdata != null ?
                                  Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Image.asset(bookdata.image,scale:1.8)
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(width:180,child: Center(child: Text(bookdata.title,style:TextStyle(fontSize: 25)))),
                                            Container(width:180,child: Center(child: Text((bookdata.authors)[0],style:TextStyle(fontSize:15,color: Color.fromRGBO(69,69,69,0.5))))),                                               
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top:20,left:20,right:10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(bookdata.rating.toString(),style: TextStyle(fontSize:25),),
                                                Text("Rating",style:TextStyle(fontSize: 15,color: Color.fromRGBO(69, 69, 69, 0.8)))
                                              ],
                                            ),
                                            SizedBox(width:35),
                                            Container(width:2,height:50,color: Color.fromRGBO(69, 69, 69, 0.5),),
                                            SizedBox(width:35),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(bookdata.pages.toString(),style: TextStyle(fontSize:25),),
                                                Text("Pages",style:TextStyle(fontSize: 15,color: Color.fromRGBO(69, 69, 69, 0.8)))
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top:50,left:30,right:30),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text("About",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                                            SizedBox(height: 10,),
                                            Text(bookdata.description,style: TextStyle(color: Color.fromRGBO(69, 69, 69, 0.8))),
                                            SizedBox(height:20),
                                            GestureDetector(
                                              onTap: openUrl,
                                              child: Text("Read more",style: TextStyle(color: Colors.blue[300]),),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top:30,left:20),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: ()=>{
                                                setState((){
                                                  price--;
                                                  textctrl.text = price.toString();
                                                })
                                              },
                                              child: Container(
                                                child: Icon(Icons.remove,size: 30,color: Color.fromRGBO(246,246,246,1),),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(15),
                                                  color: Color.fromRGBO(171,171,171,0.9)
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left:20,right:5),
                                              child: Image.asset('assets/dollar_2.png',scale:4),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left:5,right:10),
                                              child: Container(
                                                width: 40,
                                                child: Center(
                                                  child: TextField(
                                                    onChanged: (value) => {
                                                      setState((){
                                                        price = int.parse(value);
                                                      })
                                                    },
                                                    controller: textctrl,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(fontSize: 20,color: Colors.black87),
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ),
                                            GestureDetector(
                                              onTap: ()=>{
                                                setState((){
                                                  price++;
                                                  textctrl.text = price.toString();
                                                })
                                              },
                                              child: Container(
                                                child: Icon(Icons.add,size: 30,color: Color.fromRGBO(246,246,246,1)),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(15),
                                                  color: Color.fromRGBO(171,171,171,0.9)
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 80,vertical: 30),
                                        child: GestureDetector(
                                          onTap: listBook,
                                          child: Container(
                                            height: 50,
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
                                                    child: Text("List for ",style:TextStyle(color:Colors.white)),
                                                  ),
                                                  Image.asset('assets/dollar_2.png',scale: 4,),
                                                  Padding(
                                                    padding: EdgeInsets.only(right:10,left:5),
                                                    child: Text(price.toString(),style:TextStyle(color:Colors.white)),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ),
                                        ),
                                      )
                                    ], 
                              ) : Container(
                                child: Text("No Results")
                              )
                                      
                                )
                              ),
                          )
                        ]
                      ),
                ),
              ),
              ]  
            ),
        )
      );         
  }

  openUrl() async {
    if(await canLaunch(bookdata.infoLink)){
      await launch(bookdata.infoLink);
    }
  }

/*
  getBook() async {
    var file = await DefaultAssetBundle.of(context).loadString('assets/book.json');
    var jsonResponse = json.decode(file);
    List<BookAPIQuery> books = [];
    for(var i in jsonResponse){
      BookAPIQuery book = BookAPIQuery(
        title: i["title"],
        authors: i["author"],
        image: i["imageLinks"],
        description: i["description"],
        infoLink: i["infoLink"],
        pages: i["pageCount"],
        rating: i["averageRating"]
      );
      books.add(book);
    }
    
    setState(() {
      bookdata = books[0];
    });
  }*/

  searchBook(){
    // Search for queryText with books API
    // Set bookdata = result
    setState(() {
      searched = true;
      ctrl.clear();
    });
  }

  listBook(){
    if(bookdata != null){
      //Code to list book on db and subsequent redirects
    }
  }
}