import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:insta/screens/profilescreen.dart';
import 'package:insta/utility/colors.dart';
import 'package:insta/utility/dimensions.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController query = TextEditingController();
  bool _isshowusers = false;

  @override
  void dispose() {
    super.dispose();
    query.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: width >= websize
              ? MyColors.webBackgroundColor
              : MyColors.mobileBackgroundColor,
          title: TextField(
            controller: query,
            decoration: const InputDecoration(
                labelText: 'Search for a user', hintText: 'Type username'),
            onSubmitted: (String val) {
              print('submitted from field');
              setState(() {
                _isshowusers = true;
              });
            },
          ),
          actions: [
            IconButton(
                onPressed: () {
                  print('submitted');

                  setState(() {
                    _isshowusers = true;
                  });
                },
                icon: const Icon(Icons.search))
          ],
        ),
        body: _isshowusers
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where('username', isGreaterThanOrEqualTo: query.text)
                    .get(),
                builder: (ctx,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snaps) {
                  // if (snaps.connectionState == ConnectionState.waiting) {
                  //   return const Center(
                  //     child: CircularProgressIndicator(
                  //       color: MyColors.primaryColor,
                  //     ),
                  //   );
                  // }

                  // else if(snaps.connectionState==ConnectionState.active)
                  // {
                  if (snaps.connectionState == ConnectionState.waiting ||
                      !snaps.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: MyColors.primaryColor,
                      ),
                    );
                  }

                  return ListView.builder(
                      itemCount: snaps.data!.docs.length,
                      itemBuilder: (ctx, idx) {
                        final userData = snaps.data!.docs[idx].data();

                        print(userData);
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) =>
                                    ProfileScreen(uid: userData['uid'])));
                          },
                          splashColor: Colors.blueAccent,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(userData['pic']),
                            ),
                            title: Text(
                              userData['username'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(userData['bio']),
                            trailing: Text(userData['email']),
                          ),
                        );
                      });

                  // return const Center(child: Text('Found no match'),);
                })
            : FutureBuilder(
                future: FirebaseFirestore.instance.collection('posts').get(),
                builder: (ctx,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snaps) {
                  if (snaps.connectionState == ConnectionState.waiting ||
                      !snaps.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: MyColors.primaryColor,
                      ),
                    );
                  }

                  return GridView.count(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    children: snaps.data!.docs
                        .map((e) => Image.network(
                              e['postUrl'],
                              fit: BoxFit.cover,
                            ))
                        .toList(),
                  );
                }));
  }
}
