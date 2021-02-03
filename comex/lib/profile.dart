import 'package:comex/Authentication.dart';
import 'package:comex/CustomUser.dart';
import 'package:comex/MyExchanges.dart';
import 'package:comex/MyListings.dart';
import 'package:comex/Storage.dart';
import 'package:comex/main.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final CustomUser user;final String auth;
  ProfilePage({this.user,this.auth});
  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<ProfilePage> {
  CustomUser user;String auth;
  @override
  void initState() {
    user = widget.user;
    auth = widget.auth;   
    super.initState();
  }
  Route listings(){
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => MyListings(user:user),
      transitionsBuilder: (context, animation, secondaryAnimation, child){
        return SlideTransition(
          position: animation.drive(Tween(begin: Offset(1.0,0.0),end: Offset.zero)),
          child: child,
        );
      },
    );
  }

  Route exchanges(){
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => MyExchanges(user:user),
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
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top:40),
                child: Column(
                  children: <Widget>[
                    Container(
                      width:88,height:88,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(44),
                        color: Color.fromRGBO(3, 163, 99, 1)
                      ),
                      child: Center(
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Color.fromRGBO(8, 199, 68, 1),
                          child: Text(user.name[0]+user.name[1],style: TextStyle(color: Colors.white,fontSize: 30),),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Text(user.name,style: TextStyle(fontSize: 20),),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top:20),
                      child: Container(
                        width:150,height:50,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(246, 246, 246, 1),
                          borderRadius: BorderRadius.circular(25)
                        ),
                        child: Center(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset('assets/dollar_2.png',scale: 2.8,),
                              SizedBox(width:10),
                              Text(user.coins.toString(),style: TextStyle(fontSize: 15),)
                            ],
                          )
                        )
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.only(top:30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text(user.listings.toString(),style: TextStyle(fontSize: 30,color: Color.fromRGBO(67,67,67,1)),),Text("LISTINGS",style: TextStyle(color: Color.fromRGBO(82,93,92,1))) //82 93 92
                            ],
                          ),
                          SizedBox(width: 60,),
                          Column(
                            children: <Widget>[
                              Text(user.exchanges.toString(),style: TextStyle(fontSize: 30,color: Color.fromRGBO(67,67,67,1)),),Text("EXCHANGES",style: TextStyle(color: Color.fromRGBO(82,93,92,1))) //82 93 92
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height:30),
                    Option(icon: Icon(Icons.list),text: "My Listings",ontap:()=>Navigator.of(context).push(listings())),
                    Option(icon: Image.asset('assets/trans.png',scale: 2.5,),text: "My Exchanges",ontap:()=>Navigator.of(context).push(exchanges())),
                    Padding(
                      padding: EdgeInsets.only(top:60,bottom:30),
                      child: Center(
                        child: GestureDetector(
                          onTap: logout,
                          child: Column(
                            children: <Widget>[
                              Image.asset('assets/logout.png',scale: 2.4,),
                              SizedBox(height:10),
                              Text("Log Out")
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ]
          ),
        )
      )
    );
  }  

  Route login(){
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Login(),
      transitionsBuilder: (context, animation, secondaryAnimation, child){
        return SlideTransition(
          position: animation.drive(Tween(begin:Offset(-1,0),end:Offset.zero)),
          child: child,
        );
      },
    );
  }

  logout() async {
    print(widget.auth);
    
    switch(widget.auth){
      case "email":
        Email().signOut();
        if(await Storage().clear()){
          Navigator.of(context).pushAndRemoveUntil(login(), (route) => false);
        }
        break;
      case "google":
        Email().signOut();
        if(await Storage().clear()){
          Navigator.of(context).pushAndRemoveUntil(login(), (route) => false);
        }        
        break;
      case "facebook":
        Email().signOut();
        if(await Storage().clear()){
          Navigator.of(context).pushAndRemoveUntil(login(), (route) => false);
        }
        break;
    }

  }
}

class Option extends StatelessWidget {
  final icon,text,ontap;
  Option({this.icon,this.text,this.ontap});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top:30,left:25,right:20),
      child: GestureDetector(
        onTap: ontap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            icon,
            SizedBox(width:30),
            Text(text,style: TextStyle(fontSize: 15),),
            Expanded(child: Container(),),
            Icon(Icons.arrow_forward_ios,color: Color.fromRGBO(8, 199, 68, 1),size: 20)
          ],
        )
      ),
    );
  }
}