import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta/helpers/firebasequeries.dart';
import 'package:insta/helpers/utils.dart';
import 'package:insta/models/posts.dart';
import 'package:insta/providers/userdata.dart';
import 'package:insta/utility/colors.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostState();
}

class _PostState extends State<PostScreen> {
  bool _isloading = false;
  var uuid = Uuid();
  TextEditingController caption = TextEditingController();

  Uint8List? _img;

  @override
  void dispose() {
    super.dispose();

    caption.dispose();
  }

  _selectimage(BuildContext context) async {
    showDialog(
        context: context,
        builder: (ctx) {
          return SimpleDialog(
            title: const Text('Create a post'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  final file =
                      await pickImage(ImageSource.gallery) as Uint8List;

                  setState(() {
                    _img = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Camera'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  final file = await pickImage(ImageSource.camera) as Uint8List;

                  setState(() {
                    _img = file;
                  });
                },
              ),
              SimpleDialogOption(
                  padding: const EdgeInsets.all(20),
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).getuser;
    return _img == null
        ? Center(
            child: IconButton(
              onPressed: () {
                _selectimage(context);
              },
              icon: const Icon(
                Icons.upload,
                size: 35,
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text('Post to'),
              backgroundColor: MyColors.mobileBackgroundColor,
              leading: IconButton(
                  onPressed: () {
                    setState(() {
                      _img = null;
                    });
                  },
                  icon: const Icon(Icons.arrow_back)),
              centerTitle: false,
              actions: [
                TextButton(
                    onPressed: () async {
                      setState(() {
                        _isloading = true;
                      });
                      try {
                        final postid = uuid.v1();
                        String postlink = await FirebaseHelper.bukcetgetlink(
                            child1: 'posts', child2: postid, file: _img!);

                        final post = Post(
                          datePublished: DateTime.now(),
                          username: user!.username,
                          description: caption.text,
                          likes: [],
                          postId: postid,
                          postUrl: postlink,
                          uid: FirebaseHelper.getid(),
                          profImage: user.link,
                        );
caption.text='';
                        await FirebaseHelper.addwithid(
                            collectionpath: 'posts',
                            itemid: postid,
                            data: post.toJson());


                        setState(() {
                          _isloading = false;
                        });
                        showSnackbar(context, 'Uploaded');
                        print('Posts submitted to the firebase');

                        setState(() {
                          _img = null;
                        });
                      } catch (e) {
                        setState(() {
                          _isloading = false;
                        });

                        showSnackbar(context, e.toString());

                        print(e.toString());
                      }
                    },
                    child: const Text(
                      'Post',
                      style: TextStyle(
                          color: MyColors.blueColor,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ))
              ],
            ),
            body: Column(
              children: [
                if (_isloading)
               const   LinearProgressIndicator(
                    color: Colors.blue,
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        user!.link,
                      ),
                      radius: 45,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Type your caption...',
                        ),
                        maxLines: 9,
                        controller: caption,
                      ),
                    ),
                    SizedBox(
                      height: 70,
                      width: 70,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  alignment: FractionalOffset.topCenter,
                                  image: MemoryImage(_img!))),
                        ),
                      ),
                    )
                  ],
                ),
                const Divider(
                  thickness: 2,
                  color: Colors.grey,
                ),
              ],
            ),
          );
  }
}
