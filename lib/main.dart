import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:insta/providers/userdata.dart';
import 'package:insta/responsive/mobile.dart';
import 'package:insta/responsive/res_layout.dart';
import 'package:insta/responsive/web.dart';
import 'package:insta/screens/comments.dart';
import 'package:insta/screens/login.dart';
import 'package:insta/screens/signup.dart';
import 'package:insta/screens/test.dart';
import 'package:insta/utility/colors.dart';
import 'package:provider/provider.dart';
//flutter run -d chrome --web-renderer html
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    var data = await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyC9fQ9YDRwa-gFhqB4dsexcP8I2Y5EGl1Q",
           
            projectId: "instagram-4d9db",
            storageBucket: "instagram-4d9db.appspot.com",
            messagingSenderId: "40593484616",
            appId: "1:40593484616:web:cacb6a38faeaef621fa17d"));

    print(data);
  } else {
    await Firebase.initializeApp();
  }

  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
       ChangeNotifierProvider(create: (_)=>UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Insta',
        theme: ThemeData.dark().copyWith(
          primaryColor: MyColors.primaryColor,
          scaffoldBackgroundColor: MyColors.webBackgroundColor,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
             if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(),);
            }
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {

         
                return
                const ResLayout(
                  web: Web(),
                
                  mobile: Mobile(),
                );
              }
    
              else if(snapshot.hasError)
              {
                return const Center(child: Text('Error'),);
              }
            }
    
           
    
             return   Login();
          },
        ),
    
        // theme: ThemeData(
        //   primaryColor: Colors.green,
        //   brightness: Brightness.dark,
        //   scaffoldBackgroundColor: Colors.grey,
        //   textTheme:TextTheme(bodyText1: TextStyle(fontSize: 15)) ),
    
        routes: {
          Login.routename: (ctx) => Login(),
          Signup.routename: (ctx) => Signup(),
          ResLayout.routename:(ctx)=>const ResLayout(web: Web(),mobile: Mobile(),),
          CommentScreen.routename:(ctx)=> CommentScreen()
        },
    
        // home: const ResLayout(
        //       web: Web(),
        //       mobile: Mobile(),
        //     ),
      ),
    );
  }
}
