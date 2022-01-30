import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {

  bool animate=false;

 Matrix4  matrix()
{
if(animate)
{
return Matrix4.skewX(7)..translate(100,-60)..scale(1.3,0.5);
}
else{
return Matrix4.rotationY(0);
}
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [FloatingActionButton(onPressed: (){

        

        setState(() {
          animate=!animate;
        });


      })],),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Card(
              elevation: 30,
              child: Container(
                width: 300,
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(10),
                color: Colors.white54,
                
            
                child: ListTile(
                  leading:Text('leading'),
                  title: Text('Title'),
                  subtitle: Text('Subtitle'),
                  trailing: Text('Trailing'),
                ),
              ),
            ),

          

            Container(
              height: 300,
              child: Stack(
                alignment: Alignment.center,
                children: [Transform(
                  transform:matrix(),
                 // origin: Offset(50, 50),
                
                  child:  AnimatedContainer(
                    decoration: BoxDecoration(image: DecorationImage(
                      fit: BoxFit.fill,
                      image:NetworkImage('https://images.unsplash.com/photo-1643166406764-569565811559?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw2OXx8fGVufDB8fHx8&auto=format&fit=crop&w=600&q=60' ))),
                    duration:const Duration(seconds: 2),
                    curve: Curves.easeInCubic,
                    height: animate?500 :300,
                    width:animate?360 :200,
                    //color:animate ?Colors.red :Colors.green,
                  ),
                ),

                Opacity(
                  opacity: 0.5,
                  child: Container(height: 150,width: 130,color: Colors.amber,))
                ]
              ),
            ),
          ],
        ),
      ),
    );
  }
}
