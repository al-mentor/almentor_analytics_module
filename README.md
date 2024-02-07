## Getting Started

Streamline analytics integration in your Flutter app effortlessly!The
`almentor_analytics_module` package provides a hassle-free way to seamlessly
integrate popular analytics SDKs like Firebase, AppsFlyer, Mixpanel and SmartLock.
Harness the power of data-driven insights without the complexity. Analyze,
optimize, and grow your app with ease.

### Prerequisites

**Create a Firebase Project:**

- Firebase Analytics is currently the primary analytics SDK supported by our package.
- You need to have a Firebase project created on
  the [Firebase Console](https://console.firebase.google.com/). This project will be used for
  configuration.

- Flutter installed on your machine

### Installation

To use this package, follow these steps:

- Open your Flutter project.
- Edit the `pubspec.yaml` file and add the following dependency:

```yaml
   dependencies:
     almentor_analytics_module:
       git:
         url: https://github.com/al-mentor/almentor_analytics_module.git
```

- Initialize `AlmentorAnalyticsModule` by adding the following line at your `main.dart` file
  under `WidgetsFlutterBinding.ensureInitialized()` line:

```sh
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AlmentorAnalyticsModule.instance.init();
}
```

------

### `submitEvent` Function

The `submitEvent` function allows you to submit events with different SDKs in your Flutter
application. You can control which SDKs are used for tracking events by enabling or disabling them.
This provides flexibility and customization for your event tracking needs.

#### Parameters:

- `eventName` (required): Specifies the event name you want to track.

- `eventValue`: An optional parameter that allows you to attach additional data to the event.

- `allowFirebaseEvents` (default: `true`): Controls whether Firebase Analytics events are allowed.
  Set to `true` to enable Firebase Analytics event tracking or `false` to disable it.

- `allowAppsFlyerEvent` (default: `false`): Controls whether AppsFlyer events are allowed. Set
  to `true` to enable AppsFlyer event tracking or `false` to disable it. This feature is dependent
  on the presence of the AppsFlyer SDK in your project.

- `allowMixpanelEvent` (default: `false`): Controls whether Mixpanel events are allowed. Set
  to `true` to enable Mixpanel event tracking or `false` to disable it. This feature is dependent on
  the presence of the Mixpanel SDK in your project.

- `allowBrazeEvent` (default: `false`): Controls whether Braze events are allowed. Set
  to `true` to enable Braze event tracking or `false` to disable it. This feature is dependent on
  the presence of the Braze SDK in your project.

#### Usage:

- Import the package in your dart file where you want to use it by adding the following line at the
  top of the file:

```sh
import 'package:almentor_analytics_module/almentor_analytics_module.dart';
import 'package:almentor_analytics_module/events_name.dart';
```

- To track an event, call the `submitEvent` function with the desired parameters. For example:

```sh
AlmentorAnalyticsModule.instance.submitEvent(eventName: EventName.loginPageLoadedEvent);
```

- To submit a new event with paramters value

```sh
AlmentorAnalyticsModule.instance.submitEvent(
      eventName: EventName.loginPageLoadedEvent,
      eventValue: {
        'param1': 'value1',
        'param2': 'value2',
      },
    );
```

- Allow all integrated SDKs to track an event

```sh
submitEvent(
  eventName: EventName.myEvent,
  eventValue: {
    'key': 'value',
  },
  allowFirebaseEvents: true,
  allowAppsFlyerEvent: true,
  allowMixpanelEvent: true,
);
```

In this example, the `myEvent` event will be tracked using Firebase Analytics, AppsFlyer, and
Mixpanel, as all three SDKs are enabled. You can customize which SDKs track the event by adjusting
the `allowFirebaseEvents`, `allowAppsFlyerEvent`, and `allowMixpanelEvent` parameters.

This function provides you with the flexibility to selectively use different analytics and tracking
tools based on your project requirements.

**Important Note:**
At the moment, our Flutter analytics package exclusively integrates with Firebase Analytics,
AppsFlyer and Mixpanel. We're committed to providing you with a comprehensive analytics solution,
and we have plans to include support for additional analytics like SmartLock, in future updates.
