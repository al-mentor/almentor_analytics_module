import 'dart:io';

class AppsFlyerConstant{
  AppsFlyerConstant._();

  static const appsFlyerDevKey = "ACkLnTStjHcRzwiE3LpyN5";
  static const appIDAndroid = "com.almentor.app";
  static const appStageIDAndroid = "com.almentor.app.preprod";
  static const appIDiOS = "1645104637";
  static const appIDStageiOS = "6476145000";

  static String getAppID() => Platform.isAndroid ? appIDAndroid : appIDiOS;


  static String getAppStageID() => Platform.isAndroid ? appStageIDAndroid : appIDStageiOS;

}