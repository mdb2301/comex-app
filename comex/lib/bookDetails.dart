import 'dart:math';

import 'package:flutter/material.dart';

class BookDetailsPage extends StatefulWidget {
  @override
  BookDetailsState createState() => BookDetailsState();
}

class BookDetailsState extends State<BookDetailsPage> {

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
                    padding: const EdgeInsets.only(left:120.0,right:120.0),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      child: Image.asset(
                        'assets/Vector.png',
                        scale: 2,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:20.0),
                    child: Center(
                      child: Container(
                        child: Text('Harry Potter and the Deathly Hallows',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 25)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:8,left:8,right:8,bottom:20),
                    child: Container(
                      child: Text('J.K. Rowling',style: TextStyle(color: Color.fromRGBO(153, 153, 153, 1),fontWeight: FontWeight.w700)),
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
                                      child: Text('cool_guy_5825',style: TextStyle(color: Color.fromRGBO(82, 93, 92, 1)))
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
                                "The Deathly Hallows is the final instalment of J.K. Rowling's bestselling series, Harry Potter. This title has Harry and his friends reeling after the death of the world's greatest wizard, Albus Dumbledore.\n\nHarry, Hermione and Ron have no other choice but to find all the remaining Horcruxes and destroy them forever, before Lord Voldemort can get his hands on them and kill Harry eventually. On the other hand, with Dumbledore's passing, hope seems to be at its dreariest. The Death-Eaters create chaos for the Muggles to struggle with, slaughtering several of them every day. To make things worse, the Ministry of Magic has also been compromised and is now under the control of the Dark Lord. Everyone seems to be a foe now. But Harry, Ron and Hermione are certain that they have to complete Dumbledore's remaining journey and destroy all the Horcruxes. Will they be successful?",
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
                              Text('12',style:TextStyle(color:Colors.white,fontSize: 17,fontWeight: FontWeight.w800)),
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
