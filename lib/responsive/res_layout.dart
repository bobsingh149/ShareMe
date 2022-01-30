import 'package:flutter/material.dart';
import 'package:insta/providers/userdata.dart';
import 'package:insta/utility/dimensions.dart';
import 'package:provider/provider.dart';

class ResLayout extends StatefulWidget {
  static const String routename='/reslayout'; 
  final Widget web;
  final Widget mobile;
   const ResLayout({Key? key,required this.mobile,required this.web }) : super(key: key);

  @override
  State<ResLayout> createState() => _ResLayoutState();
}

class _ResLayoutState extends State<ResLayout> {


@override
  void initState() {
  
    super.initState();

    initilize();
  }
  
void initilize() async
{
  final userdata=Provider.of<UserProvider>(context,listen: false);

try{
 await userdata.init();


}
catch(e)
{print(e);
}


}
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx,constrainst){
          if(constrainst.maxWidth>websize)
          {
              return widget.web;
          }
          else
          {
            return widget.mobile;

          }
      },
      
    );
  }
}
