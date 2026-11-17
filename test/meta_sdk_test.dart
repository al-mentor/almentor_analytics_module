import 'package:almentor_analytics_module/analytics_sdks/meta/meta_event.dart';
import 'package:almentor_analytics_module/analytics_sdks/meta/meta_sdk.dart';
import 'package:almentor_analytics_module/analytics_sdks/user_data.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const _metaChannel = MethodChannel(channelName);
const _eventMethods = {'logEvent', 'logPurchase'};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  late List<MethodCall> calls;

  List<MethodCall> sentEvents() =>
      calls.where((call) => _eventMethods.contains(call.method)).toList();

  const anonymousUserType = 'Anonymous';

  Future<void> logUserOfType(String userType) => MetaSdk.logUser(
        UserData(
          userId: '42',
          email: 'a@almentor.net',
          phoneNumber: '+201000000000',
          userName: 'Ali',
          userType: userType,
        ),
      );

  Future<void> logPageView([String screen = 'HomeRoute']) =>
      MetaSdk.log(MetaEvent.pageView, parameters: {'screen_name': screen});

  setUp(() {
    calls = [];
    MetaSdk.resetForTesting();
    messenger.setMockMethodCallHandler(_metaChannel, (call) async {
      calls.add(call);
      return null;
    });
  });

  tearDown(() {
    messenger.setMockMethodCallHandler(_metaChannel, null);
  });

  group('gate', () {
    setUp(() => MetaSdk.initMeta(true));

    test('sends nothing outside prod', () async {
      MetaSdk.resetForTesting();
      MetaSdk.initMeta(false);
      await logUserOfType(MetaSdk.consumerUserType);
      await logPageView();

      expect(calls, isEmpty);
    });

    test('sends right away before the user type is known', () async {
      await logPageView();

      expect(sentEvents(), hasLength(1));
    });

    for (final (userType, expectedEvents) in [
      (MetaSdk.consumerUserType, 1),
      (anonymousUserType, 1),
      (MetaSdk.businessUserType, 0),
    ]) {
      test('sends $expectedEvents events for $userType', () async {
        await logUserOfType(userType);

        await logPageView();

        expect(sentEvents(), hasLength(expectedEvents));
      });
    }
  });

  group('payload', () {
    setUp(() => MetaSdk.initMeta(true));

    test('sends a purchase through logPurchase', () async {
      await MetaSdk.log(
        MetaEvent.purchase,
        contentId: 'plan-1',
        contentType: 'annual',
        value: 99.99,
        currency: 'USD',
      );

      final call = sentEvents().single;
      expect(call.method, 'logPurchase');
      expect(call.arguments, {
        'amount': 99.99,
        'currency': 'USD',
        'parameters': {
          FacebookAppEvents.paramNameContentId: 'plan-1',
          FacebookAppEvents.paramNameContentType: 'annual',
        },
      });
    });

    for (final event
        in MetaEvent.values.where((e) => e != MetaEvent.purchase)) {
      test('sends ${event.name} through logEvent as ${event.fbName}', () async {
        await MetaSdk.log(
          event,
          contentId: 'plan-1',
          value: 10,
          currency: 'EGP',
          registrationMethod: 'email',
          parameters: {'screen_name': 'PlansRoute'},
        );

        final call = sentEvents().single;
        expect(call.method, 'logEvent');
        expect(call.arguments, {
          'name': event.fbName,
          '_valueToSum': 10.0,
          'parameters': {
            'screen_name': 'PlansRoute',
            FacebookAppEvents.paramNameContentId: 'plan-1',
            FacebookAppEvents.paramNameRegistrationMethod: 'email',
            FacebookAppEvents.paramNameCurrency: 'EGP',
          },
        });
      });
    }

    for (final (value, currency) in [(null, 'USD'), (9.99, null)]) {
      test('rejects a purchase with value $value and currency $currency',
          () async {
        await expectLater(
          MetaSdk.log(MetaEvent.purchase, value: value, currency: currency),
          throwsArgumentError,
        );
        expect(sentEvents(), isEmpty);
      });
    }
  });

  group('user', () {
    setUp(() => MetaSdk.initMeta(true));

    test('attaches the identity of a consumer', () async {
      await logUserOfType(MetaSdk.consumerUserType);

      expect(calls, [
        isMethodCall('setUserID', arguments: '42'),
        isMethodCall(
          'setUserData',
          arguments: {
            'email': 'a@almentor.net',
            'firstName': 'Ali',
            'phone': '+201000000000',
          },
        ),
      ]);
    });

    for (final userType in [
      anonymousUserType,
      MetaSdk.businessUserType,
    ]) {
      test('attaches no identity for $userType', () async {
        await logUserOfType(userType);

        expect(calls, isEmpty);
      });
    }

    test('reset clears the identity and stops dropping a B2B user events',
        () async {
      await logUserOfType(MetaSdk.businessUserType);

      await MetaSdk.reset();
      await logPageView();

      expect(calls.map((call) => call.method),
          ['clearUserID', 'clearUserData', 'logEvent']);
    });
  });
}
