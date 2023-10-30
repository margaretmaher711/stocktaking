import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  String labelTxt, hintTxt;
  // TextInputType txtInputType;
  TextEditingController textController;
  final String? Function(String?)? validator;
  final String? Function(String?)? onFieldSubmitted;
  // final int? maxLength;
  // final bool? enabled;
  // bool float;
  bool onError = false;
  // TextDirection hintTxtDirc;

  CustomTextField(
      {Key? key,
        required this.labelTxt,
        required this.hintTxt,
        required this.textController,
        // required this.txtInputType,
        // required this.maxLength,
        // required this.enabled,
        required this.validator,
        required this.onFieldSubmitted,
        // required this.hintTxtDirc,
        // this.float = true
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 6),
        child: TextFormField(
            cursorColor: const Color(0xff03314B),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
            controller: textController,
            textDirection: TextDirection.ltr,onFieldSubmitted:onFieldSubmitted ,
            // keyboardType: txtInputType,
            // maxLength: maxLength,
            // enabled: enabled,
            scrollPadding: const EdgeInsets.symmetric(vertical: 40),
            decoration: InputDecoration(
                alignLabelWithHint: true,
                counterText: "",
                fillColor: Colors.transparent,
                filled: true,
                contentPadding: const EdgeInsets.fromLTRB(8, 30, 10, 5),
                labelText: labelTxt,
                labelStyle: const TextStyle(
                    fontFamily: 'Cairo-Light',
                    color: Color(0xffECA400),
                    fontSize: 18,
                    fontWeight: FontWeight.w400),
                hintText: hintTxt,
                // hintTextDirection: hintTxtDirc,
                // floatingLabelBehavior: float == true
                //     ? FloatingLabelBehavior.always
                //     : FloatingLabelBehavior.never,
                hintStyle: const TextStyle(
                    fontFamily: 'Cairo-Light',
                    color: Color(0xff03314B),
                    fontSize: 18,
                    fontWeight: FontWeight.w400),
                border: myInputBorder(),
                focusedBorder: myFocusBorder()),
            validator: validator
          //     (String? val) {
          //   if (val!.isEmpty) {
          //     return validator;
          //   }
          //   return null;
          // },
        ));
  }

  OutlineInputBorder myInputBorder() {
    return const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        borderSide: BorderSide(
          color: Color(0xff006992),
          width: 1,
        ));
  }

  OutlineInputBorder myFocusBorder() {
    return const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        borderSide: BorderSide(
          color: Color(0xff006992),
          width: 2,
        ));
  }
}
