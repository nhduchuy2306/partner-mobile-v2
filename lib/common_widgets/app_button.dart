import 'package:flutter/material.dart';
import 'package:partner_mobile/styles/app_colors.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final double roundness;
  final double thickness;
  final FontWeight fontWeight;
  final EdgeInsets padding;
  final Function? onTap;
  final Color borderColor;
  final Color? textColor;
  final double fontSize;
  final double left;
  final double right;
  final double top;
  final double bottom;

  const ButtonWidget({
    super.key,
    required this.text,
    required this.roundness,
    required this.fontWeight,
    required this.padding,
    required this.fontSize,
    required this.thickness,
    this.onTap,
    this.borderColor = AppColors.primaryColor,
    this.textColor,
    this.left = 20,
    this.right = 20,
    this.top = 5,
    this.bottom = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(left: left, right: right, top: top, bottom: bottom),
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor,
          width: thickness,
        ),
        borderRadius: BorderRadius.circular(roundness),
      ),
      child: GestureDetector(
        onTap: onTap as void Function()?,
        child: Text(
          text,
          style: TextStyle(
            color: textColor == null ? Colors.black : textColor!,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        ),
      ),
    );
  }
}
