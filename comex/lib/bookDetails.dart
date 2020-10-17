import 'package:comex/Book.dart';
import 'package:flutter/material.dart';

class BookDetailsPage extends StatefulWidget {
  final Book book;
  final int index;
  BookDetailsPage({this.index,this.book});
  @override
  BookDetailsState createState() => BookDetailsState();
}

class BookDetailsState extends State<BookDetailsPage> {
  Book book;
  @override
  void initState() {
    book = super.widget.book;
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
                    padding: const EdgeInsets.only(left:120.0,right:120.0,top:30),
                    child: Hero(
                      tag: widget.index.toString(),
                      child: Image.asset(
                        book.image,
                        scale: 1.5,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:20.0,left:30,right:30),
                    child: Center(
                      child: Container(
                        child: Text(book.name,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 25)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:8,left:8,right:8,bottom:20),
                    child: Container(
                      child: Text(book.author,style: TextStyle(color: Color.fromRGBO(153, 153, 153, 1),fontWeight: FontWeight.w700)),
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
                                      child: Text(book.listedBy,style: TextStyle(color: Color.fromRGBO(82, 93, 92, 1)))
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
                                book.description,
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
