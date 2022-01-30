import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta/utility/colors.dart';
import 'package:insta/utility/dimensions.dart';
import 'package:insta/widgets/postitem.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  State<Feed> createState() => _FeedState();
}

 bool isweb(context)
{
  if(MediaQuery.of(context).size.width>=websize){
  return true;
  }

  else{
  return false;
  }

}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
      final width=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: 
      !isweb(context) ?
       AppBar(
        title: SvgPicture.asset(
          'instaimg.svg',
          color: MyColors.primaryColor,
          height: 32,
        ),
        centerTitle: false,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.message))
        ],
      ):AppBar(title:const Text('Feed Screen')),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder:
            (ctx, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snaps) {
          if (snaps.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: MyColors.primaryColor,
              ),
            );
          }

          if (snaps.connectionState == ConnectionState.active) {
            return ListView.builder(
                itemCount: snaps.data!.docs.length,
                itemBuilder: (c, idx) {
                 var data= snaps.data!.docs[idx].data();
                  return PostItem(
                    datepublished: data['datePublished'],
                    description: data['description'],
                    likes:data['likes'] ,
                    postlink:data['postUrl'] ,
                    profilepic:data['profImage'] ,
                    username: data['username'],
                    authorid:data['uid'],
                    postid: data['postId'],
                  
                  );
                });
          }

          return const Text('Error');
        },
      ),
    );
  }
}
