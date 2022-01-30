import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta/helpers/firebasequeries.dart';
import 'package:insta/helpers/utils.dart';
import 'package:insta/models/user.dart';
import 'package:insta/providers/userdata.dart';
import 'package:insta/responsive/res_layout.dart';
import 'package:insta/screens/login.dart';
import 'package:insta/utility/colors.dart';
import 'package:insta/widgets/input.dart';

class Signup extends StatefulWidget {
  static String routename = '/signup';

  Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {

   bool isloading =  false;
  final TextEditingController email = TextEditingController();

  final TextEditingController password = TextEditingController();

  final TextEditingController name = TextEditingController();
  
  final TextEditingController username = TextEditingController();

  Uint8List? _image;

  @override
  void dispose() {
    super.dispose();

    email.dispose();
    password.dispose();
    username.dispose();
    name.dispose();
  }

  @override
  Widget build(BuildContext context) {
      final width=MediaQuery.of(context).size.width;
 

    // MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(flex: 1, child: Container()),

            Stack(
              children: [
                _image != null
                    ? CircleAvatar(
                        radius: 64, backgroundImage: MemoryImage(_image!))
                    : const CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(
                            'https://images.unsplash.com/photo-1643216583837-f6d664d48eac?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80'),
                      ),
                Positioned(
                    bottom: -7,
                    right: 3,
                    child: IconButton(
                      icon: Icon(Icons.add_a_photo),
                      color: Colors.blue,
                      onPressed: () async {
                        final Uint8List img =
                            await pickImage(ImageSource.gallery);

                        setState(() {
                          _image = img;
                        });
                      },
                    ))
              ],
              overflow: Overflow.visible,
            ),

            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: SvgPicture.asset(
                'instaimg.svg',
                color: MyColors.primaryColor,
                height: 65,
              ),
            ),
            // child: Image.asset('icon.png',height: 100,width: 150,)),
            Container(
                width: MediaQuery.of(context).size.width * 0.75,
                child: Input(
                  controller: name,
                  hinttext: 'Name',
                  labeltext: 'Enter Your Name',
                  inputType: TextInputType.name,
                  ispas: false,
                )),
            const SizedBox(
              height: 20,
            ),
            Container(
                width: MediaQuery.of(context).size.width * 0.75,
                child: Input(
                  controller: username,
                  hinttext: 'Username',
                  labeltext: 'Enter Your  Username',
                  inputType: TextInputType.text,
                  ispas: false,
                )),
            const SizedBox(
              height: 20,
            ),
            Container(
                width: MediaQuery.of(context).size.width * 0.75,
                child: Input(
                  controller: email,
                  hinttext: 'Email',
                  labeltext: 'Enter Your Email',
                  inputType: TextInputType.emailAddress,
                  ispas: false,
                )),
            const SizedBox(
              height: 20,
            ),
            Container(
                width: MediaQuery.of(context).size.width * 0.75,
                child: Input(
                  controller: password,
                  hinttext: '',
                  labeltext: 'Enter Your Password',
                  inputType: TextInputType.visiblePassword,
                  ispas: true,
                )),

            InkWell(
              onTap: () async {

                if(_image==null)
                {
                  showSnackbar(context, 'Please select a profile image');
                  return;
                }
                setState(() {
                  print('setting it true');
                  isloading = true;
                });


                  UserModel user=UserModel(  email: email.text,
                  bio: name.text,
                  password: password.text,
             
                  username: username.text,);

                  user.profilepic=_image!;

                final String res = await UserAuth().signup(user);
                  setState(() {
                    print('false');
                 isloading = false;
                });

                

                if (res == 'y') {
                  print('success');
                   Navigator.of(context).pushReplacementNamed(ResLayout.routename);
                } else {
                  showSnackbar(context, res);
                }
              
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.75,
                alignment: Alignment.center,
                color: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 10),
                margin: const EdgeInsets.symmetric(vertical: 15),
                child: isloading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'Signup',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
              ),
            ),
            Expanded(flex: 2, child: Container()),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: const Text("Already have an account"),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                const SizedBox(
                  width: 15,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed(Login.routename);
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: const Text(
                        'Signin',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
