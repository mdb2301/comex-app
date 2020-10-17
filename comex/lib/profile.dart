import 'package:comex/User.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final CustomUser user;
  ProfilePage({this.user});
  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<ProfilePage> {
  CustomUser user;
  @override
  void initState() {
    user = widget.user;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    
  }  
}