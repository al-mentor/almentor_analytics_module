## Getting Started

Streamline analytics integration in your Flutter app effortlessly!The
`almentor_analytics_module` package provides a hassle-free way to seamlessly
integrate popular analytics SDKs like Firebase, AppsFlyer, and SmartLock.
Harness the power of data-driven insights without the complexity. Analyze,
optimize, and grow your app with ease.

### Prerequisites
**Create a Firebase Project:**
- Firebase Analytics is currently the primary analytics SDK supported by our package.
- You need to have a Firebase project created on the [Firebase Console](https://console.firebase.google.com/). This project will be used for configuration.

- Flutter installed on your machine

### Installation

To use this package, follow these steps:

- Open your Flutter project.
- Edit the `pubspec.yaml` file and add the following dependency:


```yaml
   dependencies:
     almentor_analytics_module:
       git:
         url: https://github.com/al-mentor/flutter_analytics_module
```
-  Import the package in your dart file where you want to use it by adding the following line at the top of the file:

```sh
import 'package:almentor_analytics_module/almentor_analytics_module.dart';
import 'package:almentor_analytics_module/events_name.dart';
```
-  To submit a new event:
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
**Important Note:**
At the moment, our Flutter analytics package exclusively integrates with Firebase Analytics. We're committed to providing you with a comprehensive analytics solution, and we have plans to include support for additional analytics SDKs, including AppsFlyer and SmartLock, in future updates.
