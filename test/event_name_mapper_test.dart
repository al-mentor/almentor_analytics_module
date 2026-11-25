import 'package:almentor_analytics_module/event_name_mapper.dart';
import 'package:almentor_analytics_module/events_name.dart';
import 'package:flutter_test/flutter_test.dart';

/// Guards the wire names the dashboards are built on: renaming an enum value
/// silently renames the event in Mixpanel and Braze.
void main() {
  group('convertToSnakeCase', () {
    test('sends the home floating button tap as floating_button_clicked', () {
      expect(
        EventName.floatingButtonClicked.convertToSnakeCase,
        'floating_button_clicked',
      );
    });

    test('sends the Podcasts Hub view as podcasts_hub_viewed', () {
      expect(
        EventName.podcastsHubViewed.convertToSnakeCase,
        'podcasts_hub_viewed',
      );
    });

    test('sends the guest identity step as guest_checkout_identity_submitted',
        () {
      expect(
        EventName.guestCheckoutIdentitySubmittedEvent.convertToSnakeCase,
        'guest_checkout_identity_submitted',
      );
    });

    test('sends the guest activation as guest_checkout_account_activated', () {
      expect(
        EventName.guestCheckoutAccountActivatedEvent.convertToSnakeCase,
        'guest_checkout_account_activated',
      );
    });
  });
}
