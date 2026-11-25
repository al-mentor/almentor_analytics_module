import 'package:almentor_analytics_module/almentor_analytics_module.dart';
import 'package:almentor_analytics_module/analytics_sdks/mixpanel/mixpanel_sdk.dart';
import 'package:almentor_analytics_module/analytics_sdks/user_data.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mixpanel_flutter/codec/mixpanel_message_codec.dart';

const _mixpanelChannel = MethodChannel(
  'mixpanel_flutter',
  StandardMethodCodec(MixpanelMessageCodec()),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  const anonymousId = r'$device:anonymous';
  const userId = 'user-1';

  late List<MethodCall> calls;
  late String distinctId;
  late String? failingMethod;

  List<Object?> identifiedIds() => calls
      .where((call) => call.method == 'identify')
      .map((call) => (call.arguments as Map)['distinctId'])
      .toList();

  setUp(() async {
    calls = [];
    distinctId = anonymousId;
    failingMethod = null;
    messenger.setMockMethodCallHandler(_mixpanelChannel, (call) async {
      calls.add(call);
      if (call.method == failingMethod) {
        throw PlatformException(code: 'failed');
      }
      return call.method == 'getDistinctId' ? distinctId : null;
    });
    await MixPanelSdk.initMixpanelSdk(false);
    calls.clear();
  });

  tearDown(() {
    messenger.setMockMethodCallHandler(_mixpanelChannel, null);
  });

  group('identifyMixpanelUser', () {
    late List<Object> errors;
    final originalOnError = AlmentorAnalyticsModule.onError;

    setUp(() {
      errors = [];
      AlmentorAnalyticsModule.onError = (error, _) => errors.add(error);
    });

    tearDown(() => AlmentorAnalyticsModule.onError = originalOnError);

    test('links an anonymous device without sending user properties',
        () async {
      await AlmentorAnalyticsModule.instance.identifyMixpanelUser(userId);

      expect(identifiedIds(), [userId]);
      expect(
        calls.map((call) => call.method),
        isNot(contains('registerSuperProperties')),
      );
      expect(errors, isEmpty);
    });

    test('does nothing when the device already has the ID', () async {
      distinctId = userId;

      await AlmentorAnalyticsModule.instance.identifyMixpanelUser(userId);

      expect(identifiedIds(), isEmpty);
    });

    for (final method in ['getDistinctId', 'identify']) {
      test('reports a failed $method to onError', () async {
        failingMethod = method;

        await AlmentorAnalyticsModule.instance.identifyMixpanelUser(userId);

        expect(errors, [isA<PlatformException>()]);
      });
    }
  });

  group('logUser', () {
    test('registers the user properties and identifies the user', () async {
      await MixPanelSdk.logUser(UserData(userId: userId));

      expect(
        calls.map((call) => call.method),
        contains('registerSuperProperties'),
      );
      expect(identifiedIds(), [userId]);
    });

    test('does not identify a user without an ID', () async {
      await MixPanelSdk.logUser(UserData(userType: 'Anonymous'));

      expect(identifiedIds(), isEmpty);
    });

    test('throws to its caller when identify fails', () async {
      failingMethod = 'identify';

      await expectLater(
        MixPanelSdk.logUser(UserData(userId: userId)),
        throwsA(isA<PlatformException>()),
      );
    });
  });
}
