import 'package:almentor_analytics_module/analytics_sdks/apps_flyer/apps_flyer_sdk.dart';
import 'package:almentor_analytics_module/analytics_sdks/user_data.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// The AppsFlyer plugin's method channel. Every native call the SDK makes goes
/// through it, so recording it is enough to assert what we hand to the platform.
const _afChannel = MethodChannel('af-api');

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late List<MethodCall> calls;

  /// Arguments of every `setUserEmails` call recorded so far.
  List<dynamic> emailArgs() => calls
      .where((call) => call.method == 'setUserEmails')
      .map((call) => call.arguments['emails'])
      .toList();

  setUp(() async {
    calls = [];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_afChannel, (call) async {
      calls.add(call);
      return null;
    });
    await AppsFlyerSDK.initAppsFlyer(true);
    // initSdk defers its channel call by one event-loop turn.
    await Future<void>.delayed(Duration.zero);
    calls.clear();
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_afChannel, null);
  });

  group('rest', () {
    // Regression: FLUTTER-ZF-1CD. The AppsFlyer Android SDK builds its emails
    // JSONObject with a key that is only assigned inside the loop over the
    // emails array, so an empty array leaves the key null and
    // `new JSONObject(map)` throws `NullPointerException: key == null`.
    test('never sends an empty email list to the platform', () {
      AppsFlyerSDK.rest();

      expect(emailArgs(), isNot(contains(isEmpty)));
    });

    test('still clears the customer user id and the additional data', () {
      AppsFlyerSDK.rest();

      expect(calls.map((call) => call.method), [
        'setCustomerUserId',
        'setAdditionalData',
      ]);
    });
  });

  group('logUser', () {
    test('sends the email when the user has one', () {
      AppsFlyerSDK.logUser(UserData(userId: '42', email: 'a@almentor.net'));

      expect(emailArgs(), [
        ['a@almentor.net'],
      ]);
    });

    test('sends no email call when the user has none', () {
      AppsFlyerSDK.logUser(UserData(userId: '42'));

      expect(emailArgs(), isEmpty);
    });
  });
}
