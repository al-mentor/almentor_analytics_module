import 'package:almentor_analytics_module/events_name.dart';

extension EventNameExtension on EventName {
  String get valueWithFormattedDash {
    switch (this) {
      case EventName.loginPageLoadedEvent:
        return 'login_page_loaded';
      case EventName.loginPageExitEvent:
        return 'login_page_exit';
      case EventName.loginWithSocialClickedEvent:
        return 'login_with_social_clicked';
      case EventName.socialLoginStartedEvent:
        return 'social_login_started';
      case EventName.socialLoginCompletedEvent:
        return 'social_login_completed';
      case EventName.socialLoginFailedEvent:
        return 'social_login_failed';
      case EventName.emailLoginStartedEvent:
        return 'email_login_started';
      case EventName.emailEnteredEvent:
        return ' email_entered';
      case EventName.emailValidationFailedEvent:
        return 'email_validation_failed';
      case EventName.passwordEnteredEvent:
        return 'password_entered';
      case EventName.passwordValidationFailedEvent:
        return 'password_validation_failed';
      case EventName.loginButtonClickedEvent:
        return 'login_button_cLicked';
      case EventName.loginSuccessEvent:
        return 'login_success';
      case EventName.loginFailedEvent:
        return 'login_failed';
      case EventName.forgetPasswordClickedEvent:
        return 'forget_password_clicked';
      case EventName.searchPerformedEvent:
        return 'search_performed';
      case EventName.searchResultClickedEvent:
        return 'search_result_cLicked';
      case EventName.searchResultAbandonedEvent:
        return 'search_result_abandoned';
      case EventName.searchResultFilterAppliedEvent:
        return 'search_result_filter_applied';
      case EventName.searchResultSortedEvent:
        return 'search_result_sorted';
      case EventName.searchSuggestionSelectedEvent:
        return 'search_suggestion_selected';
      case EventName.searchPageViewedEvent:
        return 'search_page_viewed';
      case EventName.searchPageExitedEvent:
        return 'search_result_exited';
      case EventName.categoryClickedEvent:
        return 'category_clicked';
      case EventName.aboutAlmentorClickedEvent:
        return 'about_almentor_clicked';
      case EventName.helpAndSupportClickedEvent:
        return 'help_and_support_cLicked';
      case EventName.languageChangedEvent:
        return 'language_changed';
      case EventName.termsAndConditionsClickedEvent:
        return 'terms_and_conditions_clicked';
      case EventName.privacyPoliciesClickedEvent:
        return 'privacy_policies_clicked';
      case EventName.logoutClickedEvent:
        return 'logout_clicked';
      case EventName.logoutConfirmedEvent:
        return 'logout_confirmed';
      case EventName.logoutCanceledEvent:
        return 'logout_canceled';
      case EventName.myCertificateAccessedEvent:
        return 'my_certificate_accessed';
      case EventName.aboutUsViewedEvent:
        return 'about_us_viewed';
      case EventName.helpAndSupportDialogOpenedEvent:
        return 'help_and_support_dialog_opened';
      case EventName.myLearningPageOpenedEvent:
        return 'my_learning_page_opened';
      case EventName.courseResumedEvent:
        return 'course_resumed';
      case EventName.courseDetailsViewedEvent:
        return 'course_details_viewed';
      case EventName.courseSearchEvent:
        return 'course_search';
      case EventName.savedCourseAddedEvent:
        return 'saved_course_added';
      case EventName.completedCourseCardViewedEvent:
        return 'completed_course_card_viewed';
      case EventName.courseCompletionMarkedEvent:
        return 'course_completion_marked';
      case EventName.savedCourseRemovedEvent:
        return 'saved_course_removed';
      case EventName.courseCardClickedEvent:
        return 'course_card_clicked';
      case EventName.courseLessonResumedEvent:
        return 'course_lesson_resumed';
      case EventName.courseSavedEvent:
        return 'course_saved_event';
      case EventName.courseEnrollmentStartedEvent:
        return 'course_enrollment_started';
    }
  }

