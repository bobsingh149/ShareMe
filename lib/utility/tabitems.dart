
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:insta/helpers/firebasequeries.dart';
import 'package:insta/screens/feedscreen.dart';
import 'package:insta/screens/profilescreen.dart';
import 'package:insta/screens/search.dart';
import 'package:insta/widgets/post.dart';

var homeItems=[
Feed(),
Search(),
PostScreen(),
const Center(child: Text('Notifications')),
ProfileScreen(uid:FirebaseAuth.instance.currentUser!.uid),

];