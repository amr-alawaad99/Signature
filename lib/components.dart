import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:signature/constants.dart';

class CustomInputField extends StatefulWidget {
  final String hintText;
  final String? labelText;
  final bool suffixIcon;
  final bool? isDense;
  final bool obscureText;
  final bool filled;
  final bool haveBorder;
  final bool prefixIcon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool enabled;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;

  const CustomInputField({
    super.key,
    required this.hintText,
    this.labelText,
    this.suffixIcon = false,
    this.isDense,
    this.obscureText = false,
    this.validator,
    this.controller,
    this.filled = false,
    this.haveBorder = false,
    this.prefixIcon = false,
    this.enabled = true,
    this.onChanged,
    this.onFieldSubmitted,
    this.textInputAction,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: (widget.labelText != null)
                ? Text(
              widget.labelText!,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            )
                : null,
          ),
          TextFormField(
            obscureText: (widget.obscureText && _obscureText),
            enabled: widget.enabled,
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onFieldSubmitted,
            textInputAction: widget.textInputAction,
            decoration: InputDecoration(
              filled: widget.filled,
              border: widget.haveBorder
                  ? OutlineInputBorder(borderRadius: BorderRadius.circular(10),)
                  : null,
              fillColor: Colors.white,
              isDense: (widget.isDense != null) ? widget.isDense : false,
              hintText: widget.hintText,
              suffixIcon: widget.suffixIcon
                  ? IconButton(
                icon: Icon(
                  _obscureText
                      ? Icons.remove_red_eye
                      : Icons.visibility_off_outlined,
                  color: Colors.black54,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
                  : null,
              suffixIconConstraints: (widget.isDense != null)
                  ? const BoxConstraints(maxHeight: 33)
                  : null,
              prefixIcon: widget.prefixIcon ? const Icon(Icons.search) : null,
            ),
            validator: widget.validator,
            controller: widget.controller,
          ),
        ],
      ),
    );
  }
}


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