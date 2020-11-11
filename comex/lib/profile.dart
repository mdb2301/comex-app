import 'package:comex/User.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final CustomUser user;final dynamic auth;
  ProfilePage({this.user,this.auth});
  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<ProfilePage> {
  CustomUser user;dynamic auth;int authtype;
  @override
  void initState() {
    user = widget.user;
    auth = widget.auth;
    print(user.username);
    if(auth.runtimeType.toString()=="FirebaseAuth"){
      setState(() {
        authtype = 1;
      });
    }
    if(auth.runtimeType.toString()=="FacebookLogin"){
      setState(() {
        authtype=2;
      });
    }
    if(auth.runtimeType.toString()=="GoogleSignIn"){
      setState(() {
        authtype=3;
      });
    }
    super.initState();
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
                          child: Text(user.username[0]+user.username[1],style: TextStyle(color: Colors.white,fontSize: 30),),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Text(user.username,style: TextStyle(fontSize: 20),),
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
                              Text("330 COINS",style: TextStyle(fontSize: 15),)
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
                              Text("15",style: TextStyle(fontSize: 30,color: Color.fromRGBO(67,67,67,1)),),Text("LISTINGS",style: TextStyle(color: Color.fromRGBO(82,93,92,1))) //82 93 92
                            ],
                          ),
                          SizedBox(width: 60,),
                          Column(
                            children: <Widget>[
                              Text("18",style: TextStyle(fontSize: 30,color: Color.fromRGBO(67,67,67,1)),),Text("EXCHANGES",style: TextStyle(color: Color.fromRGBO(82,93,92,1))) //82 93 92
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height:30),
                    Option(icon: Icon(Icons.list),text: "My Listings",ontap:(){print("Listings");}),
                    Option(icon: Image.asset('assets/trans.png',scale: 2.5,),text: "My Transactions",ontap:(){print("Trans");}),
                    Option(icon: Image.asset('assets/settings.png',scale: 2.5,),text: "Account Settings",ontap:(){print("Settings");}),
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

  logout(){
    switch(authtype){
      case 1:
        auth.signOut();
        break;
      case 2:
        auth.logOut();
        break;
      case 3:
        auth.signOut();
        break;
    }
    while(Navigator.of(context).canPop()){
      Navigator.of(context).pop();
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