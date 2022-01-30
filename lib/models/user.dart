

import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class UserModel
{
  final String uid;
  final String email;
  final String password;
  final String bio;
  final String username;
  
   List<dynamic> followers=[];
   List<dynamic> following=[];
   String  link='';
   Uint8List profilepic=Uint8List(1);

  UserModel({this.uid='', this.password='',required this.username,
  required this.bio,required this.email,this.link=''});



  static UserModel getuser(Map<String,dynamic> data)
  {
    UserModel user= UserModel(
      bio: data['bio'],email: data['email'],username: data['username'],uid: data['uid'],
    link: data['pic']
     );


    user.following=data['following'];
    user.followers=data['followers'];

    return user;
      

  } 


Map<String,dynamic>  getMap(String link)
{
  return {
    'uid':FirebaseAuth.instance.currentUser?.uid,
    'username':this.username,
    'email':this.email,
    'bio':this.bio,
    'pic':link,
    'followers':this.followers,
    'following':this.following,




  };
}


}


  


