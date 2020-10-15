import 'package:comex_test/bookDetails.dart';
import 'package:comex_test/register.dart';
import 'package:flutter/material.dart';

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
      home: Login(),
    );
  }
}

class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {

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

  Route bookDetails(){
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => BookDetailsPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child){
        return SlideTransition(
          position: animation.drive(Tween(begin:Offset(-1,0),end:Offset.zero)),
          child: child,
        );
      },
    );
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
                  child: Text("Username",style:TextStyle(fontSize: 18,color:Color.fromRGBO(82,93,92,1))),
                )
              ),
              Container(
                alignment: Alignment.center,
                child:Padding(
                  padding: const EdgeInsets.only(top:10,left:40,right:40),
                  child: TextField(
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical:13),
                      filled: true,
                      fillColor: Color.fromRGBO(246, 246, 246, 1),
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
                  child: Text("Password",style:TextStyle(fontSize: 18,color:Color.fromRGBO(82,93,92,1))),
                )
              ),
              Container(
                alignment: Alignment.center,
                child:Padding(
                  padding: const EdgeInsets.only(top:10,left:40,right:40),
                  child: TextField(
                    obscureText: true,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical:13),
                      filled: true,
                      fillColor: Color.fromRGBO(246, 246, 246, 1),
                      prefixIcon: Icon(Icons.lock_outline),
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
                    onPressed: ()=>Navigator.of(context).push(bookDetails()),
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
                        onTap: null,
                        child: Image.asset('assets/fb.png',scale: 2.5,)
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:20),
                      child: GestureDetector(
                        onTap: null,
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
