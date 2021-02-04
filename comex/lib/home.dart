import 'dart:async';
import 'package:comex/API.dart';
import 'package:comex/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'Book.dart';
import 'NewListingPage.dart';
import 'CustomUser.dart';

class Home extends StatefulWidget{
  final CustomUser user;final dynamic auth;
  Home({this.user,this.auth});
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home>{
  bool loading;
  List<BookAPIQuery> books;
  @override
  void initState(){
    while(widget.user==null){}
    getBooks();
    Timer(Duration(seconds:10),(){
      setState(() {
        loading = false;
      });
    });
    loading = true;
    super.initState();
  }

  Route details(BookAPIQuery book,int index){
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => BookDetailsPage(book:book,index:index,user:widget.user),
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
      pageBuilder: (context, animation, secondaryAnimation) => ProfilePage(user:widget.user,auth:widget.auth),
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
      pageBuilder: (context, animation, secondaryAnimation) => NewListingPage(user:widget.user),
      transitionsBuilder: (context, animation, secondaryAnimation, child){
        return SlideTransition(
          position: animation.drive(Tween(begin: Offset(1.0,0.0),end: Offset.zero)),
          child: child,
        );
      },
    );
  }

  Route scanner(){
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => QRScanner(user:widget.user),
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
    return WillPopScope(
      onWillPop: null,
      child: Scaffold(
        backgroundColor: Color.fromRGBO(246, 246, 246, 1),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(4),
                        child: GestureDetector(
                          onTap: ()=>Navigator.of(context).push(scanner()),
                          child: Image.asset('assets/qr-text.png',scale:4.2)
                        ),
                      ),
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
                        child: loading ?
                        Center(child: Container(width:50,height:50,child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(3, 163, 99, 1)),)))                  
                        :books.length==0?
                        Container(
                          width:MediaQuery.of(context).size.width,
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
                        ):
                        RefreshIndicator(
                          onRefresh: refresh,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: books.length,
                            itemBuilder: (context,index){
                              return Padding(
                                padding: EdgeInsets.only(bottom: 15),
                                child: GestureDetector(
                                  onTap: ()=>Navigator.of(context).push(details(books[index],index)),
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
                                                  child: Text(books[index].uploadedBy,style: TextStyle(color: Color.fromRGBO(69,69,69,0.95)),)
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
      ),
    );
  }

  Future<void>refresh() async{
    print("refresh");
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

  getBooks() {
    print("Fence id: ${widget.user.fenceId}");
    API().getBooksInFence(widget.user.fenceId).then((res){
      if(res.code==0){
        setState(() {
          books = res.book;
        });
      }
    });    
  }
}

class BookDetailsPage extends StatefulWidget {
  final BookAPIQuery book;final CustomUser user;
  final int index;
  BookDetailsPage({this.index,this.book,this.user});
  @override
  BookDetailsState createState() => BookDetailsState();
}

class BookDetailsState extends State<BookDetailsPage> {
  BookAPIQuery book;
  CustomUser currentUser;
  @override
  void initState() {
    book = widget.book;
    currentUser = widget.user;
    print("Title: "+book.title);
    super.initState();
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
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical:10),
                      child: Hero(
                        tag: widget.index.toString(),
                        child: Container(
                          width: 80,height:100,
                          child: Image.network(
                            book.image,
                            scale: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top:20.0,left:30,right:30),
                    child: Center(
                      child: Container(
                        child: Text(book.title,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 25)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top:8,bottom:20),
                    child: Center(
                      child: Container(
                        child: Text(book.authors??"N/A",style: TextStyle(color: Color.fromRGBO(153, 153, 153, 1),fontWeight: FontWeight.w700)),
                      ),
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
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Listed By',
                                style: TextStyle(color: Color.fromRGBO(82, 93, 92, 1))
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top:15,bottom:10),
                              child: Row(
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Image.asset('assets/random_guy 3.png',width: 45,height: 45,),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left:15),
                                    child: Container(
                                      child: Text(book.uploadedBy,style: TextStyle(color: Color.fromRGBO(82, 93, 92, 1)))
                                    ),
                                  )
                                ],
                              ),
                            ),
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
                                book.description??"N/A",
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
              left:10,right:10,
              child: Container(
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
                  padding: const EdgeInsets.only(top:8,bottom:8,left:50,right:50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Exchange',style:TextStyle(color:Colors.white,fontSize: 18,fontWeight: FontWeight.w800)),
                      Row(
                        children: [
                          Column(
                            children: [
                              Text(book.price.toString(),style:TextStyle(color:Colors.white,fontSize: 17,fontWeight: FontWeight.w800)),
                              Text('COINS',style:TextStyle(color:Colors.white,fontSize: 10,fontWeight: FontWeight.w800)),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left:8),
                            child: Image.asset('assets/dollar_2.png',scale: 3,),
                          )
                        ],
                      ),
                    ],
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

class QRScanner extends StatefulWidget {
  final CustomUser user;
  QRScanner({this.user});
  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {

  @override
  void initState() {
    scan();
    super.initState();
  }

  scan() async {
    String res = await BarcodeScanner.scan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Center(
            child: Container()
          )
        )
      )
    );
  }
}


