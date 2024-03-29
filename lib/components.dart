import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:signature/constants.dart';

Widget defaultTextFormField(
    context,
    {
      String? labelText,
      String? hintText,
      TextInputType? keyboardType,
      Widget? prefixIcon,
      Widget? suffixIcon,
      bool noBorder = false,
      Color? backgroundColor,
      TextEditingController? controller,
      Function(String)? onChanged,
    }) =>
    Container(
      decoration: backgroundColor != null? BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
      ) : null,
      child: TextFormField(
        decoration: InputDecoration(
          focusedBorder: noBorder == false? OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: secondaryColor)) : null,
          enabledBorder: noBorder == false? OutlineInputBorder(borderRadius: BorderRadius.circular(20)): null,
          border: InputBorder.none,
          labelStyle: const TextStyle(
            color: Colors.black54
          ),
          labelText: labelText,
          hintText: hintText,
          prefixIcon: prefixIcon?? prefixIcon,
          suffixIcon: suffixIcon?? suffixIcon,
        ),
        keyboardType: keyboardType,
        controller: controller,
        onChanged: onChanged,
        onTapOutside: (event) {
          // to dismiss keyboard on tapping out of the TFF
          FocusManager.instance.primaryFocus?.unfocus();
        },
      ),
    );

Widget defaultButton({
  double height = 60.0,
  double width = double.infinity,
  String? text,
  Color textColor = Colors.white,
  bool isBold = false,
  double fontSize = 18.0,
  required Function() onPress,
  Widget? child,
  List<Color> gradientColors = const [secondaryColor, primaryColor],
}) =>
    Container(
      height: height,
      width: width,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          transform: const GradientRotation(45),
          colors: gradientColors,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(10.0),
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0.0, 0.75),
          ),
        ],
      ),
      child: MaterialButton(
        onPressed: onPress,
        child: child ??
            Text(
              text ?? "",
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: textColor,
                fontSize: fontSize,
              ),
            ),
      ),
    );


/// Show Toast
void showToast({
  required String message,
  required Color toastColor,
  Color textColor = Colors.white,
  double fontSize = 16.0,
}) =>
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: toastColor,
      textColor: textColor,
      fontSize: fontSize,
    );