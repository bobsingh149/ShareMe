import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta/helpers/utils.dart';
import 'package:insta/models/user.dart';
import 'package:insta/providers/userdata.dart';
import 'package:insta/utility/colors.dart';
import 'package:insta/utility/dimensions.dart';
import 'package:insta/widgets/commentitem.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CommentScreen extends StatefulWidget {
  static const String routename = '/comments';
  
  const CommentScreen({Key? key}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
bool _isloading=false;
  String postid='';
bool init=true;
TextEditingController comment= TextEditingController();
UserModel? user;
@override
  void dispose() {
    
    super.dispose();

    comment.dispose();
  }

@override
  void didChangeDependencies() {

    if(init){

     user= Provider.of<UserProvider>(context,listen: false).getuser;
    
    if(ModalRoute.of(context)!.settings.arguments!=null){
   final data= ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;
   postid=data['postid'];
    }
init=false;

    }

    super.didChangeDependencies();
  }

  postComment(String text) async
  {
    if(text.isEmpty)
    {
      return;
    }
    //postid, username, profilepic, uid, text,id
    try{

      setState(() {
        _isloading=true;
      });
    print('postid ');
    print(postid);
    if(postid!=''){
final String id= Uuid().v1();

    await FirebaseFirestore.instance.collection('posts').doc(postid).collection('comments').doc(id).set({
      'id':id,
      'text':text,
      'postId':postid,
      'username':user!.username,
      'profilePic':user!.link,
      'uid':user!.uid,
      'date':DateTime.now()



    });

    print('comment posted successfully');

    comment.text='';

     setState(() {
        _isloading=false;
      });
    }
    }
    catch(e)
    {
       setState(() {
        _isloading=false;
      });
      showSnackbar(context, e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    final width=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor:width>=websize ?MyColors.webBackgroundColor   :MyColors.mobileBackgroundColor,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text('Comments'),
        centerTitle: false,
      ),
      body: StreamBuilder(stream: 
      FirebaseFirestore.instance.collection('posts')
      .doc(postid).collection('comments').orderBy('date',descending: true).snapshots(),
      builder: (ctx,AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snaps){

        if(snaps.connectionState==ConnectionState.waiting)
        {
          return const Center(child: CircularProgressIndicator(color: MyColors.primaryColor,),);
        }

      else if(snaps.connectionState==ConnectionState.active)
      {
        if(snaps.hasError)
        {
          return const Center(child: Text('Some error occured'),);
        }
        return ListView.builder(
          itemCount: snaps.data!.docs.length,
          itemBuilder: (ctx,idx){

            final commentdata=snaps.data!.docs[idx].data();

print('data');
            print(commentdata);

            return CommentItem(
              date:commentdata['date'] ,
              id: commentdata['id'],
              profilepic: commentdata['profilePic'],
              text: commentdata['text'],
              username: commentdata['username'],
              
            );

          });
      }
       return const Center(child: Text('Some error occured'),);
      },
     ),
      bottomNavigationBar: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           
           if(_isloading)
          const LinearProgressIndicator(color: Colors.blueAccent,),

          
            
            Container(
              height: kToolbarHeight,
              padding: const EdgeInsets.only(left: 16, right: 8),
              margin:
                  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      user!.link),
                    radius: 20,
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: TextField(
                      controller: comment,
                      decoration:
                          InputDecoration(hintText: 'Comment as ${user!.username}'),
                    ),
                  )),
                  Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: TextButton(
                      onPressed: () {
                        postComment(comment.text);
                      },
                      child: const Text(
                        'Post',
                        style: TextStyle(
                          fontSize: 18,
                            color: Colors.blue, fontWeight: FontWeight.w900),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
