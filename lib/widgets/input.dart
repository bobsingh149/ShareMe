import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  
  final bool ispas;
  final TextInputType inputType;
  final String labeltext;
  final String hinttext;
   TextEditingController controller=TextEditingController();
    Input({ Key? key,required this.controller, this.ispas=false,required this.inputType,required this.labeltext,required this.hinttext }) : super(key: key);

 
  

  @override
  Widget build(BuildContext context) {
    final inputborder=OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return TextField(
controller: controller,
keyboardType:inputType,
obscureText: ispas,
      decoration: InputDecoration(
        labelText: labeltext,
        hintText: hinttext,
        border: inputborder,
        focusedBorder: inputborder,
        enabledBorder: inputborder,
        filled: true,
        contentPadding: const EdgeInsets.all(9)

      ),
      
    );
  }
}