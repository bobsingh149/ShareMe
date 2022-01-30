import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta/utility/colors.dart';
import 'package:intl/intl.dart';

class CommentItem extends StatefulWidget {
  final String id;
  final String username;
  final Timestamp date;
  final String text;
  final String profilepic;

  CommentItem(
      {Key? key,
      required this.profilepic,
      required this.username,
      required this.date,
      required this.id,
      required this.text})
      : super(key: key);

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  bool isfav = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 17),
      child: Card(
        elevation: 30,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        shadowColor: Colors.blueAccent,
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                widget.profilepic
                  ),
              radius: 21,
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                      text: TextSpan(
                          style: const TextStyle(color: Colors.white),
                          children: [
                        TextSpan(
                            text: widget.username,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: ' ${widget.text}',
                            style: const TextStyle(fontSize: 12)),
                      ])),
                  Text(
                    DateFormat.yMMMMEEEEd().format(widget.date.toDate()),
                    style: TextStyle(
                        color: Colors.white54,
                        fontWeight: FontWeight.w500,
                        fontSize: 11),
                  )
                ],
              ),
            ),
            IconButton(
                onPressed: () {
                  setState(() {
                    isfav = !isfav;
                  });
                },
                icon: Icon(
                  Icons.favorite,
                  color: isfav ? Colors.red : Colors.white,
                ))
          ],
        ),
      ),
    );
  }
}
