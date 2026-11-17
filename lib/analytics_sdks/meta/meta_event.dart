/// The app events sent to Meta (Facebook) Ads Manager.
///
/// [fbName] is the name Meta receives: its standard event name where one
/// exists, otherwise a custom name.
enum MetaEvent {
  pageView('PageView'),
  viewContent('fb_mobile_content_view'),
  addToCart('fb_mobile_add_to_cart'),
  initiateCheckout('fb_mobile_initiated_checkout'),
  completeRegistration('fb_mobile_complete_registration'),
  purchase('fb_mobile_purchase');

  const MetaEvent(this.fbName);

  final String fbName;
}
