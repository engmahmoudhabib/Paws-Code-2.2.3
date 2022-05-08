import 'package:flutter/material.dart';
import 'package:flutter_app/config/AppComponent.dart';
import 'package:get_storage/get_storage.dart';
import 'package:easy_localization/easy_localization.dart';

class AppFactory {
  static Map<String, Map<String, String>> dictionary = Map();

  static getLabel(label, defaultValue,{String type=''}) {
    return defaultValue;
     var t=tr(label);
    return label==t?defaultValue:t;
    // return dictionary[label]![GetStorage().read('lang')] ?? defaultValue;
  }

  static Map<String, Color> colors = {
    'background': Color(0xffffffff),
    'on_primary': Color(0xffffffff),
    'primary': Color(0xFF3876BA),
    'gray': Color(0xffC4C4C4),
    'primary_1': Color(0xFF77ADE8),

    'gray_1': Color(0xff707070),
    'orange': Color(0xffFECA2E),

  };

  static Color getColor(String key,String widget) {
    return colors[key] ?? Color(0xffffffff);
  }

  static double getDimensions(double value,String widget) {

    return value;
  }

  static double getFontSize(double value,String widget) {
    return value;
  }

  static supportedLang(String lang) {
    return getSupportedLang().contains(lang);
  }

  static List getSupportedLang() {
    return ['ar', 'en'];
  }

  static checkLabel(label) {
    if (dictionary[label] == null) {
      dictionary[label] = Map();
    }
  }



}
