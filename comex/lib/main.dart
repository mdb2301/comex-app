import 'package:comex/API.dart';
import 'package:comex/Authentication.dart';
import 'package:comex/Storage.dart';
import 'package:comex/register.dart';
import 'package:flutter/material.dart';
import 'CustomUser.dart';
import 'home.dart';
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
      home: SplashScreen()
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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

  Route home(CustomUser user,dynamic auth){
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Home(user: user,auth:auth),
      transitionsBuilder: (context, animation, secondaryAnimation, child){
        return SlideTransition(
          position: animation.drive(Tween(begin:Offset(-1,0),end:Offset.zero)),
          child: child,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    checkStorage();
  }

  checkStorage() async {
    StorageResponse res = await Storage().read();
    if(res.isLoggedIn != null){
      if(res.isLoggedIn){
        var r = await API().getUser(res.firebaseId);
        if(r.code==0){
          Navigator.of(context).push(home(r.user,res.type));
          return;
        } 
      }        
    }
    Navigator.of(context).push(login());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        child:Center(
          child: Text("ComEx")
        )
      )
    );
  }
}

class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  bool emailError,passwordError,hide,loading;CustomUser user;
  TextEditingController emailcontroller,passwordcontroller;
  @override
  void initState(){
    emailcontroller = TextEditingController();
    passwordcontroller = TextEditingController();
    emailError = false;
    passwordError = false;
    hide = true;
    loading = false;
    super.initState();
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

  Route home(CustomUser user,dynamic auth){
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Home(user:user,auth: auth,),
      transitionsBuilder: (context, animation, secondaryAnimation, child){
        return SlideTransition(
          position: animation.drive(Tween(begin:Offset(-1,0),end:Offset.zero)),
          child: child,
        );
      },
    );
  }

  signin() async {
    setState(() {
      loading = true;
    });
    final email = emailcontroller.value.text.trim();
    final password = passwordcontroller.value.text.trim();
    final auth = Email();
    AuthResponse res = await auth.signInWithEmailAndPassword(email, password);
    switch(res.code){
      case 0:
        final apiResponse = await API().getUser(res.user.firebaseId);
        if(apiResponse.code==0){
          final storage = Storage();
          final r = await storage.write(apiResponse.user.firebaseId,auth.type);
          if(r.code==0){
            Navigator.of(context).push(home(res.user,auth.type));
          }
        }
        break;
      case 1:
        setState(() {
          emailError = true;
          loading = false;
        });
        break;
      case 2:
        setState(() {
          passwordError = true;
          loading = false;
        });
    }
  }

  facebook() async {
    setState(() {
      loading = true;
    });
    final facebookauth = Facebook();
    facebookauth.continueWithFacebook().then((res){
      if(res.code==0){
        API().getUser(res.user.firebaseId).then((apiResponse){
          if(apiResponse.code==0){
            setState(() {
              loading = false;
            });
            Navigator.of(context).push(home(user,facebookauth.type));
          }
        });
      }else{
        //error dialog
      }
    });
    
  }

  google() async {
    final googleSignIn = Google();
    final res = await googleSignIn.continueWithGoogle();
    if(res.code==0){
      final apiResponse = await API().getUser(res.user.firebaseId);
      if(apiResponse.code==0){
        Navigator.of(context).push(home(user,googleSignIn.type));
      }
    }else{
      print(res.code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: null,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                Column(
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
                          controller: emailcontroller,
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
                          controller: passwordcontroller,
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
                loading ? 
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.black26,
                  child: Center(
                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(3, 163, 99, 1))),
                  ),
                ):
                Positioned(
                  bottom: 0,
                  height: 0,
                  width: 0,
                  child: Container()
                )
              ],
            ),
          )
        )
      ),
    );
  }
}




