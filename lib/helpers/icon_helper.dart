import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IconHelper {
  int? id;
  String? level;
  IconData? iconData;

  IconHelper({this.id, this.level, this.iconData});
}

class IconEnum {
  static const IconData Bronze = FontAwesomeIcons.star;
  static const IconData Silver = FontAwesomeIcons.medal;
  static const IconData Gold = FontAwesomeIcons.trophy;
  static const IconData Platinum = FontAwesomeIcons.coins;
}