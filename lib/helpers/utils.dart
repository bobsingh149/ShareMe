import 'dart:math';

import 'package:flutter/material.dart';
import 'package:insta/utility/colors.dart';
import 'package:image_picker/image_picker.dart';

 showSnackbar(BuildContext context,String text)
{
 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
   backgroundColor: MyColors.blueColor,
                        action: SnackBarAction(label: 'Close', onPressed: (){
                        
                        }),
                        content: Text(text,style: const TextStyle(color: Colors.white), ),
                      duration:const Duration(seconds:4 ) ,));

}

pickImage(ImageSource source) async
{
final ImagePicker picker=ImagePicker();

final XFile? file= await picker.pickImage(source: source);

if(file!=null)
{
  return file.readAsBytes();
}

print('No img seleced');

}