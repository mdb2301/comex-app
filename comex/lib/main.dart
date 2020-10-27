import 'dart:convert';

import 'package:comex/NewListingPage.dart';
import 'package:comex/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'User.dart';
import 'home.dart';
import 'package:http/http.dart' as http;
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Mulish',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: NewListingPage()//Login(),
    );
  }
}

class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  String email,password;bool emailError,passwordError,hide;FirebaseAuth fauth;CustomUser user;GoogleSignIn googleSignIn;FacebookLogin facebookLogin;

  @override
  void initState(){
    getApp();
    emailError = false;
    passwordError = false;
    hide = true;
    googleSignIn = GoogleSignIn();

//    Commenting this out as navigation should happen after we communicate with our server
//    googleSignIn.onCurrentUserChanged.listen((account) {
//      if(account != null){
//        user = CustomUser(username: account.displayName,email: account.email);
//        Navigator.of(context).push(home(user));
//      }
//    });
    facebookLogin = FacebookLogin();
    super.initState();
  }

  getApp() async{
    FirebaseApp app = await Firebase.initializeApp();
    setState(() {
      fauth = FirebaseAuth.instanceFor(app:app);
    });
  }

  Route register(){
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Register(),
      transitionsBuilder: (context, animation, secondaryAnimation, child){
        return SlideTransition(
          position: animation.drive(Tween(begin: Offset(1.0,0.0),end: Offset.zero)),
          child: child,
        );
      },
    );
  }

  Route home(CustomUser user){
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Home(user:user),
      transitionsBuilder: (context, animation, secondaryAnimation, child){
        return SlideTransition(
          position: animation.drive(Tween(begin:Offset(-1,0),end:Offset.zero)),
          child: child,
        );
      },
    );
  }

  signin() async {
    print('signin() called');
    try{
      await fauth.signInWithEmailAndPassword(email: email.trim(), password: password.trim()).then(
        (value)=>{
          user = CustomUser(email: email.trim()),
          Navigator.of(context).push(home(user))
        }
      );
    } on FirebaseAuthException catch(e){
      if(e.code == 'user-not-found'){
        setState(() {
          emailError = true;
        });
      }
      if(e.code == 'wrong-password'){
        setState(() {
          passwordError = true;
        });
      }
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

  google() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult = await fauth.signInWithCredential(credential);
    final User gUser = authResult.user;

    if (gUser != null) {
//      user = CustomUser(email: gUser.email, username: gUser.displayName, dateJoined: DateTime.now(), firebaseId: gUser.uid);
      print('Signed in with Google: ' + gUser.displayName + ' ' + gUser.email + ' ' + gUser.uid);
      getUserDataFromServer(gUser);
    } else {
      print('Why is user null? :(');
    }
  }

  getUserDataFromServer(User user) async {
    //  This functions sends Firebase User's data to our server to fetch his details
    //  The response will contain necessary info that will be required to handle routing and populating the UI
    //  This function will be common to both Firebase and Google login

    final http.Response response = await http.post(
        'https://guarded-cove-87354.herokuapp.com/users/',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
//          TODO: Split user.displayName into first_name and last_name
          'first_name': user.displayName,
          'last_name': 'temp',
          'email': user.email,
          'firebase_id': user.uid
        }),
      );

      if(response.statusCode == 200) {
//      Server will tell us whether profile is updated or not
//      If yes, take him to the home page, else take him to the profile update page
        CustomUser userFromServer = CustomUser.fromJson(jsonDecode(response.body));

        if(userFromServer.profileUpdated) {
          // to home page
          // TODO: Server will also send other data about his profile, later on
          // TODO: This data can be passed on to the home page to populate the screen
          Navigator.of(context).push(home(userFromServer));
          print('Redirected to home page');
        } else {
//          to profile update page
          print('Redirected to profile update page');
        }
      } else {
        print('Request error: ' + response.body);
      }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right:20,top:20),
                  child: GestureDetector(
                    onTap: null,
                    child: Text("Trouble logging in?",style:TextStyle(fontSize: 15,color:Color.fromRGBO(8, 199, 68, 1)))
                  ),
                )
              ),
              Container(
                alignment: Alignment.topLeft,
                child:Padding(
                  padding: const EdgeInsets.only(top:30,left:50),
                  child: Text("Login",style:TextStyle(fontSize: 50,color:Color.fromRGBO(69, 69, 69, 1))),
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
                        visible: emailError,
                        child: Text("Invalid Email",style:TextStyle(color:Colors.red[400])),
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
                    onChanged: (value)=>{
                      setState((){
                        email = value;
                      })
                    },
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical:13),
                      filled: true,
                      fillColor: emailError ? Colors.red[100] : Color.fromRGBO(246, 246, 246, 1),
                      prefixIcon: Icon(Icons.alternate_email),
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
                  padding: const EdgeInsets.only(top:30,left:60,right:40),
                  child: Row(
                    children: <Widget>[
                      Text("Password",style:TextStyle(fontSize: 18,color:Color.fromRGBO(82,93,92,1))),
                      Expanded(child: Container(),),
                      Visibility(
                        visible: passwordError,
                        child: Text("Incorrect Password",style:TextStyle(color:Colors.red[400])),
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
                    onChanged: (value)=>{
                      setState((){
                        password = value;
                      })
                    },
                    obscureText: true,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical:13),
                      filled: true,
                      fillColor: passwordError ? Colors.red[100] : Color.fromRGBO(246, 246, 246, 1),
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon:GestureDetector(
                        onTap: ()=>{
                          setState((){
                            hide = !hide;
                          })
                        },
                        child: Icon(hide ? Icons.visibility_off : Icons.visibility,color:Colors.black),
                      ),
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
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right:60,top:20),
                  child: GestureDetector(
                    onTap: null,
                    child: Text("Forgot password?",style:TextStyle(fontSize: 16,color:Color.fromRGBO(8, 199, 68, 1)))
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
                    onPressed: signin,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Log In",style:TextStyle(color:Colors.white,fontSize: 18)),
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
                    Text("Don't have an account? ",style:TextStyle(fontSize:15,fontFamily: 'Mulish-Reg')),
                    GestureDetector(
                      onTap: ()=>Navigator.of(context).push(register()),
                      child: Text("Sign up",style:TextStyle(fontSize:15))
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
                        onTap: ()=>facebook(),
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
                child: Image.asset('assets/bottom.png')
              )
            ],
          ),
        )
      )
    );
  }
}