  String get valueWithFormattedCamelCase {
    switch (this) {
      case EventName.loginPageLoadedEvent:
        return 'Login Page Loaded';
      case EventName.loginPageExitEvent:
        return 'Login Page Exit';
      case EventName.loginWithSocialClickedEvent:
        return 'Login With Social Clicked';
      case EventName.socialLoginStartedEvent:
        return 'Social Login Started';
      case EventName.socialLoginCompletedEvent:
        return 'Social Login Completed';
      case EventName.socialLoginFailedEvent:
        return 'Social Login Failed';
      case EventName.emailLoginStartedEvent:
        return 'Email Login Started';
      case EventName.emailEnteredEvent:
        return 'Email Entered';
      case EventName.emailValidationFailedEvent:
        return 'Email Validation Failed';
      case EventName.passwordEnteredEvent:
        return 'Password Entered';
      case EventName.passwordValidationFailedEvent:
        return 'Password Validation Failed';
      case EventName.loginButtonClickedEvent:
        return 'Login Button Clicked';
      case EventName.loginSuccessEvent:
        return 'Login Success';
      case EventName.loginFailedEvent:
        return 'Login Failed';
      case EventName.forgetPasswordClickedEvent:
        return 'Forget Password Clicked';
      case EventName.searchPerformedEvent:
        return 'Search Performed';
      case EventName.searchResultClickedEvent:
        return 'Search Result Clicked';
      case EventName.searchResultAbandonedEvent:
        return 'Search Result Abandoned';
      case EventName.searchResultFilterAppliedEvent:
        return 'Search Result Filter Applied';
      case EventName.searchResultSortedEvent:
        return 'Search Result Sorted';
      case EventName.searchSuggestionSelectedEvent:
        return 'Search Suggestion Selected';
      case EventName.searchPageViewedEvent:
        return 'Search Page Viewed';
      case EventName.searchPageExitedEvent:
        return 'Search Page Exited';
      case EventName.categoryClickedEvent:
        return 'Category Clicked';
      case EventName.aboutAlmentorClickedEvent:
        return 'About Almentor Clicked';
      case EventName.helpAndSupportClickedEvent:
        return 'Help and Support Clicked';
      case EventName.languageChangedEvent:
        return 'Language Changed';
      case EventName.termsAndConditionsClickedEvent:
        return 'Terms and Conditions Clicked';
      case EventName.privacyPoliciesClickedEvent:
        return 'Privacy Policies Clicked';
      case EventName.logoutClickedEvent:
        return 'Logout Clicked';
      case EventName.logoutConfirmedEvent:
        return 'Logout Confirmed';
      case EventName.logoutCanceledEvent:
        return 'Logout Canceled';
      case EventName.myCertificateAccessedEvent:
        return 'My Certificate Accessed';
      case EventName.aboutUsViewedEvent:
        return 'About Us Viewed';
      case EventName.helpAndSupportDialogOpenedEvent:
        return 'Help and Support Dialog Opened';
      case EventName.myLearningPageOpenedEvent:
        return 'My Learning Page Opened';
      case EventName.courseResumedEvent:
        return 'Course Resumed';
      case EventName.courseDetailsViewedEvent:
        return 'Course Details Viewed';
      case EventName.courseSearchEvent:
        return 'Course Search';
      case EventName.savedCourseAddedEvent:
        return 'Saved Course Added';
      case EventName.completedCourseCardViewedEvent:
        return 'Completed Course Card Viewed';
      case EventName.courseCompletionMarkedEvent:
        return 'Course Completion Marked';
      case EventName.savedCourseRemovedEvent:
        return 'Saved Course Removed';
      case EventName.courseCardClickedEvent:
        return 'Course Card Clicked';
      case EventName.courseLessonResumedEvent:
        return 'Course Lesson Resumed';
      case EventName.courseSavedEvent:
        return 'Course Saved Event';
      case EventName.courseEnrollmentStartedEvent:
        return 'Course Enrollment Started';
    }
  }
}
