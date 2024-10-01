import 'dart:io';

class UserData {
  final String userId;
  final String? userName;
  final String? phoneNumber;
  final String? email;
  final String? gender;
  final String? firstSubscriptionDate;
  final String? signUpDate;
  final bool? isSubscribed;
  final String? language;
  final String? userType;
  final String? subscriptionType;

  UserData({
    required this.userId,
    this.userName,
    this.phoneNumber,
    this.email,
    this.gender,
    this.firstSubscriptionDate,
    this.signUpDate,
    this.isSubscribed,
    this.language,
    this.userType,
    this.subscriptionType,
  });

  Map<String, dynamic> toJson() =>
      {
        'user_id': userId,
        if (userName != null) 'user_name': userName,
        if (phoneNumber != null) 'phone_number': phoneNumber,
        if (email != null) 'email': email,
        if (gender != null) 'gender': gender,
        if (firstSubscriptionDate != null)
          'first_subscription_date': firstSubscriptionDate,
        if (language != null) 'language': language,
        if (userType != null) 'user_type': userType,
        if (signUpDate != null) 'sign_up_date': signUpDate,
        if (subscriptionType != null) 'subscription_type': subscriptionType,
        "platform": Platform.isAndroid ? "Android" : "Ios"
      };
}
