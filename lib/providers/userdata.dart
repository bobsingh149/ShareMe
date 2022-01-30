

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:insta/helpers/firebasequeries.dart';
import 'package:insta/models/user.dart';

class UserProvider with ChangeNotifier
{
  UserModel? _user;


UserModel? get getuser
{
  return _user;
}

 Future<void> init() async
  {
   final data=await FirebaseHelper.getitem(collectionpath: 'users', itemid: FirebaseHelper.getid()) as Map<String,dynamic>;
 print('done with ease 11111111111111' );
 print(data);
   _user= UserModel.getuser(data);

   print('done with ease 22222222222222222');
notifyListeners();
  
  }


}