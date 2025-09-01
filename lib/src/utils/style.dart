import 'package:flutter/material.dart';

class Style {
  final Color? primaryColor,
      appBarBackgroundColor,
      appBarForegroundColor,
      grey2,
      grey1,
      userChatBubbleColor,
      scaffoldColor,
      circleProgressColor;
  final TextStyle? textStyle;

  Style({
    this.circleProgressColor = Colors.blue,
    this.primaryColor = const Color(0xff113D64),
    this.appBarBackgroundColor = Colors.blue,
    this.appBarForegroundColor = const Color(0xff13828E),
    this.userChatBubbleColor = Colors.grey,
    this.grey1 = const Color(0xffd0d9e5),
    this.grey2 = const Color(0xff929898),
    this.scaffoldColor = Colors.white,
    this.textStyle,
  });
}
