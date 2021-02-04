import 'dart:async';

import 'package:comex/API.dart';
import 'package:comex/Book.dart';
import 'package:comex/CustomUser.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MyListings extends StatefulWidget {
  final CustomUser user;
  MyListings({this.user});
  @override
  _MyListingsState createState() => _MyListingsState();
}

class _MyListingsState extends State<MyListings> {
  List<BookAPIQuery> books;bool loading;
  @override
  void initState() {
    books = List<BookAPIQuery>();
    getBooks();
    Timer(Duration(seconds:10),(){
      setState(() {
        loading = false;
      });
    });
    loading = true;
    super.initState();
  }

  Route details(int index, BookAPIQuery book){
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => ListingDetailsPage(index:index,book:book,user:widget.user),
      transitionsBuilder: (context, animation, secondaryAnimation, child){
        return SlideTransition(
          position: animation.drive(Tween(begin: Offset(1.0,0.0),end: Offset.zero)),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: GestureDetector(
                        onTap: ()=>Navigator.of(context).pop(),
                        child: Icon(Icons.arrow_back,size: 30,)
                      ),
                    ),
                    Expanded(child:Container()),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Text("My Listings",style:TextStyle(fontSize: 20))
                    ),
                  ],
                ), 
                loading ? 
                Container(height:MediaQuery.of(context).size.height,width:MediaQuery.of(context).size.width,child: Center(child: Container(width:50,height:50,child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(3, 163, 99, 1)),))))
                : books.length==0 ?   
                  Container(
                    height:MediaQuery.of(context).size.height,width:MediaQuery.of(context).size.width,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical:20),
                            child: Text("No result"),
                          ),
                          GestureDetector(
                            onTap: refresh,
                            child: Container(
                              width:40,height:40,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(245,245,245,1),
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: Icon(Icons.refresh)
                            )
                          )
                        ],
                      )
                    ),
                  )               
                : Padding(
                  padding: EdgeInsets.symmetric(vertical:25),
                  child: RefreshIndicator(
                    onRefresh: refresh,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: books.length,
                      itemBuilder: (context,index){
                        return GestureDetector(
                          onTap: ()=>Navigator.of(context).push(details(index,books[index])),
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 15),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top:8,bottom:8,left:14),
                                  child: Hero(
                                    tag: index.toString(),
                                    child: Container(
                                      width: 80,height:100,
                                      child: Image.network(books[index].image,scale:1.8)
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top:8,bottom:8,left:33),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(width:200,child: Text(books[index].title,style:TextStyle(fontSize: 16))),
                                      Container(width:200,child: Text(books[index].authors,style:TextStyle(color: Color.fromRGBO(69,69,69,0.5)))),
                                      SizedBox(height:10),
                                      Container(width:200,child: Text(books[index].uploadedOn,style:TextStyle(color: Color.fromRGBO(69,69,69,0.5)))),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left:10),
                                  child: Column(
                                    children: <Widget>[
                                      Image.asset("assets/dollar_2.png",scale:2.5),
                                      Text(books[index].price.toString(),style: TextStyle(fontSize: 20),),
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
                  ),
                ),
              ],
            )
          ),
        ),
      ),
    );
  }

  // ignore: missing_return
  Future<void> refresh() async {
    Timer(Duration(seconds:10),(){
      setState(() {
        loading = false;
      });
    });
    setState(() {
      loading = true;
    });
    await getBooks();
  }

  getBooks() async {
    APIResponse res = await API().getListings(widget.user.firebaseId);
    if(res.code==0){
      setState(() {
        books = res.book;
        print(books.length);
      });
    }
  }
}

class ListingDetailsPage extends StatefulWidget {
  final BookAPIQuery book;final CustomUser user;
  final int index;
  ListingDetailsPage({this.index,this.book,this.user});
  @override
  ListingDetailsState createState() => ListingDetailsState();
}

class ListingDetailsState extends State<ListingDetailsPage> {
  @override
  void initState() {
    super.initState();
  }

