import 'package:Tocsin/Component/custom_icons.dart';
import 'package:Tocsin/Component/style_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginTextField extends StatelessWidget{
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;

  const LoginTextField({
    Key key,
    this.hintText,
    this.icon = CustomIcons.user,
    this.onChanged,
    this.controller,
  }) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        controller: controller,
        style: TextStyle(fontSize: 14),
        onChanged: onChanged,
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.black26, size: 16,),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.black26),
          border: InputBorder.none,
        ),
      )
    );
  }
}

class PasswordTextField extends StatelessWidget{
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;

  const PasswordTextField({
    Key key,
    this.hintText,
    this.icon = CustomIcons.password,
    this.onChanged,
    this.controller,
  }) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
        child: TextField(
          controller: controller,
          style: TextStyle(fontSize: 14),
          obscureText: true,
          onChanged: onChanged,
          decoration: InputDecoration(
            icon: Icon(icon, color: Colors.black26, size: 18,),
            // suffixIcon: Icon(Icons.visibility, color: Colors.black26,),
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.black26),
            border: InputBorder.none,
          ),
        )
    );
  }
}

class TextFieldContainer extends StatelessWidget{
  final Widget child;
  const TextFieldContainer({
    Key key,
    this.child,
  }) : super(key : key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.only(left: 15, right: 5),
      width: size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: child,
    );
  }
}

class RegisterTextField extends StatelessWidget{
  final String labelText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  final Function validator;
  final Function onSaved;
  final TextInputType inputType;

  const RegisterTextField({
    Key key,
    this.labelText,
    this.icon,
    this.onChanged,
    this.controller,
    this.validator,
    this.onSaved,
    this.inputType = TextInputType.text,
  }) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        style: TextStyle(fontSize: 14),
        onChanged: onChanged,
        validator: validator,
        onSaved: onSaved,
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.black26, size: 16,),
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.black26, fontSize: 14,),
          hintStyle: TextStyle(color: Colors.black26),
          border: UnderlineInputBorder(
              borderSide: new BorderSide(color: Colors.black26)
          ),
          focusedBorder: UnderlineInputBorder(
              borderSide: new BorderSide(color: Colors.primary2)
          ),
        ),
      ),
    );
  }
}

class RegisterPasswordTextField extends StatelessWidget{
  final String labelText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  final Function validator;
  final Function onSaved;

  const RegisterPasswordTextField({
    Key key,
    this.labelText,
    this.icon,
    this.onChanged,
    this.controller,
    this.validator,
    this.onSaved,
  }) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: TextFormField(
        controller: controller,
        style: TextStyle(fontSize: 14),
        onChanged: onChanged,
        obscureText: true,
        validator: validator,
        onSaved: onSaved,
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.black26, size: 16,),
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.black26, fontSize: 14,),
          hintStyle: TextStyle(color: Colors.black26),
          border: UnderlineInputBorder(
              borderSide: new BorderSide(color: Colors.black26)
          ),
          focusedBorder: UnderlineInputBorder(
              borderSide: new BorderSide(color: Colors.primary2)
          ),
          focusColor: Colors.primary2
        ),
      ),
    );
  }
}

class NormalTextField extends StatelessWidget{
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  final TextInputType inputType;

  const NormalTextField({
    Key key,
    this.hintText,
    this.icon,
    this.onChanged,
    this.controller,
    this.inputType = TextInputType.text,
  }) : super(key : key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(bottom: size.height*0.025),
      child: TextField(
        keyboardType: inputType,
        controller: controller,
        style: TextStyle(fontSize: 14),
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.black26),
          border: UnderlineInputBorder(
              borderSide: new BorderSide(color: Colors.secondary)
          ),
          focusedBorder: UnderlineInputBorder(
              borderSide: new BorderSide(color: Colors.primary2)
          ),
        ),
      ),
    );
  }
}

class TextFieldWithSuffix extends StatelessWidget{
  final String hintText;
  final String suffText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  final TextInputType inputType;

  const TextFieldWithSuffix({
    Key key,
    this.hintText,
    this.icon,
    this.onChanged,
    this.controller,
    this.suffText,
    this.inputType = TextInputType.text,
  }) : super(key : key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(bottom: size.height*0.025),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: inputType,
              style: TextStyle(fontSize: 14),
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.black26),
                border: UnderlineInputBorder(
                    borderSide: new BorderSide(color: Colors.secondary)
                ),
                focusedBorder: UnderlineInputBorder(
                    borderSide: new BorderSide(color: Colors.primary2)
                ),
              ),
            ),
          ),
          // SizedBox(width: size.width*0.02,),
          TextSecondaryNormal(text: suffText),
        ],
      )
    );
  }
}


class SearchTextField extends StatelessWidget{
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  final Function onTap;
  final Function onSubmitted;
  final Function onPressSuff;

  const SearchTextField({
    Key key,
    this.hintText,
    this.icon,
    this.onChanged,
    this.controller,
    this.onTap,
    this.onSubmitted,
    this.onPressSuff,
  }) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
        child: TextField(
          controller: controller,
          style: TextStyle(fontSize: 14),
          onChanged: onChanged,
          decoration: InputDecoration(
            icon: Icon(icon, color: Colors.secondary, size: 20,),
            // suffixIcon: IconButton(
            //   icon: Icon(Icons.search, color: Colors.primary,),
            //   onPressed: onPressSuff,
            // ),
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.black26),
            border: InputBorder.none,
          ),
          onTap: onTap,
          textInputAction: TextInputAction.go,
          onSubmitted: onSubmitted,
        )
    );
  }
}