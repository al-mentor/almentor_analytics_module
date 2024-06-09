enum EventName {
  userDataEvent,

  loginPageLoadedEvent,
  loginPageExitEvent,
  loginWithSocialClickedEvent,
  socialSignUpCompletedEvent,
  socialLoginStartedEvent,
  socialLoginCompletedEvent,
  socialLoginFailedEvent,
  emailLoginStartedEvent,
  emailEnteredEvent,
  emailValidationFailedEvent,
  passwordEnteredEvent,
  passwordValidationFailedEvent,
  loginButtonClickedEvent,
  loginSuccessEvent,
  loginFailedEvent,
  userSignupFailedEvent,
  userAccountActivatedEvent,
  forgetPasswordClickedEvent,
  searchPerformedEvent,
  searchResultClickedEvent,
  searchResultAbandonedEvent,
  searchResultFilterAppliedEvent,
  searchResultSortedEvent,
  searchSuggestionSelectedEvent,
  searchPageViewedEvent,
  searchPageExitedEvent,
  categoryClickedEvent,
  aboutAlmentorClickedEvent,
  helpAndSupportClickedEvent,
  languageChangedEvent,
  termsAndConditionsClickedEvent,
  privacyPoliciesClickedEvent,
  logoutClickedEvent,
  logoutConfirmedEvent,
  logoutCanceledEvent,
  myCertificateAccessedEvent,
  aboutUsViewedEvent,
  helpAndSupportDialogOpenedEvent,
  myLearningPageOpenedEvent,
  courseResumedEvent,
  courseDetailsViewedEvent,
  courseSearchEvent,
  savedCourseAddedEvent,
  completedCourseCardViewedEvent,
  courseCompletionMarkedEvent,
  savedCourseRemovedEvent,
  courseCardClickedEvent,
  courseLessonResumedEvent,
  courseSavedEvent,
  courseEnrollmentStartedEvent,
  signUpStartedEvent,
  signUpCompletedEvent,
  appDataDeviceTypeEvent,
  appDataDeviceModelEvent,
  appDataAppVersionEvent,
  appDataPageViewsEvent,
  appDataAppInstalledEvent,
  appDataAppUninstalledEvent,
  userDataUserTypeEvent,
  userDataUserNameEvent,
  userDataUserEmailEvent,
  userDataSignUpDateEvent,
  userDataPhoneEvent,
  userDataGenderEvent,
  userDataIsSubscribedEvent,
  userDataEndSubscriptionDateEvent,
  userDataFirstSubscriptionDateEvent,
  addToCartEvent,
  paymentMethodSelectedEvent,
  subscribePlanSelectedEvent,
  couponCodeSubmittedEvent,
  checkoutEvent,
  paymentStatusSuccessEvent,
  paymentStatusFailEvent,
  paymentStatusPendingEvent,
  plansPageViewedEvent,

  /// Clips
  clipsTabOpenedEvent,
  clipServedEvent,
  clipWatchedEvent,
  clipCompletedEvent,
  clipLikedEvent,
  clipLCTAClickedEvent,
  clipSharedEvent,
  signupBlockerOpenedEvent,
  signupBlockerClosedEvent,
  signupBlockerCTAClickedEvent,

  /// Downloads
  courseDownloadedInitiatedEvent,
  courseDownloadedCompletedEvent,
  lessonDownloadedInitiatedEvent,
  lessonDownloadedCompletedEvent,
  courseDownloadedStoppedEvent,
  downloadedCourseDeletedEvent,
  downloadedCoursePlayedEvent,
  downloadSettingsChangedEvent,
  downloadsExpiredEvent,
  expiredDownloadActivatedEvent,
}
