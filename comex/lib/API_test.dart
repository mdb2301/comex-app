import 'package:comex/API.dart';
import 'package:comex/CustomUser.dart';
import 'package:test/test.dart';

void main(){
  test(
    "Test",
    ()=>API().addUser(CustomUser(name:"Test",firebaseId:"test_id",email:"testmail",fenceId:"1"))
  );
}