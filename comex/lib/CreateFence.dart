
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'API.dart';
import 'CustomUser.dart';
import 'home.dart';

class CreateFence extends StatefulWidget {
  final CustomUser user;
  final auth;
  CreateFence({this.user,this.auth});
  @override
  _CreateFenceState createState() => _CreateFenceState();
}

class _CreateFenceState extends State<CreateFence> {
  bool loading;

  @override
  void initState(){
    loading = false;
    super.initState();
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

  addFence(data) async {
    setState(() {
      loading = true;
    });
    var pt1 = data["coordinates"]["pt1"];
    var pt2 = data["coordinates"]["pt2"];
    APIResponse res = await API().addFence(pt1["latitude"],pt1["longitude"],pt2["latitude"],pt2["longitude"],data["name"],data["id"]);
    print("\n\n${res.code}\n\n");
    if(res.code==0){
      widget.user.fenceId = data["id"];
      APIResponse r = await API().addUser(widget.user);
      if(r.code==0){
        Navigator.of(context).push(home(r.user,widget.auth));
      }else{
        print("Error registering"+res.message);
        widget.auth.deleteUser();
      }
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SafeArea(
          child: Stack(
            children: [
              WebView(
                initialUrl: "https://comex-geofence.herokuapp.com/",
                javascriptMode: JavascriptMode.unrestricted,
                javascriptChannels: <JavascriptChannel>[
                  JavascriptChannel(
                      name: 'MobileApp',
                      onMessageReceived:(JavascriptMessage message){
                        var s = json.decode(message.message);
                        addFence(s);
                      }
                  )
                ].toSet(),
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
    );
  }
}