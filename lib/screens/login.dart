import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta/helpers/firebasequeries.dart';
import 'package:insta/helpers/utils.dart';
import 'package:insta/providers/userdata.dart';
import 'package:insta/responsive/res_layout.dart';
import 'package:insta/screens/signup.dart';
import 'package:insta/utility/colors.dart';
import 'package:insta/widgets/input.dart';

class Login extends StatefulWidget {
  
  static String routename='/login';

  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

bool  _isloading=false;

final TextEditingController email=TextEditingController();

final TextEditingController password=TextEditingController();

@override
  void dispose() {
   
    super.dispose();

email.dispose();
password.dispose();


  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery.of(context).size.height;
      final width=MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(flex: 1, child: Container()),

          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            child:SvgPicture.asset('instaimg.svg',color: MyColors.primaryColor,height: 65,),
          ),
           // child: Image.asset('icon.png',height: 100,width: 150,)),
            Container(
               width: MediaQuery.of(context).size.width*0.75,
                child: Input(
                  controller: email,
                  hinttext: 'Email',
                  labeltext: 'Enter Your Email',
                  inputType:TextInputType.emailAddress,
                  ispas: false,
                
                )),
            SizedBox(
              height: 30,
            ),
            Container(
                width: MediaQuery.of(context).size.width*0.75,
                child: Input(
                  controller: password,
                hinttext: '',
                  labeltext: 'Enter Your Password',
                  inputType:TextInputType.visiblePassword,
                  ispas: true,
                
                )),
                
            InkWell(
              

              onTap: () async{
             
             setState(() {
              _isloading=true;
             });
          
          String res=  await UserAuth().signin(email: email.text, password: password.text);
          

          setState(() {
           
            _isloading=false;
          });
          if(res=='y')
          {
            print('login');
            Navigator.of(context).pushReplacementNamed(ResLayout.routename);
          }
          else
          {
            showSnackbar(context, res);
          }
          
              },
              
              child: Container(

                width:  MediaQuery.of(context).size.width*0.75,
                alignment: Alignment.center,
                color: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                
                margin: const EdgeInsets.symmetric(vertical: 15),
                child:_isloading ? const Center(child: CircularProgressIndicator(color: Colors.red,) ,)
                :const Text('Login'),
              ),
            ),
   Expanded(flex: 2, child: Container()),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
             
              children: [
                Container(child: const Text("Don't have an account"),
                padding:const  EdgeInsets.symmetric(vertical: 10),
                ),
                const SizedBox(width: 15,),
                InkWell(
                  onTap: (){
                    Navigator.of(context).pushReplacementNamed(Signup.routename);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric( vertical:10),
                    child: const Text('Sign Up',style: TextStyle(fontWeight: FontWeight.bold),)),
                )
              ],
            ),

          ],


        ),
      ),
    );
  }
}
