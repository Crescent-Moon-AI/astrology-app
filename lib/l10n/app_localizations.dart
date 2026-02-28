import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Yuejian'**
  String get appTitle;

  /// No description provided for @scenarioCategoryLoveRelationship.
  ///
  /// In en, this message translates to:
  /// **'Love & Relationships'**
  String get scenarioCategoryLoveRelationship;

  /// No description provided for @scenarioCategoryCareerGrowth.
  ///
  /// In en, this message translates to:
  /// **'Career Growth'**
  String get scenarioCategoryCareerGrowth;

  /// No description provided for @scenarioCategoryDailyDecision.
  ///
  /// In en, this message translates to:
  /// **'Daily Decisions'**
  String get scenarioCategoryDailyDecision;

  /// No description provided for @scenarioCategoryPersonalGrowth.
  ///
  /// In en, this message translates to:
  /// **'Personal Growth'**
  String get scenarioCategoryPersonalGrowth;

  /// No description provided for @scenarioCategorySocialInteraction.
  ///
  /// In en, this message translates to:
  /// **'Social Interaction'**
  String get scenarioCategorySocialInteraction;

  /// No description provided for @scenarioExploreTitle.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get scenarioExploreTitle;

  /// No description provided for @scenarioExploreSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Discover consultation scenarios'**
  String get scenarioExploreSubtitle;

  /// No description provided for @scenarioHotTitle.
  ///
  /// In en, this message translates to:
  /// **'Popular Scenarios'**
  String get scenarioHotTitle;

  /// No description provided for @scenarioAllCategories.
  ///
  /// In en, this message translates to:
  /// **'All Categories'**
  String get scenarioAllCategories;

  /// No description provided for @scenarioStartConsultation.
  ///
  /// In en, this message translates to:
  /// **'Start Consultation'**
  String get scenarioStartConsultation;

  /// No description provided for @scenarioPresetQuestions.
  ///
  /// In en, this message translates to:
  /// **'Suggested Questions'**
  String get scenarioPresetQuestions;

  /// No description provided for @progressiveContinueReading.
  ///
  /// In en, this message translates to:
  /// **'Continue Reading'**
  String get progressiveContinueReading;

  /// No description provided for @progressiveExpandAll.
  ///
  /// In en, this message translates to:
  /// **'Expand All'**
  String get progressiveExpandAll;

  /// No description provided for @progressiveCollapseAll.
  ///
  /// In en, this message translates to:
  /// **'Collapse All'**
  String get progressiveCollapseAll;

  /// No description provided for @cardShowDetails.
  ///
  /// In en, this message translates to:
  /// **'Show Details'**
  String get cardShowDetails;

  /// No description provided for @cardHideDetails.
  ///
  /// In en, this message translates to:
  /// **'Hide Details'**
  String get cardHideDetails;

  /// No description provided for @chatInputHint.
  ///
  /// In en, this message translates to:
  /// **'Ask the stars...'**
  String get chatInputHint;

  /// No description provided for @chatTitle.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chatTitle;

  /// No description provided for @transitActiveTransits.
  ///
  /// In en, this message translates to:
  /// **'Active Transits'**
  String get transitActiveTransits;

  /// No description provided for @transitNoActive.
  ///
  /// In en, this message translates to:
  /// **'No active transits'**
  String get transitNoActive;

  /// No description provided for @transitUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Transits'**
  String get transitUpcoming;

  /// No description provided for @transitDetail.
  ///
  /// In en, this message translates to:
  /// **'Transit Detail'**
  String get transitDetail;

  /// No description provided for @transitAskAi.
  ///
  /// In en, this message translates to:
  /// **'Ask AI About This Transit'**
  String get transitAskAi;

  /// No description provided for @transitSeverityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get transitSeverityHigh;

  /// No description provided for @transitSeverityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get transitSeverityMedium;

  /// No description provided for @transitSeverityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get transitSeverityLow;

  /// No description provided for @transitApplying.
  ///
  /// In en, this message translates to:
  /// **'Applying'**
  String get transitApplying;

  /// No description provided for @transitSeparating.
  ///
  /// In en, this message translates to:
  /// **'Separating'**
  String get transitSeparating;

  /// No description provided for @transitDismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get transitDismiss;

  /// No description provided for @calendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Astro Calendar'**
  String get calendarTitle;

  /// No description provided for @calendarFullMoon.
  ///
  /// In en, this message translates to:
  /// **'Full Moon'**
  String get calendarFullMoon;

  /// No description provided for @calendarNewMoon.
  ///
  /// In en, this message translates to:
  /// **'New Moon'**
  String get calendarNewMoon;

  /// No description provided for @calendarSolarEclipse.
  ///
  /// In en, this message translates to:
  /// **'Solar Eclipse'**
  String get calendarSolarEclipse;

  /// No description provided for @calendarLunarEclipse.
  ///
  /// In en, this message translates to:
  /// **'Lunar Eclipse'**
  String get calendarLunarEclipse;

  /// No description provided for @calendarRetrogadeStart.
  ///
  /// In en, this message translates to:
  /// **'Retrograde Begins'**
  String get calendarRetrogadeStart;

  /// No description provided for @calendarRetrogadeEnd.
  ///
  /// In en, this message translates to:
  /// **'Direct'**
  String get calendarRetrogadeEnd;

  /// No description provided for @calendarSignIngress.
  ///
  /// In en, this message translates to:
  /// **'Enters'**
  String get calendarSignIngress;

  /// No description provided for @calendarNoEvents.
  ///
  /// In en, this message translates to:
  /// **'No events this day'**
  String get calendarNoEvents;

  /// No description provided for @characterAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About Xingjian'**
  String get characterAboutTitle;

  /// No description provided for @characterAboutBackstory.
  ///
  /// In en, this message translates to:
  /// **'Xingjian is your personal guide through the cosmos, combining ancient astrological wisdom with modern insight to help you navigate life\'s journey under the stars.'**
  String get characterAboutBackstory;

  /// No description provided for @characterExpressionGallery.
  ///
  /// In en, this message translates to:
  /// **'Expressions'**
  String get characterExpressionGallery;

  /// No description provided for @characterName.
  ///
  /// In en, this message translates to:
  /// **'Xingjian'**
  String get characterName;

  /// No description provided for @characterIntro.
  ///
  /// In en, this message translates to:
  /// **'Hello! I\'m Xingjian, your guide through the stars.'**
  String get characterIntro;

  /// No description provided for @cosmicTheme.
  ///
  /// In en, this message translates to:
  /// **'Cosmic'**
  String get cosmicTheme;

  /// No description provided for @classicTheme.
  ///
  /// In en, this message translates to:
  /// **'Classic'**
  String get classicTheme;

  /// No description provided for @systemTheme.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemTheme;

  /// No description provided for @appearanceSettings.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearanceSettings;

  /// No description provided for @themeSelection.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeSelection;

  /// No description provided for @reducedMotion.
  ///
  /// In en, this message translates to:
  /// **'Reduced Motion'**
  String get reducedMotion;

  /// No description provided for @reducedMotionDesc.
  ///
  /// In en, this message translates to:
  /// **'Disable animations for accessibility'**
  String get reducedMotionDesc;

  /// No description provided for @breathingLoaderMessage.
  ///
  /// In en, this message translates to:
  /// **'The cosmos takes time to reveal...'**
  String get breathingLoaderMessage;

  /// No description provided for @moonPhaseNew.
  ///
  /// In en, this message translates to:
  /// **'New Moon'**
  String get moonPhaseNew;

  /// No description provided for @moonPhaseWaxingCrescent.
  ///
  /// In en, this message translates to:
  /// **'Waxing Crescent'**
  String get moonPhaseWaxingCrescent;

  /// No description provided for @moonPhaseFirstQuarter.
  ///
  /// In en, this message translates to:
  /// **'First Quarter'**
  String get moonPhaseFirstQuarter;

  /// No description provided for @moonPhaseWaxingGibbous.
  ///
  /// In en, this message translates to:
  /// **'Waxing Gibbous'**
  String get moonPhaseWaxingGibbous;

  /// No description provided for @moonPhaseFull.
  ///
  /// In en, this message translates to:
  /// **'Full Moon'**
  String get moonPhaseFull;

  /// No description provided for @moonPhaseWaningGibbous.
  ///
  /// In en, this message translates to:
  /// **'Waning Gibbous'**
  String get moonPhaseWaningGibbous;

  /// No description provided for @moonPhaseLastQuarter.
  ///
  /// In en, this message translates to:
  /// **'Last Quarter'**
  String get moonPhaseLastQuarter;

  /// No description provided for @moonPhaseWaningCrescent.
  ///
  /// In en, this message translates to:
  /// **'Waning Crescent'**
  String get moonPhaseWaningCrescent;

  /// No description provided for @tarotRitualTitle.
  ///
  /// In en, this message translates to:
  /// **'Tarot Reading'**
  String get tarotRitualTitle;

  /// No description provided for @tarotSelectSpread.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Spread'**
  String get tarotSelectSpread;

  /// No description provided for @tarotEnterQuestion.
  ///
  /// In en, this message translates to:
  /// **'What would you like to ask? (optional)'**
  String get tarotEnterQuestion;

  /// No description provided for @tarotSpreadSingle.
  ///
  /// In en, this message translates to:
  /// **'Single Card'**
  String get tarotSpreadSingle;

  /// No description provided for @tarotSpreadSingleDesc.
  ///
  /// In en, this message translates to:
  /// **'Quick insight for one question'**
  String get tarotSpreadSingleDesc;

  /// No description provided for @tarotSpreadThreeCard.
  ///
  /// In en, this message translates to:
  /// **'Three Card'**
  String get tarotSpreadThreeCard;

  /// No description provided for @tarotSpreadThreeCardDesc.
  ///
  /// In en, this message translates to:
  /// **'Past, Present, Future'**
  String get tarotSpreadThreeCardDesc;

  /// No description provided for @tarotSpreadLove.
  ///
  /// In en, this message translates to:
  /// **'Love Spread'**
  String get tarotSpreadLove;

  /// No description provided for @tarotSpreadLoveDesc.
  ///
  /// In en, this message translates to:
  /// **'Explore your relationship'**
  String get tarotSpreadLoveDesc;

  /// No description provided for @tarotSpreadCelticCross.
  ///
  /// In en, this message translates to:
  /// **'Celtic Cross'**
  String get tarotSpreadCelticCross;

  /// No description provided for @tarotSpreadCelticCrossDesc.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive reading'**
  String get tarotSpreadCelticCrossDesc;

  /// No description provided for @tarotShuffling.
  ///
  /// In en, this message translates to:
  /// **'Shuffling the deck...'**
  String get tarotShuffling;

  /// No description provided for @tarotPickCards.
  ///
  /// In en, this message translates to:
  /// **'Select {count} cards'**
  String tarotPickCards(int count);

  /// No description provided for @tarotConfirmSelection.
  ///
  /// In en, this message translates to:
  /// **'Confirm Selection'**
  String get tarotConfirmSelection;

  /// No description provided for @tarotRevealing.
  ///
  /// In en, this message translates to:
  /// **'Revealing your cards...'**
  String get tarotRevealing;

  /// No description provided for @tarotRevealNext.
  ///
  /// In en, this message translates to:
  /// **'Reveal Next Card'**
  String get tarotRevealNext;

  /// No description provided for @tarotBeginReading.
  ///
  /// In en, this message translates to:
  /// **'Begin Reading'**
  String get tarotBeginReading;

  /// No description provided for @tarotCardUpright.
  ///
  /// In en, this message translates to:
  /// **'Upright'**
  String get tarotCardUpright;

  /// No description provided for @tarotCardReversed.
  ///
  /// In en, this message translates to:
  /// **'Reversed'**
  String get tarotCardReversed;

  /// No description provided for @tarotReadingComplete.
  ///
  /// In en, this message translates to:
  /// **'Reading Complete'**
  String get tarotReadingComplete;

  /// No description provided for @tarotCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel Reading'**
  String get tarotCancel;

  /// No description provided for @tarotResume.
  ///
  /// In en, this message translates to:
  /// **'Resume Reading'**
  String get tarotResume;

  /// No description provided for @friendsTitle.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get friendsTitle;

  /// No description provided for @addFriend.
  ///
  /// In en, this message translates to:
  /// **'Add Friend'**
  String get addFriend;

  /// No description provided for @friendName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get friendName;

  /// No description provided for @friendBirthDate.
  ///
  /// In en, this message translates to:
  /// **'Birth Date'**
  String get friendBirthDate;

  /// No description provided for @friendBirthTime.
  ///
  /// In en, this message translates to:
  /// **'Birth Time (optional)'**
  String get friendBirthTime;

  /// No description provided for @friendLocation.
  ///
  /// In en, this message translates to:
  /// **'Birth Location'**
  String get friendLocation;

  /// No description provided for @friendTimezone.
  ///
  /// In en, this message translates to:
  /// **'Timezone'**
  String get friendTimezone;

  /// No description provided for @friendRelationship.
  ///
  /// In en, this message translates to:
  /// **'Relationship'**
  String get friendRelationship;

  /// No description provided for @friendRelPartner.
  ///
  /// In en, this message translates to:
  /// **'Partner'**
  String get friendRelPartner;

  /// No description provided for @friendRelFamily.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get friendRelFamily;

  /// No description provided for @friendRelFriend.
  ///
  /// In en, this message translates to:
  /// **'Friend'**
  String get friendRelFriend;

  /// No description provided for @friendRelColleague.
  ///
  /// In en, this message translates to:
  /// **'Colleague'**
  String get friendRelColleague;

  /// No description provided for @friendRelCrush.
  ///
  /// In en, this message translates to:
  /// **'Crush'**
  String get friendRelCrush;

  /// No description provided for @friendSave.
  ///
  /// In en, this message translates to:
  /// **'Save Friend'**
  String get friendSave;

  /// No description provided for @friendDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete Friend'**
  String get friendDelete;

  /// No description provided for @friendDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this friend?'**
  String get friendDeleteConfirm;

  /// No description provided for @friendLimit.
  ///
  /// In en, this message translates to:
  /// **'Maximum 50 friends reached'**
  String get friendLimit;

  /// No description provided for @shareTitle.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareTitle;

  /// No description provided for @shareCard.
  ///
  /// In en, this message translates to:
  /// **'Share Card'**
  String get shareCard;

  /// No description provided for @shareCopyLink.
  ///
  /// In en, this message translates to:
  /// **'Copy Link'**
  String get shareCopyLink;

  /// No description provided for @shareSaveImage.
  ///
  /// In en, this message translates to:
  /// **'Save Image'**
  String get shareSaveImage;

  /// No description provided for @shareExpires.
  ///
  /// In en, this message translates to:
  /// **'Expires {date}'**
  String shareExpires(String date);

  /// No description provided for @shareLinkCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied!'**
  String get shareLinkCopied;

  /// No description provided for @synastryOverall.
  ///
  /// In en, this message translates to:
  /// **'Overall'**
  String get synastryOverall;

  /// No description provided for @synastryEmotional.
  ///
  /// In en, this message translates to:
  /// **'Emotional'**
  String get synastryEmotional;

  /// No description provided for @synastryIntellectual.
  ///
  /// In en, this message translates to:
  /// **'Intellectual'**
  String get synastryIntellectual;

  /// No description provided for @synastryPhysical.
  ///
  /// In en, this message translates to:
  /// **'Physical'**
  String get synastryPhysical;

  /// No description provided for @synastrySpiritual.
  ///
  /// In en, this message translates to:
  /// **'Spiritual'**
  String get synastrySpiritual;

  /// No description provided for @askAiAboutThis.
  ///
  /// In en, this message translates to:
  /// **'Ask AI About This'**
  String get askAiAboutThis;

  /// No description provided for @moodCheckinTitle.
  ///
  /// In en, this message translates to:
  /// **'How are you feeling today?'**
  String get moodCheckinTitle;

  /// No description provided for @moodScore1.
  ///
  /// In en, this message translates to:
  /// **'Terrible'**
  String get moodScore1;

  /// No description provided for @moodScore2.
  ///
  /// In en, this message translates to:
  /// **'Bad'**
  String get moodScore2;

  /// No description provided for @moodScore3.
  ///
  /// In en, this message translates to:
  /// **'Okay'**
  String get moodScore3;

  /// No description provided for @moodScore4.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get moodScore4;

  /// No description provided for @moodScore5.
  ///
  /// In en, this message translates to:
  /// **'Great'**
  String get moodScore5;

  /// No description provided for @moodTagHappy.
  ///
  /// In en, this message translates to:
  /// **'Happy'**
  String get moodTagHappy;

  /// No description provided for @moodTagAnxious.
  ///
  /// In en, this message translates to:
  /// **'Anxious'**
  String get moodTagAnxious;

  /// No description provided for @moodTagCreative.
  ///
  /// In en, this message translates to:
  /// **'Creative'**
  String get moodTagCreative;

  /// No description provided for @moodTagTired.
  ///
  /// In en, this message translates to:
  /// **'Tired'**
  String get moodTagTired;

  /// No description provided for @moodTagRomantic.
  ///
  /// In en, this message translates to:
  /// **'Romantic'**
  String get moodTagRomantic;

  /// No description provided for @moodTagCalm.
  ///
  /// In en, this message translates to:
  /// **'Calm'**
  String get moodTagCalm;

  /// No description provided for @moodTagEnergetic.
  ///
  /// In en, this message translates to:
  /// **'Energetic'**
  String get moodTagEnergetic;

  /// No description provided for @moodTagConfused.
  ///
  /// In en, this message translates to:
  /// **'Confused'**
  String get moodTagConfused;

  /// No description provided for @moodHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Mood History'**
  String get moodHistoryTitle;

  /// No description provided for @moodInsightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Mood Insights'**
  String get moodInsightsTitle;

  /// No description provided for @moodStreak.
  ///
  /// In en, this message translates to:
  /// **'Day {count} streak'**
  String moodStreak(int count);

  /// No description provided for @moodInsightsProgress.
  ///
  /// In en, this message translates to:
  /// **'Log {remaining} more days to unlock insights'**
  String moodInsightsProgress(int remaining);

  /// No description provided for @moodDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get moodDone;

  /// No description provided for @moodEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get moodEdit;

  /// No description provided for @moodNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Add a note (optional)'**
  String get moodNoteHint;

  /// No description provided for @moodAskAi.
  ///
  /// In en, this message translates to:
  /// **'Ask AI About This'**
  String get moodAskAi;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
