import 'dart:convert';

import 'package:comex/User.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:comex/main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'home.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
class Register extends StatefulWidget {
  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<Register> {
  FirebaseAuth fauth;String email,password,confirmPassword,username;bool dontMatch,alreadyUsed,hide,chide;CustomUser user;GoogleSignIn googleSignIn;FacebookLogin facebookLogin;
  @override
  void initState(){
    getApp();
    dontMatch = false;
    alreadyUsed = false;
    hide = true;
    chide = true;
    googleSignIn = GoogleSignIn();
    googleSignIn.onCurrentUserChanged.listen((account) {
      if(account != null){
        user = CustomUser(username: account.displayName,email: account.email,dateJoined: DateTime.now());
        Navigator.of(context).push(home(user));
      }
    });
    facebookLogin = FacebookLogin();
    super.initState();
  }

  getApp() async{
    FirebaseApp app = await Firebase.initializeApp();
    setState(() {
      fauth = FirebaseAuth.instanceFor(app:app);
    });
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

  Route home(CustomUser user){
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Home(user: user,),
      transitionsBuilder: (context, animation, secondaryAnimation, child){
        return SlideTransition(
          position: animation.drive(Tween(begin:Offset(-1,0),end:Offset.zero)),
          child: child,
        );
      },
    );
  }

  signin() async {
    if(password == confirmPassword){
      try{
        await fauth.createUserWithEmailAndPassword(email: email.trim(), password: password.trim()).then(
          (value)=>{
            user = CustomUser(username:username,email: email.trim(),dateJoined: DateTime.now()),
            Navigator.of(context).push(home(user))
          }
        );
      } on FirebaseAuthException catch(e){
        if(e.code == 'email-already-in-use'){
          setState(() {
            alreadyUsed = true;
          });
        }
      }
    }else{
      setState(() {
        dontMatch = true;
      });
    }
  }

  facebook() async {
    var res = await facebookLogin.logIn(['email','name']);
    var token = res.accessToken.token;
    var graphResponse = await http.get('https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
    var profile = json.decode(graphResponse.body);
    user = CustomUser(email: profile["email"],username: profile["name"],dateJoined: DateTime.now());
    Navigator.of(context).push(home(user));
  }

  google() {
    googleSignIn.signIn().catchError((error){
      print("\n\nError is: " + error + "\n\n");
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(left:20,top:20),
                        child: GestureDetector(
                          onTap: ()=>Navigator.of(context).push(login()),
                          child: Icon(Icons.arrow_back)
                        ),
                      )
                    ),                    
                    Container(                 
                      child: Padding(
                      padding: const EdgeInsets.only(right:20,top:20),
                      child: GestureDetector(
                        onTap: null,
                        child: Text("Trouble signing up?",style:TextStyle(fontSize: 15,color:Color.fromRGBO(8, 199, 68, 1),))
                      ),
                    )
                  ),
                  ],
                ),
              Container(
                alignment: Alignment.topLeft,
                child:Padding(
                  padding: const EdgeInsets.only(top:30,left:50),
                  child: Text("Register",style:TextStyle(fontSize: 50,color:Color.fromRGBO(69, 69, 69, 1))),
                )
              ),
              Container(
                alignment: Alignment.centerLeft,
                child:Padding(
                  padding: const EdgeInsets.only(top:50,left:60,right:40),
                  child: Row(
                    children: <Widget>[
                      Text("Email",style:TextStyle(fontSize: 18,color:Color.fromRGBO(82,93,92,1))),
                      Expanded(child: Container(),),
                      Visibility(
                        visible: alreadyUsed,
                        child: Text("Email already registered",style:TextStyle(color:Colors.red[400])),
                      )
                    ],
                  ),
                )
              ),
              Container(
                alignment: Alignment.center,
                child:Padding(
                  padding: const EdgeInsets.only(top:10,left:40,right:40),
                  child: TextField(
                    onChanged: (value){
                      setState(() {
                        email = value;
                      });
                    },
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical:10),
                      filled: true,
                      fillColor: alreadyUsed ? Colors.red[100] : Color.fromRGBO(246, 246, 246, 1),
                      prefixIcon: Icon(Icons.alternate_email,color: Color.fromRGBO(82,93,92,1)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)
                      ), 
                    ),
                  ),
                )
              ),
              Container(
                alignment: Alignment.centerLeft,
                child:Padding(
                  padding: const EdgeInsets.only(top:10,left:60,right:40),
                  child: Text("Username",style:TextStyle(fontSize: 18,color:Color.fromRGBO(82,93,92,1))),
                )
              ),
              Container(
                alignment: Alignment.center,
                child:Padding(
                  padding: const EdgeInsets.only(top:10,left:40,right:40),
                  child: TextField(
                    onChanged: (value){
                      setState(() {
                        username = value;
                      });
                    },
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical:10),
                      filled: true,
                      fillColor: Color.fromRGBO(246, 246, 246, 1),
                      prefixIcon: Icon(Icons.person_outline,color: Color.fromRGBO(82,93,92,1)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)
                      ), 
                    ),
                  ),
                )
              ),
              Container(
                alignment: Alignment.centerLeft,
                child:Padding(
                  padding: const EdgeInsets.only(top:10,left:60,right:40),
                  child: Row(
                    children: <Widget>[
                      Text("Password",style:TextStyle(fontSize: 18,color:Color.fromRGBO(82,93,92,1))),
                      Expanded(child: Container(),),
                      Visibility(
                        visible: dontMatch,
                        child: Text("Passwords don't match",style:TextStyle(color:Colors.red[400])),
                      )
                    ],
                  ),
                )
              ),
              Container(
                alignment: Alignment.center,
                child:Padding(
                  padding: const EdgeInsets.only(top:10,left:40,right:40),
                  child: TextField(
                    onChanged: (value){
                      setState(() {
                        password = value;
                      });
                    },
                    obscureText: hide,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical:10),
                      filled: true,
                      fillColor: dontMatch ? Colors.red[100] : Color.fromRGBO(246, 246, 246, 1),
                      prefixIcon: Icon(Icons.lock_outline,color: Color.fromRGBO(82,93,92,1)),
                      suffixIcon:GestureDetector(
                        onTap: ()=>{
                          setState((){
                            hide = !hide;
                          })
                        },
                        child: Icon(hide ? Icons.visibility_off : Icons.visibility,color:Colors.black),), 
                        //Icon(Icons.visibility_off,color: Color.fromRGBO(218,218,218,1)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)
                      ), 
                    ),
                  ),
                )
              ),
              Container(
                alignment: Alignment.centerLeft,
                child:Padding(
                  padding: const EdgeInsets.only(top:10,left:60,right:40),
                  child: Text("Confirm Password",style:TextStyle(fontSize: 18,color:Color.fromRGBO(82,93,92,1))),
                )
              ),
              Container(
                alignment: Alignment.center,
                child:Padding(
                  padding: const EdgeInsets.only(top:10,left:40,right:40),
                  child: TextField(
                    onChanged: (value){
                      setState(() {
                        confirmPassword = value;
                      });
                    },
                    obscureText: chide,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical:10),
                      filled: true,
                      fillColor: dontMatch ? Colors.red[100] : Color.fromRGBO(246, 246, 246, 1),
                      prefixIcon: Icon(Icons.lock_outline,color: Color.fromRGBO(82,93,92,1)),
                      suffixIcon:GestureDetector(
                        onTap: ()=>{
                          setState((){
                            chide = !chide;
                          })
                        },
                        child: Icon(chide ? Icons.visibility_off : Icons.visibility,color:Colors.black)), 
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)
                      ), 
                    ),
                  ),
                )
              ),
              Padding(
                padding: const EdgeInsets.only(top:20),
                child: Container(
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      colors: [Color.fromRGBO(3, 163, 99, 1),Color.fromRGBO(8, 199, 68, 1)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight
                    )
                  ),
                  alignment: Alignment.center,
                  child: MaterialButton(
                    onPressed: ()=>signin(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Register",style:TextStyle(color:Colors.white,fontSize: 18)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:10),
                          child: Icon(Icons.exit_to_app,color:Colors.white),
                        )
                      ],
                    ),
                  )
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Already have an account? ",style:TextStyle(fontSize:15,fontFamily: 'Mulish-Reg')),
                    GestureDetector(
                      onTap: ()=>Navigator.of(context).push(login()),
                      child: Text("Log in",style:TextStyle(fontSize:15))
                    )
                  ],
                )
              ),
              Padding(
                padding: EdgeInsets.only(top:30,left:30,right:30),
                child: Image.asset('assets/or.png')
              ),
              Padding(
                padding: EdgeInsets.only(top:30,bottom:20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:20),
                      child: GestureDetector(
                        onTap: null,
                        child: Image.asset('assets/fb.png',scale: 2.5,)
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:20),
                      child: GestureDetector(
                        onTap: ()=>google(),
                        child: Image.asset('assets/google.png',scale: 2.5,)
                      ),
                    )
                  ],
                )
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: Image.asset('assets/bottom.png'),
              )
            ],
          ),
        )
      )
    );
  }
}