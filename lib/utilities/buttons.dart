import 'package:flutter/material.dart';

import '../constants/color_constant.dart';
import '../constants/sizeConstant.dart';

Widget getButton({
  String? title,
  double? height,
  double? width,
  Color? backColor,
  double? textSize,
  Color? textColor,
  Color? borderColor,
  FontWeight? fontWeight,
  double? borderRadius,
  Widget? widget,
  GestureTapCallback? onTap,
}) {
  return GestureDetector(
    onTap: onTap ?? () {},
    child: Container(
      height: MySize.getHeight(height ?? 47),
      width: MySize.getWidth(width ?? 150),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backColor ?? appTheme.primaryDarkTheme,
        border: Border.all(color: borderColor ?? Colors.transparent),
        borderRadius:
            BorderRadius.circular(MySize.getHeight(borderRadius ?? 5)),
      ),
      child: (!isNullEmptyOrFalse(widget))
          ? widget
          : Text(
              title ?? "",
              style: TextStyle(
                  color: textColor ?? Colors.white,
                  fontSize: MySize.getHeight(textSize ?? 17),
                  fontWeight: fontWeight ?? FontWeight.w500),
            ),
    ),
  );
}

String? validateEmail(String? value) {
  String pattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?)*$";
  RegExp regex = RegExp(pattern);
  if (value == null || value.isEmpty || !regex.hasMatch(value))
    return 'Enter a valid email address';
  else
    return null;
}

showConfirmationDialog(
    {required BuildContext context,
    required String text,
    required String cancelText,
    required String submitText,
    required Function() cancelCallback,
    required Function() submitCallBack}) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(text),
                Spacing.height(25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: cancelCallback,
                      child: getButton(
                        title: cancelText,
                        height: 40,
                        width: 100,
                        textSize: 14,
                        textColor: Colors.white,
                      ),
                    ),
                    Spacing.width(20),
                    InkWell(
                      onTap: submitCallBack,
                      child: getButton(
                        title: submitText,
                        height: 40,
                        width: 100,
                        textSize: 14,
                        textColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      });
}
