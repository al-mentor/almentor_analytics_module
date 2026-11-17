import 'package:almentor_analytics_module/events_name.dart';

class EventModule {
  EventName eventName;
  dynamic eventValue;
  int count;
  bool isFirebaseAllowed;
  bool isMixPanelAllowed;
  bool isBrazeAllowed;

  EventModule(this.eventName, this.eventValue, this.count,
      this.isFirebaseAllowed, this.isMixPanelAllowed, this.isBrazeAllowed);
}