  Route qrpage(){
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => QRPage(book:widget.book,user:widget.user),
      transitionsBuilder: (context, animation, secondaryAnimation, child){
        return SlideTransition(
          position: animation.drive(Tween(begin: Offset(1.0,0.0),end: Offset.zero)),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(246, 246, 246, 1),
        body: Stack(
          children: <Widget>[
            SingleChildScrollView ( 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical:12),
                          child: Hero(
                            tag: widget.index.toString(),
                            child: Image.network(
                              widget.book.image,
                              scale: 1.5,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left:20),
                              child: Text(widget.book.title,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 25)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top:8,bottom:8,left:20),
                              child: Text(widget.book.authors??"N/A",style: TextStyle(color: Color.fromRGBO(153, 153, 153, 1),fontWeight: FontWeight.w700)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom:10,left:20),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right:8,top:8,bottom:8),
                                    child: Image.asset('assets/dollar_2.png',scale: 4.2),
                                  ),
                                  Text(widget.book.price.toString(),style: TextStyle(color: Color.fromRGBO(69, 69, 69, 0.69),fontWeight: FontWeight.w700)),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left:20),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(text:"Listed On: ",style:TextStyle(color:Color.fromRGBO(69,69,69,0.96),fontSize:12,fontWeight:FontWeight.bold)),
                                    TextSpan(text:widget.book.uploadedOn,style:TextStyle(color:Color.fromRGBO(69,69,69,0.69),fontSize:12))
                                  ]
                                )
                              )
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(        // Size of the container adjusted according to screen
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight:Radius.circular(40),
                          topLeft: Radius.circular(40)
                          ),
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                      child: Padding(
                        padding: const EdgeInsets.only(top:40,left:30,right:30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top:15,bottom:8),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Text('About',
                                style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontSize: 20,
                                fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 90),
                              child: Text(
                                widget.book.description??"N/A",
                                style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1)),
                                textAlign: TextAlign.justify,
                                ),
                            ),
                          ],
                        ),
                      ),
                    ),  
                ],
              ),
            ),
            Positioned(
              bottom:10,
              width:MediaQuery.of(context).size.width,
              child: GestureDetector(
                onTap: ()=>Navigator.of(context).push(qrpage()),
                child: Center(
                  child: Container(
                    width:250,
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
                      padding: const EdgeInsets.only(top:8,bottom:8,left:25,right:25),
                      child: Text('Exchange',style:TextStyle(color:Colors.white,fontSize: 18,fontWeight: FontWeight.w800))
                    ),
                  ),
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}

class QRPage extends StatefulWidget {
  final BookAPIQuery book;
  final CustomUser user;
  QRPage({this.book,this.user});
  @override
  _QRPageState createState() => _QRPageState();
}

class _QRPageState extends State<QRPage> {
  bool down;
  @override
  void initState() {
    down = false;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top:90),
                child: Container(
                  width: 300,height:300,
                  child: QrImage(
                    version: 3,
                    data: widget.book.title + "_" + widget.book.uploadedBy + "_" + widget.book.price.toString()
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(widget.book.title,style:TextStyle(fontSize: 25)),
                    Text(widget.book.authors),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Image.asset('assets/dollar_2.png',scale: 4.2),
                        ),
                        Text(widget.book.price.toString()),
                      ],
                    ),
                  ],
                )
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Text("Scan my code to exchange",style:TextStyle(color:Colors.black45,fontSize:17)),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical:50),
                child: GestureDetector(
                  onTapDown: (details) {
                    setState(() {
                      down = true;
                    });
                  },
                  onTapUp: (details) {
                    setState(() {
                      down = false;
                    });
                  },
                  onTap: ()=>Navigator.of(context).pop(),
                  child: Container(
                    height: 50,width:100,
                    alignment:Alignment.center,
                    decoration: BoxDecoration(
                      color: down ? Color.fromRGBO(3,163,99,1) : Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color:Color.fromRGBO(3,163,99,1))
                    ),
                    child: Center(
                      child: Text("Done",style:TextStyle(color:down ? Colors.white : Color.fromRGBO(3,163,99,1)))
                    )
                  ),
                )
              ),
            ],
          ),
        ),
      )
    );
  }
}