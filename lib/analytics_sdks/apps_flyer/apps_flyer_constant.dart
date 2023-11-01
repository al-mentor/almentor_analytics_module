import 'dart:io';

class AppsFlyerConstant{
  AppsFlyerConstant._();

  static const appsFlyerDevKey = "ACkLnTStjHcRzwiE3LpyN5";
  static const appIDAndroid = "com.almentor.app";
  static const appIDiOS = "1645104637";

  static String getAppID() => Platform.isAndroid ? appIDAndroid : appIDiOS;

}