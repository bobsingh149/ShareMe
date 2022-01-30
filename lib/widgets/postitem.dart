import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:insta/helpers/firebasequeries.dart';
import 'package:insta/helpers/utils.dart';
import 'package:insta/providers/userdata.dart';
import 'package:insta/screens/comments.dart';
import 'package:insta/utility/colors.dart';
import 'package:insta/utility/dimensions.dart';
import 'package:insta/widgets/animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostItem extends StatefulWidget {
  final String username;
  final List<dynamic> likes;
  final String profilepic;
  final Timestamp datepublished;
  final String postlink;
  final String description;
  final String authorid;
  final String postid;

  const PostItem(
      {Key? key,
      required this.postid,
      required this.authorid,
      required this.username,
      required this.profilepic,
      required this.datepublished,
      required this.description,
      required this.likes,
      required this.postlink})
      : super(key: key);

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
@override
void initState() {
  super.initState();

  getCommentLength();
}

  bool isloading=false;
  String count='300';
 getCommentLength() async
     {
       try{

     final snaps=await FirebaseFirestore.instance.collection('posts').doc(widget.postid).collection('comments').get();
  

int len=snaps.docs.length;
setState(() {
  count=len.toString();
  
});

print('success');
       }
       catch(e)
       {
         print(e.toString());

       }

     }


 delete(context) async
{
  try{
  await FirebaseFirestore.instance.collection('posts').doc(widget.postid).delete();

  showSnackbar(context,'Post Deleted');
  }
  catch(e)
  {
    showSnackbar(context, e.toString());

  }
}


  updatelikes(user) async
  {
  if (widget.likes.contains(user.uid)) {
                       // widget.likes.remove(user.uid);
                            await FirebaseFirestore.instance
                          .collection('posts')
                          .doc(widget.postid).update({'likes':FieldValue.arrayRemove([user.uid])});
                      } else {
                       
                            await FirebaseFirestore.instance
                          .collection('posts')
                          .doc(widget.postid).update({'likes':FieldValue.arrayUnion([user.uid])});
                      }

                  
  }

  bool isanimating=false;
  Color get color {
    if (widget.likes.contains(FirebaseAuth.instance.currentUser!.uid)) {
      return Colors.red;
    }

    return Colors.white;
  }

  navigate(context)
  {
     Navigator.of(context).pushNamed(CommentScreen.routename,arguments: {'postid':widget.postid});
  }



  @override
  Widget build(BuildContext context) {
final width=MediaQuery.of(context).size.width;
    
    final user = Provider.of<UserProvider>(context, listen: false).getuser;

    
    return  Container(
      margin:width>=websize ? 
      EdgeInsets.symmetric(horizontal: width*0.1, vertical: 7) :const EdgeInsets.symmetric(
        vertical: 1,horizontal: 0
      ),
     decoration: BoxDecoration(border:width>=websize ?Border.all(

       color: Colors.grey,
       width: 2,
       

     ) :Border.all(color: MyColors.mobileBackgroundColor),

     borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
       
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.profilepic),
                  radius: 20,
                ),
               
             
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 9),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.username,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (ctx) {
                            return Dialog(
                              child: ListView(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                shrinkWrap: true,
                                children: ['Delete']
                                    .map((e) => InkWell(
                                          splashColor: Colors.red,
                                          onTap: () {
                                            Navigator.of(context).pop();
                                            delete(context);

                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(16),
                                            child: Text(e),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            );
                          });
                    },
                    icon: const Icon(Icons.more_vert_outlined))
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () {
              setState(() {
                isanimating=true;
              });

                   updatelikes(user);
            },
            child: Stack(
              alignment: Alignment.center,
              children: [Container(
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                child: Image.network(
                  widget.postlink,
                  fit: BoxFit.cover,
                ),
              ),
             AnimatedOpacity(
               curve: Curves.linear,
               duration:const Duration(microseconds: 500),
                opacity: isanimating?1 :0,
                child: LikeAnimation(
                  duration: const Duration(microseconds: 500),
                  onEnd: (){
                    setState(() {
                      isanimating=false;
                    });
                  },
                  isAnimating:isanimating,
                  child: IconButton(onPressed: (){}, icon: Icon(Icons.favorite,color: Colors.red,size: 30,))),
              )
              ]
            ),
          ),
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.likes.contains(user!.uid),
                smallLike: true,
                child: IconButton(
                    onPressed: () async {

                      await updatelikes(user);
                    
                        
                    },
                    icon: Icon(
                      Icons.favorite,
                      color: color,
                    )),
              ),
              IconButton(
                  onPressed: () {
                    navigate(context);
                  },
                  icon: const Icon(
                    Icons.comment_outlined,
                  )),
              IconButton(onPressed: () {}, icon: const Icon(Icons.send)),
              Expanded(
                  child: Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.bookmark_outline,
                            color: Colors.green,
                          )))),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(fontWeight: FontWeight.w800),
                    child: Text(
                      '${widget.likes.length} likes',
                      style: Theme.of(context).textTheme.bodyText2,
                    )),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                      text: TextSpan(
                          style: const TextStyle(color: MyColors.primaryColor),
                          children: [
                        TextSpan(
                            text: widget.username,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: '  ${widget.description}',
                            style: const TextStyle(color: Colors.white)),
                      ])),
                ),
                InkWell(
                    splashColor: Colors.green,
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 7),
                      child: TextButton(
                        onPressed: (){
                          navigate(context);
                    
                        },
                        child: Text('View all $count comments',
                        style: const TextStyle(
                            color: MyColors.secondaryColor, fontSize: 15),
                       ) ),
                    )),
                Container(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: Text(
                      DateFormat.yMMMEd().format(widget.datepublished.toDate()),
                      //  DateFormat.yMd().format(widget.datepublished),
                      style: const TextStyle(
                          color: MyColors.secondaryColor, fontSize: 11),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
