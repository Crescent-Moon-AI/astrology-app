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
  /// **'Xingjian'**
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

  /// No description provided for @friendFillBirthInfo.
  ///
  /// In en, this message translates to:
  /// **'Fill in their birth info'**
  String get friendFillBirthInfo;

  /// No description provided for @friendFillBirthInfoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Understand their personality, emotions, thinking, and unlock synastry'**
  String get friendFillBirthInfoSubtitle;

  /// No description provided for @friendBasicInfo.
  ///
  /// In en, this message translates to:
  /// **'Basic Info'**
  String get friendBasicInfo;

  /// No description provided for @friendNickname.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get friendNickname;

  /// No description provided for @friendNicknamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter nickname'**
  String get friendNicknamePlaceholder;

  /// No description provided for @friendGenderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get friendGenderFemale;

  /// No description provided for @friendGenderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get friendGenderMale;

  /// No description provided for @friendTaRelationship.
  ///
  /// In en, this message translates to:
  /// **'They are your'**
  String get friendTaRelationship;

  /// No description provided for @friendBirthInfo.
  ///
  /// In en, this message translates to:
  /// **'Birth Info'**
  String get friendBirthInfo;

  /// No description provided for @friendCalendarSolar.
  ///
  /// In en, this message translates to:
  /// **'Solar'**
  String get friendCalendarSolar;

  /// No description provided for @friendCalendarLunar.
  ///
  /// In en, this message translates to:
  /// **'Lunar'**
  String get friendCalendarLunar;

  /// No description provided for @friendSelectBirthTime.
  ///
  /// In en, this message translates to:
  /// **'Select birth time'**
  String get friendSelectBirthTime;

  /// No description provided for @friendUnknownExactTime.
  ///
  /// In en, this message translates to:
  /// **'I don\'t know the exact time'**
  String get friendUnknownExactTime;

  /// No description provided for @friendSelectBirthCity.
  ///
  /// In en, this message translates to:
  /// **'Select birth city'**
  String get friendSelectBirthCity;

  /// No description provided for @friendInvite.
  ///
  /// In en, this message translates to:
  /// **'Invite Friend'**
  String get friendInvite;

  /// No description provided for @friendSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
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

  /// No description provided for @authSubtitle.
  ///
  /// In en, this message translates to:
  /// **'AI Astrologer'**
  String get authSubtitle;

  /// No description provided for @authEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmail;

  /// No description provided for @authPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// No description provided for @authLogin.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get authLogin;

  /// No description provided for @authRegister.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get authRegister;

  /// No description provided for @authCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get authCreateAccount;

  /// No description provided for @authUsername.
  ///
  /// In en, this message translates to:
  /// **'Username (optional)'**
  String get authUsername;

  /// No description provided for @authConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get authConfirmPassword;

  /// No description provided for @authNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Register'**
  String get authNoAccount;

  /// No description provided for @authHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Login'**
  String get authHaveAccount;

  /// No description provided for @authRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get authRequired;

  /// No description provided for @authInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get authInvalidEmail;

  /// No description provided for @authPasswordMin.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get authPasswordMin;

  /// No description provided for @authPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get authPasswordMismatch;

  /// No description provided for @tarotCardCount.
  ///
  /// In en, this message translates to:
  /// **'{count} cards'**
  String tarotCardCount(int count);

  /// No description provided for @exprGreeting.
  ///
  /// In en, this message translates to:
  /// **'Greeting'**
  String get exprGreeting;

  /// No description provided for @exprThinking.
  ///
  /// In en, this message translates to:
  /// **'Thinking'**
  String get exprThinking;

  /// No description provided for @exprHappy.
  ///
  /// In en, this message translates to:
  /// **'Happy'**
  String get exprHappy;

  /// No description provided for @exprCaring.
  ///
  /// In en, this message translates to:
  /// **'Caring'**
  String get exprCaring;

  /// No description provided for @exprMysterious.
  ///
  /// In en, this message translates to:
  /// **'Mysterious'**
  String get exprMysterious;

  /// No description provided for @exprSurprised.
  ///
  /// In en, this message translates to:
  /// **'Surprised'**
  String get exprSurprised;

  /// No description provided for @exprExplaining.
  ///
  /// In en, this message translates to:
  /// **'Explaining'**
  String get exprExplaining;

  /// No description provided for @exprFarewell.
  ///
  /// In en, this message translates to:
  /// **'Farewell'**
  String get exprFarewell;

  /// No description provided for @languageSelection.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSelection;

  /// No description provided for @languageChinese.
  ///
  /// In en, this message translates to:
  /// **'中文'**
  String get languageChinese;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'Follow System'**
  String get languageSystem;

  /// No description provided for @errorLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load'**
  String get errorLoadFailed;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @noDataFound.
  ///
  /// In en, this message translates to:
  /// **'No data found'**
  String get noDataFound;

  /// No description provided for @profileBirthData.
  ///
  /// In en, this message translates to:
  /// **'Birth Information'**
  String get profileBirthData;

  /// No description provided for @profileBirthDataEmpty.
  ///
  /// In en, this message translates to:
  /// **'Add birth info for personalized readings'**
  String get profileBirthDataEmpty;

  /// No description provided for @profileEditBirthData.
  ///
  /// In en, this message translates to:
  /// **'Edit Birth Info'**
  String get profileEditBirthData;

  /// No description provided for @birthDate.
  ///
  /// In en, this message translates to:
  /// **'Birth Date'**
  String get birthDate;

  /// No description provided for @birthTime.
  ///
  /// In en, this message translates to:
  /// **'Birth Time'**
  String get birthTime;

  /// No description provided for @birthTimeUnknown.
  ///
  /// In en, this message translates to:
  /// **'I don\'t know my birth time'**
  String get birthTimeUnknown;

  /// No description provided for @birthTimeExact.
  ///
  /// In en, this message translates to:
  /// **'Exact'**
  String get birthTimeExact;

  /// No description provided for @birthTimeApproximate.
  ///
  /// In en, this message translates to:
  /// **'Approximate'**
  String get birthTimeApproximate;

  /// No description provided for @birthPlace.
  ///
  /// In en, this message translates to:
  /// **'Birth Place'**
  String get birthPlace;

  /// No description provided for @birthPlaceSearch.
  ///
  /// In en, this message translates to:
  /// **'Search city...'**
  String get birthPlaceSearch;

  /// No description provided for @birthPlaceTimezone.
  ///
  /// In en, this message translates to:
  /// **'Timezone: {timezone}'**
  String birthPlaceTimezone(String timezone);

  /// No description provided for @birthDataSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get birthDataSave;

  /// No description provided for @birthDataSaved.
  ///
  /// In en, this message translates to:
  /// **'Birth info saved'**
  String get birthDataSaved;

  /// No description provided for @birthDataRequired.
  ///
  /// In en, this message translates to:
  /// **'Please fill in at least the birth date'**
  String get birthDataRequired;

  /// No description provided for @mysticalLoading1.
  ///
  /// In en, this message translates to:
  /// **'The stars are aligning...'**
  String get mysticalLoading1;

  /// No description provided for @mysticalLoading2.
  ///
  /// In en, this message translates to:
  /// **'Threads of fate are weaving...'**
  String get mysticalLoading2;

  /// No description provided for @mysticalLoading3.
  ///
  /// In en, this message translates to:
  /// **'Cosmic messages are converging...'**
  String get mysticalLoading3;

  /// No description provided for @mysticalLoading4.
  ///
  /// In en, this message translates to:
  /// **'Let us listen with calm hearts...'**
  String get mysticalLoading4;

  /// No description provided for @tarotCancelConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this reading?'**
  String get tarotCancelConfirm;

  /// No description provided for @tarotReadingPrompt.
  ///
  /// In en, this message translates to:
  /// **'Please interpret the tarot spread for me'**
  String get tarotReadingPrompt;

  /// No description provided for @diceRitualTitle.
  ///
  /// In en, this message translates to:
  /// **'Dice Divination'**
  String get diceRitualTitle;

  /// No description provided for @dicePrompt.
  ///
  /// In en, this message translates to:
  /// **'Roll three dice to reveal cosmic guidance'**
  String get dicePrompt;

  /// No description provided for @diceQuestionHint.
  ///
  /// In en, this message translates to:
  /// **'What would you like to ask? (optional)'**
  String get diceQuestionHint;

  /// No description provided for @diceRollButton.
  ///
  /// In en, this message translates to:
  /// **'Roll Dice'**
  String get diceRollButton;

  /// No description provided for @diceRolling.
  ///
  /// In en, this message translates to:
  /// **'Rolling the dice...'**
  String get diceRolling;

  /// No description provided for @diceTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get diceTotal;

  /// No description provided for @diceGetReading.
  ///
  /// In en, this message translates to:
  /// **'Get AI Reading'**
  String get diceGetReading;

  /// No description provided for @diceRollAgain.
  ///
  /// In en, this message translates to:
  /// **'Roll Again'**
  String get diceRollAgain;

  /// No description provided for @diceReadingPrompt.
  ///
  /// In en, this message translates to:
  /// **'Please interpret the dice divination result for me'**
  String get diceReadingPrompt;

  /// No description provided for @numerologyTitle.
  ///
  /// In en, this message translates to:
  /// **'Numerology'**
  String get numerologyTitle;

  /// No description provided for @numerologyPrompt.
  ///
  /// In en, this message translates to:
  /// **'Enter your birth date to discover your life path number'**
  String get numerologyPrompt;

  /// No description provided for @numerologySelectDate.
  ///
  /// In en, this message translates to:
  /// **'Select birth date'**
  String get numerologySelectDate;

  /// No description provided for @numerologyCalculate.
  ///
  /// In en, this message translates to:
  /// **'Calculate Life Path'**
  String get numerologyCalculate;

  /// No description provided for @numerologyCalculating.
  ///
  /// In en, this message translates to:
  /// **'Calculating...'**
  String get numerologyCalculating;

  /// No description provided for @numerologyLifePath.
  ///
  /// In en, this message translates to:
  /// **'Life Path Number'**
  String get numerologyLifePath;

  /// No description provided for @numerologyGetReading.
  ///
  /// In en, this message translates to:
  /// **'Get AI Reading'**
  String get numerologyGetReading;

  /// No description provided for @numerologyTryAnother.
  ///
  /// In en, this message translates to:
  /// **'Try Another Date'**
  String get numerologyTryAnother;

  /// No description provided for @runeRitualTitle.
  ///
  /// In en, this message translates to:
  /// **'Rune Reading'**
  String get runeRitualTitle;

  /// No description provided for @runeSelectSpread.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Spread'**
  String get runeSelectSpread;

  /// No description provided for @runeQuestionHint.
  ///
  /// In en, this message translates to:
  /// **'What would you like to ask? (optional)'**
  String get runeQuestionHint;

  /// No description provided for @runeBeginRitual.
  ///
  /// In en, this message translates to:
  /// **'Begin Ritual'**
  String get runeBeginRitual;

  /// No description provided for @runeDrawPrompt.
  ///
  /// In en, this message translates to:
  /// **'Tap the rune bag to draw runes'**
  String get runeDrawPrompt;

  /// No description provided for @runeRevealNext.
  ///
  /// In en, this message translates to:
  /// **'Reveal Next'**
  String get runeRevealNext;

  /// No description provided for @runeBeginReading.
  ///
  /// In en, this message translates to:
  /// **'Begin Reading'**
  String get runeBeginReading;

  /// No description provided for @runeCancelled.
  ///
  /// In en, this message translates to:
  /// **'Ritual cancelled'**
  String get runeCancelled;

  /// No description provided for @lenormandRitualTitle.
  ///
  /// In en, this message translates to:
  /// **'Lenormand Reading'**
  String get lenormandRitualTitle;

  /// No description provided for @lenormandSelectSpread.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Spread'**
  String get lenormandSelectSpread;

  /// No description provided for @lenormandQuestionHint.
  ///
  /// In en, this message translates to:
  /// **'What would you like to ask? (optional)'**
  String get lenormandQuestionHint;

  /// No description provided for @lenormandBeginRitual.
  ///
  /// In en, this message translates to:
  /// **'Begin Ritual'**
  String get lenormandBeginRitual;

  /// No description provided for @lenormandShuffling.
  ///
  /// In en, this message translates to:
  /// **'Shuffling the deck...'**
  String get lenormandShuffling;

  /// No description provided for @lenormandStartPicking.
  ///
  /// In en, this message translates to:
  /// **'Start Picking'**
  String get lenormandStartPicking;

  /// No description provided for @lenormandPickCards.
  ///
  /// In en, this message translates to:
  /// **'Select {count} cards'**
  String lenormandPickCards(int count);

  /// No description provided for @lenormandConfirmSelection.
  ///
  /// In en, this message translates to:
  /// **'Confirm Selection'**
  String get lenormandConfirmSelection;

  /// No description provided for @lenormandRevealNext.
  ///
  /// In en, this message translates to:
  /// **'Reveal Next Card'**
  String get lenormandRevealNext;

  /// No description provided for @lenormandBeginReading.
  ///
  /// In en, this message translates to:
  /// **'Begin Reading'**
  String get lenormandBeginReading;

  /// No description provided for @lenormandCancelled.
  ///
  /// In en, this message translates to:
  /// **'Ritual cancelled'**
  String get lenormandCancelled;

  /// No description provided for @ichingRitualTitle.
  ///
  /// In en, this message translates to:
  /// **'I Ching Divination'**
  String get ichingRitualTitle;

  /// No description provided for @ichingQuestionPrompt.
  ///
  /// In en, this message translates to:
  /// **'Calm your mind and focus on your question'**
  String get ichingQuestionPrompt;

  /// No description provided for @ichingQuestionHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your question...'**
  String get ichingQuestionHint;

  /// No description provided for @ichingBeginTossing.
  ///
  /// In en, this message translates to:
  /// **'Begin Coin Tossing'**
  String get ichingBeginTossing;

  /// No description provided for @ichingRound.
  ///
  /// In en, this message translates to:
  /// **'Line {round}'**
  String ichingRound(int round);

  /// No description provided for @ichingTapToToss.
  ///
  /// In en, this message translates to:
  /// **'Tap to toss coins'**
  String get ichingTapToToss;

  /// No description provided for @ichingBuildHexagram.
  ///
  /// In en, this message translates to:
  /// **'Build Hexagram'**
  String get ichingBuildHexagram;

  /// No description provided for @ichingBuilding.
  ///
  /// In en, this message translates to:
  /// **'Building hexagram...'**
  String get ichingBuilding;

  /// No description provided for @ichingPrimaryHexagram.
  ///
  /// In en, this message translates to:
  /// **'Primary Hexagram'**
  String get ichingPrimaryHexagram;

  /// No description provided for @ichingTransformedHexagram.
  ///
  /// In en, this message translates to:
  /// **'Transformed Hexagram'**
  String get ichingTransformedHexagram;

  /// No description provided for @ichingBeginReading.
  ///
  /// In en, this message translates to:
  /// **'Begin Reading'**
  String get ichingBeginReading;

  /// No description provided for @ichingCancelled.
  ///
  /// In en, this message translates to:
  /// **'Ritual cancelled'**
  String get ichingCancelled;

  /// No description provided for @meihuaRitualTitle.
  ///
  /// In en, this message translates to:
  /// **'Meihua Yishu'**
  String get meihuaRitualTitle;

  /// No description provided for @meihuaSelectMethod.
  ///
  /// In en, this message translates to:
  /// **'Choose a Method'**
  String get meihuaSelectMethod;

  /// No description provided for @meihuaTimeMethod.
  ///
  /// In en, this message translates to:
  /// **'Time-Based'**
  String get meihuaTimeMethod;

  /// No description provided for @meihuaTimeMethodDesc.
  ///
  /// In en, this message translates to:
  /// **'Auto-cast using current time'**
  String get meihuaTimeMethodDesc;

  /// No description provided for @meihuaNumberMethod.
  ///
  /// In en, this message translates to:
  /// **'Number-Based'**
  String get meihuaNumberMethod;

  /// No description provided for @meihuaNumberMethodDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter two numbers to cast'**
  String get meihuaNumberMethodDesc;

  /// No description provided for @meihuaQuestionHint.
  ///
  /// In en, this message translates to:
  /// **'What would you like to ask? (optional)'**
  String get meihuaQuestionHint;

  /// No description provided for @meihuaCurrentTime.
  ///
  /// In en, this message translates to:
  /// **'Current Time'**
  String get meihuaCurrentTime;

  /// No description provided for @meihuaNumberA.
  ///
  /// In en, this message translates to:
  /// **'Upper'**
  String get meihuaNumberA;

  /// No description provided for @meihuaNumberB.
  ///
  /// In en, this message translates to:
  /// **'Lower'**
  String get meihuaNumberB;

  /// No description provided for @meihuaCalculateButton.
  ///
  /// In en, this message translates to:
  /// **'Cast Hexagram'**
  String get meihuaCalculateButton;

  /// No description provided for @meihuaCalculating.
  ///
  /// In en, this message translates to:
  /// **'Casting hexagram...'**
  String get meihuaCalculating;

  /// No description provided for @meihuaMovingLine.
  ///
  /// In en, this message translates to:
  /// **'Moving Line'**
  String get meihuaMovingLine;

  /// No description provided for @meihuaPrimaryHexagram.
  ///
  /// In en, this message translates to:
  /// **'Primary'**
  String get meihuaPrimaryHexagram;

  /// No description provided for @meihuaTransformedHexagram.
  ///
  /// In en, this message translates to:
  /// **'Transformed'**
  String get meihuaTransformedHexagram;

  /// No description provided for @meihuaMutualHexagram.
  ///
  /// In en, this message translates to:
  /// **'Mutual'**
  String get meihuaMutualHexagram;

  /// No description provided for @meihuaGetReading.
  ///
  /// In en, this message translates to:
  /// **'Get AI Reading'**
  String get meihuaGetReading;

  /// No description provided for @meihuaTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get meihuaTryAgain;

  /// No description provided for @divinationHubTitle.
  ///
  /// In en, this message translates to:
  /// **'Divination'**
  String get divinationHubTitle;

  /// No description provided for @divinationHubSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your divination method'**
  String get divinationHubSubtitle;

  /// No description provided for @divinationTarotName.
  ///
  /// In en, this message translates to:
  /// **'Tarot'**
  String get divinationTarotName;

  /// No description provided for @divinationTarotDesc.
  ///
  /// In en, this message translates to:
  /// **'Wisdom from 78 cards'**
  String get divinationTarotDesc;

  /// No description provided for @divinationDiceName.
  ///
  /// In en, this message translates to:
  /// **'Dice Divination'**
  String get divinationDiceName;

  /// No description provided for @divinationDiceDesc.
  ///
  /// In en, this message translates to:
  /// **'Three dice reveal your destiny'**
  String get divinationDiceDesc;

  /// No description provided for @divinationNumerologyName.
  ///
  /// In en, this message translates to:
  /// **'Numerology'**
  String get divinationNumerologyName;

  /// No description provided for @divinationNumerologyDesc.
  ///
  /// In en, this message translates to:
  /// **'Life path number reveals your code'**
  String get divinationNumerologyDesc;

  /// No description provided for @divinationRuneName.
  ///
  /// In en, this message translates to:
  /// **'Norse Runes'**
  String get divinationRuneName;

  /// No description provided for @divinationRuneDesc.
  ///
  /// In en, this message translates to:
  /// **'Ancient rune guidance'**
  String get divinationRuneDesc;

  /// No description provided for @divinationLenormandName.
  ///
  /// In en, this message translates to:
  /// **'Lenormand'**
  String get divinationLenormandName;

  /// No description provided for @divinationLenormandDesc.
  ///
  /// In en, this message translates to:
  /// **'36 cards of daily prophecy'**
  String get divinationLenormandDesc;

  /// No description provided for @divinationIChingName.
  ///
  /// In en, this message translates to:
  /// **'I Ching'**
  String get divinationIChingName;

  /// No description provided for @divinationIChingDesc.
  ///
  /// In en, this message translates to:
  /// **'Coin toss hexagrams, way of heaven'**
  String get divinationIChingDesc;

  /// No description provided for @divinationMeihuaName.
  ///
  /// In en, this message translates to:
  /// **'Meihua Yishu'**
  String get divinationMeihuaName;

  /// No description provided for @divinationMeihuaDesc.
  ///
  /// In en, this message translates to:
  /// **'Cast by time, divine all things'**
  String get divinationMeihuaDesc;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @homeFortuneTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Fortune'**
  String get homeFortuneTitle;

  /// No description provided for @homeOverallScore.
  ///
  /// In en, this message translates to:
  /// **'Overall'**
  String get homeOverallScore;

  /// No description provided for @homeDimensionLove.
  ///
  /// In en, this message translates to:
  /// **'Love'**
  String get homeDimensionLove;

  /// No description provided for @homeDimensionCareer.
  ///
  /// In en, this message translates to:
  /// **'Career'**
  String get homeDimensionCareer;

  /// No description provided for @homeDimensionWealth.
  ///
  /// In en, this message translates to:
  /// **'Wealth'**
  String get homeDimensionWealth;

  /// No description provided for @homeDimensionStudy.
  ///
  /// In en, this message translates to:
  /// **'Study'**
  String get homeDimensionStudy;

  /// No description provided for @homeDimensionSocial.
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get homeDimensionSocial;

  /// No description provided for @homeLuckyColor.
  ///
  /// In en, this message translates to:
  /// **'Lucky Color'**
  String get homeLuckyColor;

  /// No description provided for @homeLuckyNumber.
  ///
  /// In en, this message translates to:
  /// **'Lucky Number'**
  String get homeLuckyNumber;

  /// No description provided for @homeLuckyFlower.
  ///
  /// In en, this message translates to:
  /// **'Lucky Flower'**
  String get homeLuckyFlower;

  /// No description provided for @homeLuckyStone.
  ///
  /// In en, this message translates to:
  /// **'Lucky Stone'**
  String get homeLuckyStone;

  /// No description provided for @homeQuickConsult.
  ///
  /// In en, this message translates to:
  /// **'Consult'**
  String get homeQuickConsult;

  /// No description provided for @homeQuickTarot.
  ///
  /// In en, this message translates to:
  /// **'Tarot'**
  String get homeQuickTarot;

  /// No description provided for @homeQuickPhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo Read'**
  String get homeQuickPhoto;

  /// No description provided for @homeQuickChartConsult.
  ///
  /// In en, this message translates to:
  /// **'Chart Consult'**
  String get homeQuickChartConsult;

  /// No description provided for @homeQuickMyChart.
  ///
  /// In en, this message translates to:
  /// **'My Chart'**
  String get homeQuickMyChart;

  /// No description provided for @homeSceneExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore Scenarios'**
  String get homeSceneExplore;

  /// No description provided for @homeExploreMore.
  ///
  /// In en, this message translates to:
  /// **'Explore More'**
  String get homeExploreMore;

  /// No description provided for @homeExploreSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See All >'**
  String get homeExploreSeeAll;

  /// No description provided for @homeExploreKnowYourself.
  ///
  /// In en, this message translates to:
  /// **'Know Yourself'**
  String get homeExploreKnowYourself;

  /// No description provided for @homeExploreKnowYourselfSub.
  ///
  /// In en, this message translates to:
  /// **'Explore your hidden talents'**
  String get homeExploreKnowYourselfSub;

  /// No description provided for @homeExploreRelationship.
  ///
  /// In en, this message translates to:
  /// **'Your Relationship'**
  String get homeExploreRelationship;

  /// No description provided for @homeExploreRelationshipSub.
  ///
  /// In en, this message translates to:
  /// **'Deep relationship analysis'**
  String get homeExploreRelationshipSub;

  /// No description provided for @homeFortuneAdvice.
  ///
  /// In en, this message translates to:
  /// **'Do'**
  String get homeFortuneAdvice;

  /// No description provided for @homeFortuneAvoid.
  ///
  /// In en, this message translates to:
  /// **'Avoid'**
  String get homeFortuneAvoid;

  /// No description provided for @homeFortuneNoBirthData.
  ///
  /// In en, this message translates to:
  /// **'Add info to view daily fortune'**
  String get homeFortuneNoBirthData;

  /// No description provided for @homeFortuneAddInfo.
  ///
  /// In en, this message translates to:
  /// **'Add Info'**
  String get homeFortuneAddInfo;

  /// No description provided for @insightTitle.
  ///
  /// In en, this message translates to:
  /// **'Insight'**
  String get insightTitle;

  /// No description provided for @insightDeepExplore.
  ///
  /// In en, this message translates to:
  /// **'Deep Explore'**
  String get insightDeepExplore;

  /// No description provided for @insightSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get insightSeeAll;

  /// No description provided for @insightKnowYourself.
  ///
  /// In en, this message translates to:
  /// **'Know Yourself'**
  String get insightKnowYourself;

  /// No description provided for @insightKnowYourselfSub.
  ///
  /// In en, this message translates to:
  /// **'Explore your hidden talents'**
  String get insightKnowYourselfSub;

  /// No description provided for @insightExploreTarget.
  ///
  /// In en, this message translates to:
  /// **'Explore Their World'**
  String get insightExploreTarget;

  /// No description provided for @insightReadMindSub.
  ///
  /// In en, this message translates to:
  /// **'Read their inner world'**
  String get insightReadMindSub;

  /// No description provided for @insightUnderstandRelationship.
  ///
  /// In en, this message translates to:
  /// **'Understand Your Relationship'**
  String get insightUnderstandRelationship;

  /// No description provided for @insightDeepAnalysisSub.
  ///
  /// In en, this message translates to:
  /// **'Deep relationship analysis'**
  String get insightDeepAnalysisSub;

  /// No description provided for @insightExploreMore.
  ///
  /// In en, this message translates to:
  /// **'Explore More'**
  String get insightExploreMore;

  /// No description provided for @insightAnnualTrends.
  ///
  /// In en, this message translates to:
  /// **'2026 Annual Trends'**
  String get insightAnnualTrends;

  /// No description provided for @insightAnnualTrendsSub.
  ///
  /// In en, this message translates to:
  /// **'Get ahead in 2026'**
  String get insightAnnualTrendsSub;

  /// No description provided for @insightAnnualTrendsPrefill.
  ///
  /// In en, this message translates to:
  /// **'Please generate my 2026 annual trends report based on my birth chart'**
  String get insightAnnualTrendsPrefill;

  /// No description provided for @insightBirthDataRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Birth Chart Required'**
  String get insightBirthDataRequiredTitle;

  /// No description provided for @insightBirthDataRequiredMsg.
  ///
  /// In en, this message translates to:
  /// **'This feature requires your birth chart. Please set your birth date and location in your profile first.'**
  String get insightBirthDataRequiredMsg;

  /// No description provided for @insightCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get insightCancel;

  /// No description provided for @insightGoToSettings.
  ///
  /// In en, this message translates to:
  /// **'Go to Settings'**
  String get insightGoToSettings;

  /// No description provided for @insightSoulMate.
  ///
  /// In en, this message translates to:
  /// **'Soul Mate'**
  String get insightSoulMate;

  /// No description provided for @insightFindSoulMate.
  ///
  /// In en, this message translates to:
  /// **'Find your soul mate'**
  String get insightFindSoulMate;

  /// No description provided for @insightSelectFriendChart.
  ///
  /// In en, this message translates to:
  /// **'Select a friend to view chart'**
  String get insightSelectFriendChart;

  /// No description provided for @insightSelectFriendProfile.
  ///
  /// In en, this message translates to:
  /// **'Select a friend profile'**
  String get insightSelectFriendProfile;

  /// No description provided for @insightSelectFriendReport.
  ///
  /// In en, this message translates to:
  /// **'Select a friend for relationship report'**
  String get insightSelectFriendReport;

  /// No description provided for @insightSelectFriendRelationship.
  ///
  /// In en, this message translates to:
  /// **'Select a friend for relationship analysis'**
  String get insightSelectFriendRelationship;

  /// No description provided for @insightNoFriends.
  ///
  /// In en, this message translates to:
  /// **'No friend profiles yet'**
  String get insightNoFriends;

  /// No description provided for @insightAddFriend.
  ///
  /// In en, this message translates to:
  /// **'Add a Friend Profile'**
  String get insightAddFriend;

  /// No description provided for @insightLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load'**
  String get insightLoadFailed;

  /// No description provided for @reportRelationshipTitle.
  ///
  /// In en, this message translates to:
  /// **'Relationship Report'**
  String get reportRelationshipTitle;

  /// No description provided for @reportInsightTitle.
  ///
  /// In en, this message translates to:
  /// **'Insight Report'**
  String get reportInsightTitle;

  /// No description provided for @reportIncludes.
  ///
  /// In en, this message translates to:
  /// **'Report includes'**
  String get reportIncludes;

  /// No description provided for @reportMeLabel.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get reportMeLabel;

  /// No description provided for @reportMyProfile.
  ///
  /// In en, this message translates to:
  /// **'Using my profile'**
  String get reportMyProfile;

  /// No description provided for @reportGenerate.
  ///
  /// In en, this message translates to:
  /// **'Generate Report'**
  String get reportGenerate;

  /// No description provided for @reportFriendProfileSelected.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s profile selected'**
  String reportFriendProfileSelected(String name);

  /// No description provided for @reportFriendRelationship.
  ///
  /// In en, this message translates to:
  /// **'Relationship with {name}'**
  String reportFriendRelationship(String name);

  /// No description provided for @reportGenerating.
  ///
  /// In en, this message translates to:
  /// **'AI is reading the stars…'**
  String get reportGenerating;

  /// No description provided for @reportFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to generate report, please try again'**
  String get reportFailed;

  /// No description provided for @reportRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get reportRetry;

  /// No description provided for @insightQuote.
  ///
  /// In en, this message translates to:
  /// **'What you resist, persists.'**
  String get insightQuote;

  /// No description provided for @insightQuoteAuthor.
  ///
  /// In en, this message translates to:
  /// **'— Carl Jung'**
  String get insightQuoteAuthor;

  /// No description provided for @insightMyChart.
  ///
  /// In en, this message translates to:
  /// **'My Chart'**
  String get insightMyChart;

  /// No description provided for @insightSynastry.
  ///
  /// In en, this message translates to:
  /// **'Synastry'**
  String get insightSynastry;

  /// No description provided for @insightComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get insightComingSoon;

  /// No description provided for @consultTitle.
  ///
  /// In en, this message translates to:
  /// **'Consult'**
  String get consultTitle;

  /// No description provided for @consultRoomTitle.
  ///
  /// In en, this message translates to:
  /// **'Consultation Room'**
  String get consultRoomTitle;

  /// No description provided for @consultFreeAsk.
  ///
  /// In en, this message translates to:
  /// **'Free Ask'**
  String get consultFreeAsk;

  /// No description provided for @consultTarot.
  ///
  /// In en, this message translates to:
  /// **'Tarot'**
  String get consultTarot;

  /// No description provided for @consultChart.
  ///
  /// In en, this message translates to:
  /// **'Chart'**
  String get consultChart;

  /// No description provided for @consultPrompt.
  ///
  /// In en, this message translates to:
  /// **'What would you like to ask?'**
  String get consultPrompt;

  /// No description provided for @consultTarotPrompt.
  ///
  /// In en, this message translates to:
  /// **'Want to explore with tarot cards?'**
  String get consultTarotPrompt;

  /// No description provided for @consultChartPrompt.
  ///
  /// In en, this message translates to:
  /// **'Explore your natal chart mysteries'**
  String get consultChartPrompt;

  /// No description provided for @consultSubtext.
  ///
  /// In en, this message translates to:
  /// **'I will answer with the wisdom of the stars'**
  String get consultSubtext;

  /// No description provided for @consultStart.
  ///
  /// In en, this message translates to:
  /// **'Start Consultation'**
  String get consultStart;

  /// No description provided for @diaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Diary'**
  String get diaryTitle;

  /// No description provided for @diaryAddNew.
  ///
  /// In en, this message translates to:
  /// **'Add New Diary'**
  String get diaryAddNew;

  /// No description provided for @diaryEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Rainy day~ No diary entry yet today. Tap \"+\" to record what\'s happening or how you\'re feeling~'**
  String get diaryEmptyHint;

  /// No description provided for @diaryPublish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get diaryPublish;

  /// No description provided for @diaryEditHint.
  ///
  /// In en, this message translates to:
  /// **'Feel free to write down any thoughts or feelings here~ Xingjian will be your most loyal companion and listener.'**
  String get diaryEditHint;

  /// No description provided for @diaryAIName.
  ///
  /// In en, this message translates to:
  /// **'Xingjian Spirit'**
  String get diaryAIName;

  /// No description provided for @diaryYou.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get diaryYou;

  /// No description provided for @diaryReplyHint.
  ///
  /// In en, this message translates to:
  /// **'Reply to Xingjian Spirit'**
  String get diaryReplyHint;

  /// No description provided for @diaryDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Diary'**
  String get diaryDeleteTitle;

  /// No description provided for @diaryDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this diary entry? This action cannot be undone.'**
  String get diaryDeleteConfirm;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @aiDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'All content is AI-generated, for reference and entertainment only'**
  String get aiDisclaimer;

  /// No description provided for @tabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// No description provided for @tabInsight.
  ///
  /// In en, this message translates to:
  /// **'Insight'**
  String get tabInsight;

  /// No description provided for @tabConsult.
  ///
  /// In en, this message translates to:
  /// **'Consult'**
  String get tabConsult;

  /// No description provided for @tabDiary.
  ///
  /// In en, this message translates to:
  /// **'Diary'**
  String get tabDiary;

  /// No description provided for @tabProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get tabProfile;

  /// No description provided for @chartMyChart.
  ///
  /// In en, this message translates to:
  /// **'My Chart'**
  String get chartMyChart;

  /// No description provided for @chartNatal.
  ///
  /// In en, this message translates to:
  /// **'Natal'**
  String get chartNatal;

  /// No description provided for @chartTransit.
  ///
  /// In en, this message translates to:
  /// **'Transit'**
  String get chartTransit;

  /// No description provided for @chartProgression.
  ///
  /// In en, this message translates to:
  /// **'Progressions'**
  String get chartProgression;

  /// No description provided for @chartReturn.
  ///
  /// In en, this message translates to:
  /// **'Returns'**
  String get chartReturn;

  /// No description provided for @chartSynastry.
  ///
  /// In en, this message translates to:
  /// **'Synastry'**
  String get chartSynastry;

  /// No description provided for @chartSecondaryProgression.
  ///
  /// In en, this message translates to:
  /// **'Secondary'**
  String get chartSecondaryProgression;

  /// No description provided for @chartSolarArc.
  ///
  /// In en, this message translates to:
  /// **'Solar Arc'**
  String get chartSolarArc;

  /// No description provided for @chartSolarReturn.
  ///
  /// In en, this message translates to:
  /// **'Solar Return'**
  String get chartSolarReturn;

  /// No description provided for @chartLunarReturn.
  ///
  /// In en, this message translates to:
  /// **'Lunar Return'**
  String get chartLunarReturn;

  /// No description provided for @chartLocalEngine.
  ///
  /// In en, this message translates to:
  /// **'Local Engine'**
  String get chartLocalEngine;

  /// No description provided for @chartTransitDate.
  ///
  /// In en, this message translates to:
  /// **'Transit Date'**
  String get chartTransitDate;

  /// No description provided for @chartProgressionDate.
  ///
  /// In en, this message translates to:
  /// **'Progression Date'**
  String get chartProgressionDate;

  /// No description provided for @chartLunarReturnDate.
  ///
  /// In en, this message translates to:
  /// **'Target Date'**
  String get chartLunarReturnDate;

  /// No description provided for @chartCalculate.
  ///
  /// In en, this message translates to:
  /// **'Calculate'**
  String get chartCalculate;

  /// No description provided for @chartPerson1.
  ///
  /// In en, this message translates to:
  /// **'Person 1'**
  String get chartPerson1;

  /// No description provided for @chartPerson2.
  ///
  /// In en, this message translates to:
  /// **'Person 2'**
  String get chartPerson2;

  /// No description provided for @chartMe.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get chartMe;

  /// No description provided for @chartCrossAspects.
  ///
  /// In en, this message translates to:
  /// **'Cross Aspects'**
  String get chartCrossAspects;

  /// No description provided for @chartPersonName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get chartPersonName;

  /// No description provided for @chartBirthDate.
  ///
  /// In en, this message translates to:
  /// **'Birth Date'**
  String get chartBirthDate;

  /// No description provided for @chartBirthTime.
  ///
  /// In en, this message translates to:
  /// **'Birth Time'**
  String get chartBirthTime;

  /// No description provided for @chartLatitude.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get chartLatitude;

  /// No description provided for @chartLongitude.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get chartLongitude;

  /// No description provided for @chartNoBirthData.
  ///
  /// In en, this message translates to:
  /// **'Birth data required for chart calculation'**
  String get chartNoBirthData;

  /// No description provided for @chartGoToSettings.
  ///
  /// In en, this message translates to:
  /// **'Go to Settings'**
  String get chartGoToSettings;

  /// No description provided for @chartPlanet.
  ///
  /// In en, this message translates to:
  /// **'Planet'**
  String get chartPlanet;

  /// No description provided for @chartSign.
  ///
  /// In en, this message translates to:
  /// **'Sign'**
  String get chartSign;

  /// No description provided for @chartHouse.
  ///
  /// In en, this message translates to:
  /// **'House'**
  String get chartHouse;

  /// No description provided for @chartAspects.
  ///
  /// In en, this message translates to:
  /// **'Aspects'**
  String get chartAspects;

  /// No description provided for @chartHouses.
  ///
  /// In en, this message translates to:
  /// **'Houses'**
  String get chartHouses;

  /// No description provided for @chartOrb.
  ///
  /// In en, this message translates to:
  /// **'Orb'**
  String get chartOrb;

  /// No description provided for @chartApplying.
  ///
  /// In en, this message translates to:
  /// **'Applying'**
  String get chartApplying;

  /// No description provided for @chartSeparating.
  ///
  /// In en, this message translates to:
  /// **'Separating'**
  String get chartSeparating;

  /// No description provided for @profileInviteCode.
  ///
  /// In en, this message translates to:
  /// **'Invite +'**
  String get profileInviteCode;

  /// No description provided for @profileNotLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Not logged in'**
  String get profileNotLoggedIn;

  /// No description provided for @profileCompanionDays.
  ///
  /// In en, this message translates to:
  /// **'Together {count} days'**
  String profileCompanionDays(int count);

  /// No description provided for @profileMyWallet.
  ///
  /// In en, this message translates to:
  /// **'My Wallet'**
  String get profileMyWallet;

  /// No description provided for @profileMyBenefits.
  ///
  /// In en, this message translates to:
  /// **'My Benefits'**
  String get profileMyBenefits;

  /// No description provided for @profileConversationsToday.
  ///
  /// In en, this message translates to:
  /// **'Consulted {count} times today  Resets at 6:00'**
  String profileConversationsToday(int count);

  /// No description provided for @profileFreeToday.
  ///
  /// In en, this message translates to:
  /// **'Free today 1/1  Resets at 6:00'**
  String get profileFreeToday;

  /// No description provided for @profileUnlockMore.
  ///
  /// In en, this message translates to:
  /// **'Unlock more privileges'**
  String get profileUnlockMore;

  /// No description provided for @profileUpgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get profileUpgrade;

  /// No description provided for @profileArchives.
  ///
  /// In en, this message translates to:
  /// **'Archives'**
  String get profileArchives;

  /// No description provided for @profileArchivesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add friend profiles'**
  String get profileArchivesSubtitle;

  /// No description provided for @profileConsultHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get profileConsultHistory;

  /// No description provided for @profileReports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get profileReports;

  /// No description provided for @profileServicesTools.
  ///
  /// In en, this message translates to:
  /// **'Services & Tools'**
  String get profileServicesTools;

  /// No description provided for @profileTarotGallery.
  ///
  /// In en, this message translates to:
  /// **'Tarot Card Gallery'**
  String get profileTarotGallery;

  /// No description provided for @profileHelpFeedback.
  ///
  /// In en, this message translates to:
  /// **'Help & Feedback'**
  String get profileHelpFeedback;

  /// No description provided for @profileShareApp.
  ///
  /// In en, this message translates to:
  /// **'Share App'**
  String get profileShareApp;

  /// No description provided for @profileRateUs.
  ///
  /// In en, this message translates to:
  /// **'Rate Us'**
  String get profileRateUs;

  /// No description provided for @profileSettingsItem.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get profileSettingsItem;

  /// No description provided for @profileLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get profileLogout;

  /// No description provided for @conversationNewChat.
  ///
  /// In en, this message translates to:
  /// **'New Conversation'**
  String get conversationNewChat;

  /// No description provided for @conversationNoChats.
  ///
  /// In en, this message translates to:
  /// **'No conversations yet'**
  String get conversationNoChats;

  /// No description provided for @conversationEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Start a new conversation and let the stars guide you'**
  String get conversationEmptyHint;

  /// No description provided for @conversationStartConsult.
  ///
  /// In en, this message translates to:
  /// **'Start Consultation'**
  String get conversationStartConsult;

  /// No description provided for @conversationPopularTopics.
  ///
  /// In en, this message translates to:
  /// **'Popular Topics'**
  String get conversationPopularTopics;

  /// No description provided for @timeJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get timeJustNow;

  /// No description provided for @timeMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String timeMinutesAgo(int count);

  /// No description provided for @timeYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get timeYesterday;

  /// No description provided for @timeDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String timeDaysAgo(int count);

  /// No description provided for @timeHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String timeHoursAgo(int count);

  /// No description provided for @timeDateFormat.
  ///
  /// In en, this message translates to:
  /// **'{month}/{day}'**
  String timeDateFormat(int month, int day);

  /// No description provided for @transitTransitPlanet.
  ///
  /// In en, this message translates to:
  /// **'Transit Planet'**
  String get transitTransitPlanet;

  /// No description provided for @transitNatalPlanet.
  ///
  /// In en, this message translates to:
  /// **'Natal Planet'**
  String get transitNatalPlanet;

  /// No description provided for @transitHouse.
  ///
  /// In en, this message translates to:
  /// **'House'**
  String get transitHouse;

  /// No description provided for @transitExactDate.
  ///
  /// In en, this message translates to:
  /// **'Exact Date'**
  String get transitExactDate;

  /// No description provided for @transitActivePeriod.
  ///
  /// In en, this message translates to:
  /// **'Active Period'**
  String get transitActivePeriod;

  /// No description provided for @transitExactLabel.
  ///
  /// In en, this message translates to:
  /// **'Exact: {date}'**
  String transitExactLabel(String date);

  /// No description provided for @transitOrbLabel.
  ///
  /// In en, this message translates to:
  /// **'Orb: {value}'**
  String transitOrbLabel(String value);

  /// No description provided for @scenarioNotFound.
  ///
  /// In en, this message translates to:
  /// **'Scenario not found'**
  String get scenarioNotFound;

  /// No description provided for @scenarioLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load scenarios'**
  String get scenarioLoadFailed;

  /// No description provided for @scenarioNoneFound.
  ///
  /// In en, this message translates to:
  /// **'No scenarios found'**
  String get scenarioNoneFound;

  /// No description provided for @scenarioExploreSubline.
  ///
  /// In en, this message translates to:
  /// **'Explore cosmic mysteries'**
  String get scenarioExploreSubline;

  /// No description provided for @moodMonthlySummary.
  ///
  /// In en, this message translates to:
  /// **'Monthly Summary'**
  String get moodMonthlySummary;

  /// No description provided for @moodTotalEntries.
  ///
  /// In en, this message translates to:
  /// **'Total Entries'**
  String get moodTotalEntries;

  /// No description provided for @moodAverageScore.
  ///
  /// In en, this message translates to:
  /// **'Average Score'**
  String get moodAverageScore;

  /// No description provided for @moodCurrentStreak.
  ///
  /// In en, this message translates to:
  /// **'Current Streak'**
  String get moodCurrentStreak;

  /// No description provided for @moodLongestStreak.
  ///
  /// In en, this message translates to:
  /// **'Longest Streak'**
  String get moodLongestStreak;

  /// No description provided for @moodTopTag.
  ///
  /// In en, this message translates to:
  /// **'Top Tag'**
  String get moodTopTag;

  /// No description provided for @moodTrendLabel.
  ///
  /// In en, this message translates to:
  /// **'Trend'**
  String get moodTrendLabel;

  /// No description provided for @moodDaysUnit.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get moodDaysUnit;

  /// No description provided for @moodOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get moodOk;

  /// No description provided for @moodNoData.
  ///
  /// In en, this message translates to:
  /// **'No data yet'**
  String get moodNoData;

  /// No description provided for @friendNoFriends.
  ///
  /// In en, this message translates to:
  /// **'No friends yet'**
  String get friendNoFriends;

  /// No description provided for @friendNoFriendsHint.
  ///
  /// In en, this message translates to:
  /// **'Add friends to see your astrological compatibility'**
  String get friendNoFriendsHint;

  /// No description provided for @friendSynastryTitle.
  ///
  /// In en, this message translates to:
  /// **'Synastry'**
  String get friendSynastryTitle;

  /// No description provided for @chartArchivesTitle.
  ///
  /// In en, this message translates to:
  /// **'Chart Archives'**
  String get chartArchivesTitle;

  /// No description provided for @chartArchivesMyChart.
  ///
  /// In en, this message translates to:
  /// **'Your Chart'**
  String get chartArchivesMyChart;

  /// No description provided for @chartArchivesFriendChart.
  ///
  /// In en, this message translates to:
  /// **'Their Charts'**
  String get chartArchivesFriendChart;

  /// No description provided for @chartArchivesSelf.
  ///
  /// In en, this message translates to:
  /// **'Self'**
  String get chartArchivesSelf;

  /// No description provided for @chartArchivesNoData.
  ///
  /// In en, this message translates to:
  /// **'No data yet'**
  String get chartArchivesNoData;

  /// No description provided for @chartArchivesAddChart.
  ///
  /// In en, this message translates to:
  /// **'+ Add Chart Profile'**
  String get chartArchivesAddChart;

  /// No description provided for @chartArchivesNotSet.
  ///
  /// In en, this message translates to:
  /// **'Birth info not set'**
  String get chartArchivesNotSet;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @shareChartLabel.
  ///
  /// In en, this message translates to:
  /// **'Birth Chart'**
  String get shareChartLabel;

  /// No description provided for @shareHoroscopeLabel.
  ///
  /// In en, this message translates to:
  /// **'Horoscope'**
  String get shareHoroscopeLabel;

  /// No description provided for @shareTarotLabel.
  ///
  /// In en, this message translates to:
  /// **'Tarot Reading'**
  String get shareTarotLabel;

  /// No description provided for @shareSynastryLabel.
  ///
  /// In en, this message translates to:
  /// **'Synastry'**
  String get shareSynastryLabel;

  /// No description provided for @shareDefaultLabel.
  ///
  /// In en, this message translates to:
  /// **'Share Card'**
  String get shareDefaultLabel;

  /// No description provided for @breathingInhale.
  ///
  /// In en, this message translates to:
  /// **'Inhale...'**
  String get breathingInhale;

  /// No description provided for @breathingExhale.
  ///
  /// In en, this message translates to:
  /// **'Exhale...'**
  String get breathingExhale;

  /// No description provided for @accessibilitySection.
  ///
  /// In en, this message translates to:
  /// **'Accessibility'**
  String get accessibilitySection;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorGeneric;

  /// No description provided for @photoAnalysisTitle.
  ///
  /// In en, this message translates to:
  /// **'Photo Analysis'**
  String get photoAnalysisTitle;

  /// No description provided for @photoAnalysisPickImage.
  ///
  /// In en, this message translates to:
  /// **'Choose Image'**
  String get photoAnalysisPickImage;

  /// No description provided for @photoAnalysisTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get photoAnalysisTakePhoto;

  /// No description provided for @photoAnalysisGallery.
  ///
  /// In en, this message translates to:
  /// **'From Gallery'**
  String get photoAnalysisGallery;

  /// No description provided for @photoAnalysisQuestionHint.
  ///
  /// In en, this message translates to:
  /// **'What would you like to ask about this image? (optional)'**
  String get photoAnalysisQuestionHint;

  /// No description provided for @photoAnalysisDefaultQuestion.
  ///
  /// In en, this message translates to:
  /// **'Please analyze this chart image'**
  String get photoAnalysisDefaultQuestion;

  /// No description provided for @photoAnalysisSend.
  ///
  /// In en, this message translates to:
  /// **'Start Analysis'**
  String get photoAnalysisSend;

  /// No description provided for @photoAnalysisNoImage.
  ///
  /// In en, this message translates to:
  /// **'Please select or take a photo first'**
  String get photoAnalysisNoImage;

  /// No description provided for @photoAnalysisImageSelected.
  ///
  /// In en, this message translates to:
  /// **'Image selected'**
  String get photoAnalysisImageSelected;
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
