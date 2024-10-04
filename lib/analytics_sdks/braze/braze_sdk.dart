import 'package:almentor_analytics_module/analytics_sdks/user_data.dart';
import 'package:almentor_analytics_module/event_name_mapper.dart';
import 'package:almentor_analytics_module/events_name.dart';
import 'package:braze_plugin/braze_plugin.dart';

class BrazeSdk {
  const BrazeSdk._();
  static BrazePlugin? _braze;

  static BrazePlugin? get braze => _braze;

  static void initBraze() {
    _braze = BrazePlugin();
    _braze!.enableSDK();
  }

  static void logUser(UserData userData) {
    if(_braze == null){
      initBraze();
    }
    if (userData.userId.isEmpty) {
      return;
    }
    _braze!.changeUser(userData.userId);
    if (userData.userName != null) {
      _braze!.setFirstName(userData.userName!);
    }
    if (userData.phoneNumber != null) {
      _braze!.setPhoneNumber(userData.phoneNumber!);
    }
    if (userData.email != null) {
      _braze!.setEmail(userData.email!);
    }
    if (userData.language != null) {
      _braze!.setLanguage(userData.language!);
    }
    if (userData.isSubscribed != null) {
      _braze!.setStringCustomUserAttribute(
        'is_subscribed',
        userData.isSubscribed! ? 'Yes' : 'No',
      );
    }
    if (userData.userType != null) {
      _braze!.setStringCustomUserAttribute(
        'user_type',
        userData.userType ?? "",
      );
    }
    if (userData.firstSubscriptionDate != null) {
      _braze!.setStringCustomUserAttribute(
        'first_subscription_date',
        userData.firstSubscriptionDate!,
      );
    }
    if (userData.signUpDate != null) {
      _braze!.setStringCustomUserAttribute(
        'sign_up_date',
        userData.signUpDate!,
      );
    }
  }

  static void  reset() {


  }

  static void logBrazeEvent(
    EventName eventName,
    dynamic eventValue,
  ) async {
    braze!.logCustomEvent(
      eventName.convertToSnakeCase,
      properties: eventValue,
    );
  }
}
