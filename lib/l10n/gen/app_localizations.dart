import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('de'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Stash'**
  String get appTitle;

  /// No description provided for @scenesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 scene} other{{count} scenes}}'**
  String scenesCount(int count);

  /// No description provided for @imagesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 image} other{{count} images}}'**
  String imagesCount(int count);

  /// No description provided for @playsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 play} other{{count} plays}}'**
  String playsCount(int count);

  /// No description provided for @savedServersCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 saved server} other{{count} saved servers}}'**
  String savedServersCount(int count);

  /// No description provided for @subStudiosCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 sub-studio} other{{count} sub-studios}}'**
  String subStudiosCount(int count);

  /// No description provided for @timeUpcoming.
  ///
  /// In en, this message translates to:
  /// **'upcoming'**
  String get timeUpcoming;

  /// No description provided for @timeJustNow.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get timeJustNow;

  /// No description provided for @timeYearsAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 year ago} other{{count} years ago}}'**
  String timeYearsAgo(int count);

  /// No description provided for @timeMonthsAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 month ago} other{{count} months ago}}'**
  String timeMonthsAgo(int count);

  /// No description provided for @timeWeeksAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 week ago} other{{count} weeks ago}}'**
  String timeWeeksAgo(int count);

  /// No description provided for @timeDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day ago} other{{count} days ago}}'**
  String timeDaysAgo(int count);

  /// No description provided for @timeHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hour ago} other{{count} hours ago}}'**
  String timeHoursAgo(int count);

  /// No description provided for @timeMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 minute ago} other{{count} minutes ago}}'**
  String timeMinutesAgo(int count);

  /// No description provided for @libraryTitle.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get libraryTitle;

  /// No description provided for @libraryScenes.
  ///
  /// In en, this message translates to:
  /// **'Scenes'**
  String get libraryScenes;

  /// No description provided for @libraryHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get libraryHistory;

  /// No description provided for @libraryWatchLater.
  ///
  /// In en, this message translates to:
  /// **'Watch later'**
  String get libraryWatchLater;

  /// No description provided for @libraryGroups.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get libraryGroups;

  /// No description provided for @libraryImages.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get libraryImages;

  /// No description provided for @libraryGalleries.
  ///
  /// In en, this message translates to:
  /// **'Galleries'**
  String get libraryGalleries;

  /// No description provided for @libraryStats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get libraryStats;

  /// No description provided for @historyEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing watched yet'**
  String get historyEmpty;

  /// No description provided for @historyEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Scenes you play show up here.'**
  String get historyEmptyHint;

  /// No description provided for @tabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// No description provided for @tabPerformers.
  ///
  /// In en, this message translates to:
  /// **'Performers'**
  String get tabPerformers;

  /// No description provided for @tabStudios.
  ///
  /// In en, this message translates to:
  /// **'Studios'**
  String get tabStudios;

  /// No description provided for @tabLibrary.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get tabLibrary;

  /// No description provided for @tabWatchLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get tabWatchLater;

  /// No description provided for @tabTags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tabTags;

  /// No description provided for @tabSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get tabSearch;

  /// No description provided for @tabSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get tabSettings;

  /// No description provided for @emptyDefault.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get emptyDefault;

  /// No description provided for @loadMoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load more – tap to retry'**
  String get loadMoreFailed;

  /// No description provided for @channelUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get channelUnknown;

  /// No description provided for @sceneMenuPlay.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get sceneMenuPlay;

  /// No description provided for @watchLaterRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove from Watch later'**
  String get watchLaterRemove;

  /// No description provided for @watchLaterSave.
  ///
  /// In en, this message translates to:
  /// **'Save to Watch later'**
  String get watchLaterSave;

  /// No description provided for @editDetails.
  ///
  /// In en, this message translates to:
  /// **'Edit details'**
  String get editDetails;

  /// No description provided for @goTo.
  ///
  /// In en, this message translates to:
  /// **'Go to {name}'**
  String goTo(String name);

  /// No description provided for @scenesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No scenes found'**
  String get scenesEmpty;

  /// No description provided for @savedFilterUnsupported.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\": ignored unsupported criteria ({criteria})'**
  String savedFilterUnsupported(String name, String criteria);

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @filterScenes.
  ///
  /// In en, this message translates to:
  /// **'Filter scenes'**
  String get filterScenes;

  /// No description provided for @filterTagsAllOf.
  ///
  /// In en, this message translates to:
  /// **'Tags (all of)'**
  String get filterTagsAllOf;

  /// No description provided for @searchTags.
  ///
  /// In en, this message translates to:
  /// **'Search tags'**
  String get searchTags;

  /// No description provided for @minimumRating.
  ///
  /// In en, this message translates to:
  /// **'Minimum rating'**
  String get minimumRating;

  /// No description provided for @ratingAny.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get ratingAny;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @quality.
  ///
  /// In en, this message translates to:
  /// **'Quality'**
  String get quality;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorTitle;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @sortRecentlyAdded.
  ///
  /// In en, this message translates to:
  /// **'Recently added'**
  String get sortRecentlyAdded;

  /// No description provided for @sortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get sortNewest;

  /// No description provided for @sortShuffle.
  ///
  /// In en, this message translates to:
  /// **'Shuffle'**
  String get sortShuffle;

  /// No description provided for @sortTopRated.
  ///
  /// In en, this message translates to:
  /// **'Top rated'**
  String get sortTopRated;

  /// No description provided for @sortMostPlayed.
  ///
  /// In en, this message translates to:
  /// **'Most played'**
  String get sortMostPlayed;

  /// No description provided for @sortRecentlyWatched.
  ///
  /// In en, this message translates to:
  /// **'Recently watched'**
  String get sortRecentlyWatched;

  /// No description provided for @sortAlphabetical.
  ///
  /// In en, this message translates to:
  /// **'A–Z'**
  String get sortAlphabetical;

  /// No description provided for @sortGroupOrder.
  ///
  /// In en, this message translates to:
  /// **'Group order'**
  String get sortGroupOrder;

  /// No description provided for @sortName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get sortName;

  /// No description provided for @sortMostScenes.
  ///
  /// In en, this message translates to:
  /// **'Most scenes'**
  String get sortMostScenes;

  /// No description provided for @sortFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get sortFavorites;

  /// No description provided for @sortFileName.
  ///
  /// In en, this message translates to:
  /// **'File name'**
  String get sortFileName;

  /// No description provided for @sortMostImages.
  ///
  /// In en, this message translates to:
  /// **'Most images'**
  String get sortMostImages;

  /// No description provided for @durationAny.
  ///
  /// In en, this message translates to:
  /// **'Any length'**
  String get durationAny;

  /// No description provided for @durationShort.
  ///
  /// In en, this message translates to:
  /// **'Under 10 min'**
  String get durationShort;

  /// No description provided for @durationMedium.
  ///
  /// In en, this message translates to:
  /// **'10–30 min'**
  String get durationMedium;

  /// No description provided for @durationLong.
  ///
  /// In en, this message translates to:
  /// **'Over 30 min'**
  String get durationLong;

  /// No description provided for @resolutionAny.
  ///
  /// In en, this message translates to:
  /// **'Any quality'**
  String get resolutionAny;

  /// No description provided for @galleriesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 gallery} other{{count} galleries}}'**
  String galleriesCount(int count);

  /// No description provided for @galleriesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No galleries yet'**
  String get galleriesEmpty;

  /// No description provided for @galleriesEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Add image folders or zip files to your Stash library.'**
  String get galleriesEmptyHint;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @groupsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No groups yet'**
  String get groupsEmpty;

  /// No description provided for @groupsEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Groups need Stash v0.27 or newer.'**
  String get groupsEmptyHint;

  /// No description provided for @groupLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load the group: {error}'**
  String groupLoadFailed(String error);

  /// No description provided for @groupNoScenes.
  ///
  /// In en, this message translates to:
  /// **'This group has no scenes'**
  String get groupNoScenes;

  /// No description provided for @playAll.
  ///
  /// In en, this message translates to:
  /// **'Play all'**
  String get playAll;

  /// No description provided for @imagesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No images yet'**
  String get imagesEmpty;

  /// No description provided for @statsLibrary.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get statsLibrary;

  /// No description provided for @statsScenes.
  ///
  /// In en, this message translates to:
  /// **'Scenes'**
  String get statsScenes;

  /// No description provided for @statsImages.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get statsImages;

  /// No description provided for @statsGalleries.
  ///
  /// In en, this message translates to:
  /// **'Galleries'**
  String get statsGalleries;

  /// No description provided for @statsPerformers.
  ///
  /// In en, this message translates to:
  /// **'Performers'**
  String get statsPerformers;

  /// No description provided for @statsStudios.
  ///
  /// In en, this message translates to:
  /// **'Studios'**
  String get statsStudios;

  /// No description provided for @statsTags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get statsTags;

  /// No description provided for @statsStorage.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get statsStorage;

  /// No description provided for @statsTotalSize.
  ///
  /// In en, this message translates to:
  /// **'Total size'**
  String get statsTotalSize;

  /// No description provided for @statsAverageScene.
  ///
  /// In en, this message translates to:
  /// **'Average scene'**
  String get statsAverageScene;

  /// No description provided for @statsWatching.
  ///
  /// In en, this message translates to:
  /// **'Watching'**
  String get statsWatching;

  /// No description provided for @statsPlays.
  ///
  /// In en, this message translates to:
  /// **'Plays'**
  String get statsPlays;

  /// No description provided for @statsWatchTime.
  ///
  /// In en, this message translates to:
  /// **'Watch time'**
  String get statsWatchTime;

  /// No description provided for @statsScenesWatched.
  ///
  /// In en, this message translates to:
  /// **'Scenes watched'**
  String get statsScenesWatched;

  /// No description provided for @statsOCount.
  ///
  /// In en, this message translates to:
  /// **'O-count'**
  String get statsOCount;

  /// No description provided for @watchLaterEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing saved yet'**
  String get watchLaterEmpty;

  /// No description provided for @watchLaterEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Tap \"Later\" on a scene to watch it afterwards.'**
  String get watchLaterEmptyHint;

  /// No description provided for @favoriteUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t update favorite: {error}'**
  String favoriteUpdateFailed(String error);

  /// No description provided for @favorited.
  ///
  /// In en, this message translates to:
  /// **'Favorited'**
  String get favorited;

  /// No description provided for @favorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get favorite;

  /// No description provided for @favoriteRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get favoriteRemove;

  /// No description provided for @favoriteAdd.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get favoriteAdd;

  /// No description provided for @ageYears.
  ///
  /// In en, this message translates to:
  /// **'{age} years'**
  String ageYears(int age);

  /// No description provided for @performersTitle.
  ///
  /// In en, this message translates to:
  /// **'Performers'**
  String get performersTitle;

  /// No description provided for @performersEmpty.
  ///
  /// In en, this message translates to:
  /// **'No performers found'**
  String get performersEmpty;

  /// No description provided for @partOf.
  ///
  /// In en, this message translates to:
  /// **'Part of {name}'**
  String partOf(String name);

  /// No description provided for @includeSubStudios.
  ///
  /// In en, this message translates to:
  /// **'Include sub-studios'**
  String get includeSubStudios;

  /// No description provided for @subStudios.
  ///
  /// In en, this message translates to:
  /// **'Sub-studios'**
  String get subStudios;

  /// No description provided for @studiosTitle.
  ///
  /// In en, this message translates to:
  /// **'Studios'**
  String get studiosTitle;

  /// No description provided for @studiosEmpty.
  ///
  /// In en, this message translates to:
  /// **'No studios yet'**
  String get studiosEmpty;

  /// No description provided for @studiosEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Studios appear here once scenes in Stash have one.'**
  String get studiosEmptyHint;

  /// No description provided for @newTag.
  ///
  /// In en, this message translates to:
  /// **'New tag'**
  String get newTag;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @tagCreateFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t create tag: {error}'**
  String tagCreateFailed(String error);

  /// No description provided for @tagsSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save tags: {error}'**
  String tagsSaveFailed(String error);

  /// No description provided for @tagsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tagsTitle;

  /// No description provided for @tagsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No tags yet'**
  String get tagsEmpty;

  /// No description provided for @tagAddOrCreate.
  ///
  /// In en, this message translates to:
  /// **'Add or create a tag'**
  String get tagAddOrCreate;

  /// No description provided for @tagCreate.
  ///
  /// In en, this message translates to:
  /// **'Create #{name}'**
  String tagCreate(String name);

  /// No description provided for @tagsSave.
  ///
  /// In en, this message translates to:
  /// **'Save tags'**
  String get tagsSave;

  /// No description provided for @tagsEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Create one with \"New tag\".'**
  String get tagsEmptyHint;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @continueWatching.
  ///
  /// In en, this message translates to:
  /// **'Continue watching'**
  String get continueWatching;

  /// No description provided for @newFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'New from favorites'**
  String get newFromFavorites;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search Stash'**
  String get searchHint;

  /// No description provided for @searchNoScenes.
  ///
  /// In en, this message translates to:
  /// **'No scenes match \"{term}\"'**
  String searchNoScenes(String term);

  /// No description provided for @searchNoScenesHint.
  ///
  /// In en, this message translates to:
  /// **'Try other words or check the spelling.'**
  String get searchNoScenesHint;

  /// No description provided for @recentSearches.
  ///
  /// In en, this message translates to:
  /// **'Recent searches'**
  String get recentSearches;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @popularTags.
  ///
  /// In en, this message translates to:
  /// **'Popular tags'**
  String get popularTags;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @searchIntro.
  ///
  /// In en, this message translates to:
  /// **'Search scenes and performers'**
  String get searchIntro;

  /// No description provided for @addServer.
  ///
  /// In en, this message translates to:
  /// **'Add server'**
  String get addServer;

  /// No description provided for @connectToStash.
  ///
  /// In en, this message translates to:
  /// **'Connect to Stash'**
  String get connectToStash;

  /// No description provided for @loginIntro.
  ///
  /// In en, this message translates to:
  /// **'Enter the address of your Stash server, e.g. http://192.168.1.10:9999'**
  String get loginIntro;

  /// No description provided for @savedServers.
  ///
  /// In en, this message translates to:
  /// **'Saved servers'**
  String get savedServers;

  /// No description provided for @orAddAnotherServer.
  ///
  /// In en, this message translates to:
  /// **'Or add another server'**
  String get orAddAnotherServer;

  /// No description provided for @nameOptional.
  ///
  /// In en, this message translates to:
  /// **'Name (optional)'**
  String get nameOptional;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Home'**
  String get nameHint;

  /// No description provided for @serverUrl.
  ///
  /// In en, this message translates to:
  /// **'Server URL'**
  String get serverUrl;

  /// No description provided for @serverUrlInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid http(s) URL'**
  String get serverUrlInvalid;

  /// No description provided for @apiKeyOptional.
  ///
  /// In en, this message translates to:
  /// **'API key (optional)'**
  String get apiKeyOptional;

  /// No description provided for @apiKeyHelper.
  ///
  /// In en, this message translates to:
  /// **'Required if your server has a password. Stash → Settings → Security.'**
  String get apiKeyHelper;

  /// No description provided for @connect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// No description provided for @removeServerTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove \"{name}\"?'**
  String removeServerTitle(String name);

  /// No description provided for @removeServerBody.
  ///
  /// In en, this message translates to:
  /// **'Its URL and API key, watch later list and search history are removed from this device.'**
  String get removeServerBody;

  /// No description provided for @servers.
  ///
  /// In en, this message translates to:
  /// **'Servers'**
  String get servers;

  /// No description provided for @serverOptions.
  ///
  /// In en, this message translates to:
  /// **'Server options'**
  String get serverOptions;

  /// No description provided for @rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// No description provided for @renameServer.
  ///
  /// In en, this message translates to:
  /// **'Rename server'**
  String get renameServer;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @castDevice.
  ///
  /// In en, this message translates to:
  /// **'Cast device'**
  String get castDevice;

  /// No description provided for @cast.
  ///
  /// In en, this message translates to:
  /// **'Cast'**
  String get cast;

  /// No description provided for @castingTo.
  ///
  /// In en, this message translates to:
  /// **'Casting to {device}'**
  String castingTo(String device);

  /// No description provided for @stopCasting.
  ///
  /// In en, this message translates to:
  /// **'Stop casting'**
  String get stopCasting;

  /// No description provided for @castTo.
  ///
  /// In en, this message translates to:
  /// **'Cast to'**
  String get castTo;

  /// No description provided for @castSearching.
  ///
  /// In en, this message translates to:
  /// **'Searching for devices…'**
  String get castSearching;

  /// No description provided for @castSearchingHint.
  ///
  /// In en, this message translates to:
  /// **'Chromecast and the phone must be on the same Wi-Fi.'**
  String get castSearchingHint;

  /// No description provided for @castConnectFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t connect to {device}: {error}'**
  String castConnectFailed(String device, String error);

  /// No description provided for @minimize.
  ///
  /// In en, this message translates to:
  /// **'Minimize'**
  String get minimize;

  /// No description provided for @back10.
  ///
  /// In en, this message translates to:
  /// **'Back 10 s'**
  String get back10;

  /// No description provided for @forward10.
  ///
  /// In en, this message translates to:
  /// **'Forward 10 s'**
  String get forward10;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @navBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Navigation bar'**
  String get navBarTitle;

  /// No description provided for @navBarIntro.
  ///
  /// In en, this message translates to:
  /// **'Choose up to {max} tabs and drag them into order. The first tab opens when the app starts.'**
  String navBarIntro(int max);

  /// No description provided for @navBarAlwaysShown.
  ///
  /// In en, this message translates to:
  /// **'Always shown'**
  String get navBarAlwaysShown;

  /// No description provided for @navBarAtLeast.
  ///
  /// In en, this message translates to:
  /// **'At least {count} tabs'**
  String navBarAtLeast(int count);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @sectionServer.
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get sectionServer;

  /// No description provided for @stashVersion.
  ///
  /// In en, this message translates to:
  /// **'Stash {version}'**
  String stashVersion(String version);

  /// No description provided for @unknownVersion.
  ///
  /// In en, this message translates to:
  /// **'unknown version'**
  String get unknownVersion;

  /// No description provided for @notReachable.
  ///
  /// In en, this message translates to:
  /// **'Not reachable'**
  String get notReachable;

  /// No description provided for @checking.
  ///
  /// In en, this message translates to:
  /// **'Checking…'**
  String get checking;

  /// No description provided for @switchServer.
  ///
  /// In en, this message translates to:
  /// **'Switch server'**
  String get switchServer;

  /// No description provided for @apiKey.
  ///
  /// In en, this message translates to:
  /// **'API key'**
  String get apiKey;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @isSet.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get isSet;

  /// No description provided for @sectionAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get sectionAppearance;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @accentColor.
  ///
  /// In en, this message translates to:
  /// **'Accent color'**
  String get accentColor;

  /// No description provided for @accentColorLabel.
  ///
  /// In en, this message translates to:
  /// **'{name} accent color'**
  String accentColorLabel(String name);

  /// No description provided for @colorRed.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get colorRed;

  /// No description provided for @colorPink.
  ///
  /// In en, this message translates to:
  /// **'Pink'**
  String get colorPink;

  /// No description provided for @colorPurple.
  ///
  /// In en, this message translates to:
  /// **'Purple'**
  String get colorPurple;

  /// No description provided for @colorIndigo.
  ///
  /// In en, this message translates to:
  /// **'Indigo'**
  String get colorIndigo;

  /// No description provided for @colorBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get colorBlue;

  /// No description provided for @colorTeal.
  ///
  /// In en, this message translates to:
  /// **'Teal'**
  String get colorTeal;

  /// No description provided for @colorGreen.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get colorGreen;

  /// No description provided for @colorOrange.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get colorOrange;

  /// No description provided for @colorAmber.
  ///
  /// In en, this message translates to:
  /// **'Amber'**
  String get colorAmber;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get languageSystem;

  /// No description provided for @sectionPlayback.
  ///
  /// In en, this message translates to:
  /// **'Playback'**
  String get sectionPlayback;

  /// No description provided for @preferredQuality.
  ///
  /// In en, this message translates to:
  /// **'Preferred quality'**
  String get preferredQuality;

  /// No description provided for @preferredQualityDefault.
  ///
  /// In en, this message translates to:
  /// **'Original file – change it via ⚙ in the player'**
  String get preferredQualityDefault;

  /// No description provided for @sectionPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy & security'**
  String get sectionPrivacy;

  /// No description provided for @removeThisServer.
  ///
  /// In en, this message translates to:
  /// **'Remove this server'**
  String get removeThisServer;

  /// No description provided for @lockImmediately.
  ///
  /// In en, this message translates to:
  /// **'Immediately'**
  String get lockImmediately;

  /// No description provided for @lockAfterMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{After 1 minute} other{After {count} minutes}}'**
  String lockAfterMinutes(int count);

  /// No description provided for @appLock.
  ///
  /// In en, this message translates to:
  /// **'App lock'**
  String get appLock;

  /// No description provided for @appLockSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ask for a PIN when opening the app'**
  String get appLockSubtitle;

  /// No description provided for @unlockBiometric.
  ///
  /// In en, this message translates to:
  /// **'Unlock with Face ID / fingerprint'**
  String get unlockBiometric;

  /// No description provided for @lockNow.
  ///
  /// In en, this message translates to:
  /// **'Lock'**
  String get lockNow;

  /// No description provided for @changePin.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get changePin;

  /// No description provided for @hideInSwitcher.
  ///
  /// In en, this message translates to:
  /// **'Hide in app switcher'**
  String get hideInSwitcher;

  /// No description provided for @hideInSwitcherSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Covers the app in the recent apps view. On Android this also blocks screenshots.'**
  String get hideInSwitcherSubtitle;

  /// No description provided for @appIcon.
  ///
  /// In en, this message translates to:
  /// **'App icon'**
  String get appIcon;

  /// No description provided for @appIconHint.
  ///
  /// In en, this message translates to:
  /// **'On Android the name on the home screen changes too and the launcher may need a moment. On iOS only the icon changes and the system shows a confirmation.'**
  String get appIconHint;

  /// No description provided for @appIconFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t change the icon: {error}'**
  String appIconFailed(String error);

  /// No description provided for @appIconStash.
  ///
  /// In en, this message translates to:
  /// **'Stash'**
  String get appIconStash;

  /// No description provided for @appIconNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get appIconNotes;

  /// No description provided for @appIconCalculator.
  ///
  /// In en, this message translates to:
  /// **'Calculator'**
  String get appIconCalculator;

  /// No description provided for @unlockReason.
  ///
  /// In en, this message translates to:
  /// **'Unlock Stash'**
  String get unlockReason;

  /// No description provided for @enterPin.
  ///
  /// In en, this message translates to:
  /// **'Enter PIN'**
  String get enterPin;

  /// No description provided for @choosePin.
  ///
  /// In en, this message translates to:
  /// **'Choose a PIN'**
  String get choosePin;

  /// No description provided for @repeatPin.
  ///
  /// In en, this message translates to:
  /// **'Repeat the PIN'**
  String get repeatPin;

  /// No description provided for @enterYourPin.
  ///
  /// In en, this message translates to:
  /// **'Enter your PIN'**
  String get enterYourPin;

  /// No description provided for @streamOriginal.
  ///
  /// In en, this message translates to:
  /// **'Original file'**
  String get streamOriginal;

  /// No description provided for @streamAdaptive.
  ///
  /// In en, this message translates to:
  /// **'Adaptive streaming'**
  String get streamAdaptive;

  /// No description provided for @streamTranscoded.
  ///
  /// In en, this message translates to:
  /// **'Transcoded – seeking may be limited'**
  String get streamTranscoded;

  /// No description provided for @noAlternativeStreams.
  ///
  /// In en, this message translates to:
  /// **'No alternative streams available'**
  String get noAlternativeStreams;

  /// No description provided for @streamsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load streams'**
  String get streamsLoadFailed;

  /// No description provided for @chapters.
  ///
  /// In en, this message translates to:
  /// **'Chapters'**
  String get chapters;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @upNextEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing else to watch here'**
  String get upNextEmpty;

  /// No description provided for @moreFrom.
  ///
  /// In en, this message translates to:
  /// **'More from {name}'**
  String moreFrom(String name);

  /// No description provided for @upNext.
  ///
  /// In en, this message translates to:
  /// **'Up next'**
  String get upNext;

  /// No description provided for @addTags.
  ///
  /// In en, this message translates to:
  /// **'Add tags'**
  String get addTags;

  /// No description provided for @editTags.
  ///
  /// In en, this message translates to:
  /// **'Edit tags'**
  String get editTags;

  /// No description provided for @showLess.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get showLess;

  /// No description provided for @showMore.
  ///
  /// In en, this message translates to:
  /// **'...more'**
  String get showMore;

  /// No description provided for @saveFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save: {error}'**
  String saveFailed(String error);

  /// No description provided for @removeRating.
  ///
  /// In en, this message translates to:
  /// **'Remove rating'**
  String get removeRating;

  /// No description provided for @rateStars.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Rate 1 star} other{Rate {count} stars}}'**
  String rateStars(int count);

  /// No description provided for @addO.
  ///
  /// In en, this message translates to:
  /// **'Add O'**
  String get addO;

  /// No description provided for @oCountValue.
  ///
  /// In en, this message translates to:
  /// **'O-count: {count}'**
  String oCountValue(int count);

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @editSceneDetails.
  ///
  /// In en, this message translates to:
  /// **'Edit scene details'**
  String get editSceneDetails;

  /// No description provided for @marker.
  ///
  /// In en, this message translates to:
  /// **'Marker'**
  String get marker;

  /// No description provided for @addMarkerHere.
  ///
  /// In en, this message translates to:
  /// **'Add a marker at the current position'**
  String get addMarkerHere;

  /// No description provided for @markerAdded.
  ///
  /// In en, this message translates to:
  /// **'Marker added at {time}'**
  String markerAdded(String time);

  /// No description provided for @markerAddFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t add marker: {error}'**
  String markerAddFailed(String error);

  /// No description provided for @addMarkerAt.
  ///
  /// In en, this message translates to:
  /// **'Add marker at {time}'**
  String addMarkerAt(String time);

  /// No description provided for @titleOptional.
  ///
  /// In en, this message translates to:
  /// **'Title (optional)'**
  String get titleOptional;

  /// No description provided for @primaryTagRequired.
  ///
  /// In en, this message translates to:
  /// **'Primary tag (required)'**
  String get primaryTagRequired;

  /// No description provided for @addMarker.
  ///
  /// In en, this message translates to:
  /// **'Add marker'**
  String get addMarker;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @exitFullscreen.
  ///
  /// In en, this message translates to:
  /// **'Exit fullscreen'**
  String get exitFullscreen;

  /// No description provided for @fullscreen.
  ///
  /// In en, this message translates to:
  /// **'Fullscreen'**
  String get fullscreen;

  /// No description provided for @clearField.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearField;

  /// No description provided for @searchStudios.
  ///
  /// In en, this message translates to:
  /// **'Search studios'**
  String get searchStudios;

  /// No description provided for @searchPerformers.
  ///
  /// In en, this message translates to:
  /// **'Search performers'**
  String get searchPerformers;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @editScene.
  ///
  /// In en, this message translates to:
  /// **'Edit scene'**
  String get editScene;

  /// No description provided for @fieldCover.
  ///
  /// In en, this message translates to:
  /// **'Cover'**
  String get fieldCover;

  /// No description provided for @fieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get fieldTitle;

  /// No description provided for @fieldDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get fieldDetails;

  /// No description provided for @fieldDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get fieldDate;

  /// No description provided for @fieldStudio.
  ///
  /// In en, this message translates to:
  /// **'Studio'**
  String get fieldStudio;

  /// No description provided for @fieldPerformers.
  ///
  /// In en, this message translates to:
  /// **'Performers'**
  String get fieldPerformers;

  /// No description provided for @organized.
  ///
  /// In en, this message translates to:
  /// **'Organized'**
  String get organized;

  /// No description provided for @organizedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Metadata is complete'**
  String get organizedSubtitle;

  /// No description provided for @genderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get genderFemale;

  /// No description provided for @genderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// No description provided for @genderTransFemale.
  ///
  /// In en, this message translates to:
  /// **'Trans female'**
  String get genderTransFemale;

  /// No description provided for @genderTransMale.
  ///
  /// In en, this message translates to:
  /// **'Trans male'**
  String get genderTransMale;

  /// No description provided for @genderIntersex.
  ///
  /// In en, this message translates to:
  /// **'Intersex'**
  String get genderIntersex;

  /// No description provided for @genderNonBinary.
  ///
  /// In en, this message translates to:
  /// **'Non-binary'**
  String get genderNonBinary;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'A name is required'**
  String get nameRequired;

  /// No description provided for @editPerformer.
  ///
  /// In en, this message translates to:
  /// **'Edit performer'**
  String get editPerformer;

  /// No description provided for @fieldImage.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get fieldImage;

  /// No description provided for @fieldName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get fieldName;

  /// No description provided for @fieldDisambiguation.
  ///
  /// In en, this message translates to:
  /// **'Disambiguation'**
  String get fieldDisambiguation;

  /// No description provided for @fieldGender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get fieldGender;

  /// No description provided for @fieldBirthdate.
  ///
  /// In en, this message translates to:
  /// **'Birthdate'**
  String get fieldBirthdate;

  /// No description provided for @fieldCountryCode.
  ///
  /// In en, this message translates to:
  /// **'Country code'**
  String get fieldCountryCode;

  /// No description provided for @countryCodeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. DE'**
  String get countryCodeHint;

  /// No description provided for @editStudio.
  ///
  /// In en, this message translates to:
  /// **'Edit studio'**
  String get editStudio;

  /// No description provided for @fieldLogo.
  ///
  /// In en, this message translates to:
  /// **'Logo'**
  String get fieldLogo;

  /// No description provided for @fieldParentStudio.
  ///
  /// In en, this message translates to:
  /// **'Parent studio'**
  String get fieldParentStudio;

  /// No description provided for @studioOwnParent.
  ///
  /// In en, this message translates to:
  /// **'A studio can\'t be its own parent'**
  String get studioOwnParent;

  /// No description provided for @fieldWebsite.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get fieldWebsite;

  /// No description provided for @editTag.
  ///
  /// In en, this message translates to:
  /// **'Edit tag'**
  String get editTag;

  /// No description provided for @fieldDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get fieldDescription;

  /// No description provided for @editGallery.
  ///
  /// In en, this message translates to:
  /// **'Edit gallery'**
  String get editGallery;

  /// No description provided for @invalidUrl.
  ///
  /// In en, this message translates to:
  /// **'That is not a valid URL'**
  String get invalidUrl;

  /// No description provided for @choosePhoto.
  ///
  /// In en, this message translates to:
  /// **'Choose photo'**
  String get choosePhoto;

  /// No description provided for @fromUrl.
  ///
  /// In en, this message translates to:
  /// **'From URL'**
  String get fromUrl;

  /// No description provided for @keepCurrentImage.
  ///
  /// In en, this message translates to:
  /// **'Keep current image'**
  String get keepCurrentImage;

  /// No description provided for @imageFromUrl.
  ///
  /// In en, this message translates to:
  /// **'Image from URL'**
  String get imageFromUrl;

  /// No description provided for @use.
  ///
  /// In en, this message translates to:
  /// **'Use'**
  String get use;

  /// No description provided for @enterFullUrl.
  ///
  /// In en, this message translates to:
  /// **'Enter a full URL, e.g. https://…'**
  String get enterFullUrl;

  /// No description provided for @urls.
  ///
  /// In en, this message translates to:
  /// **'URLs'**
  String get urls;

  /// No description provided for @removeUrl.
  ///
  /// In en, this message translates to:
  /// **'Remove URL'**
  String get removeUrl;

  /// No description provided for @addUrl.
  ///
  /// In en, this message translates to:
  /// **'Add URL'**
  String get addUrl;

  /// No description provided for @errorUnreachable.
  ///
  /// In en, this message translates to:
  /// **'Could not reach the server: {detail}'**
  String errorUnreachable(String detail);

  /// No description provided for @errorUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Not authorized – check the API key.'**
  String get errorUnauthorized;

  /// No description provided for @errorNotReady.
  ///
  /// In en, this message translates to:
  /// **'Server is reachable but not ready (status: {status}).'**
  String errorNotReady(String status);

  /// No description provided for @errorNotFound.
  ///
  /// In en, this message translates to:
  /// **'Not found.'**
  String get errorNotFound;

  /// No description provided for @errorNotSaved.
  ///
  /// In en, this message translates to:
  /// **'Nothing was saved.'**
  String get errorNotSaved;

  /// No description provided for @navBarCount.
  ///
  /// In en, this message translates to:
  /// **'{count} of {max} tabs chosen'**
  String navBarCount(int count, int max);

  /// No description provided for @fileInfo.
  ///
  /// In en, this message translates to:
  /// **'File info'**
  String get fileInfo;

  /// No description provided for @fileInfoFiles.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{File info} other{File info ({count} files)}}'**
  String fileInfoFiles(int count);

  /// No description provided for @fileName.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get fileName;

  /// No description provided for @filePath.
  ///
  /// In en, this message translates to:
  /// **'Path'**
  String get filePath;

  /// No description provided for @fileSize.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get fileSize;

  /// No description provided for @fileFormat.
  ///
  /// In en, this message translates to:
  /// **'Format'**
  String get fileFormat;

  /// No description provided for @fileResolution.
  ///
  /// In en, this message translates to:
  /// **'Resolution'**
  String get fileResolution;

  /// No description provided for @fileDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get fileDuration;

  /// No description provided for @fileVideoCodec.
  ///
  /// In en, this message translates to:
  /// **'Video codec'**
  String get fileVideoCodec;

  /// No description provided for @fileAudioCodec.
  ///
  /// In en, this message translates to:
  /// **'Audio codec'**
  String get fileAudioCodec;

  /// No description provided for @fileFrameRate.
  ///
  /// In en, this message translates to:
  /// **'Frame rate'**
  String get fileFrameRate;

  /// No description provided for @fileBitRate.
  ///
  /// In en, this message translates to:
  /// **'Bit rate'**
  String get fileBitRate;

  /// No description provided for @fileModified.
  ///
  /// In en, this message translates to:
  /// **'Modified'**
  String get fileModified;

  /// No description provided for @copyPath.
  ///
  /// In en, this message translates to:
  /// **'Copy path'**
  String get copyPath;

  /// No description provided for @pathCopied.
  ///
  /// In en, this message translates to:
  /// **'Path copied'**
  String get pathCopied;

  /// No description provided for @framesPerSecond.
  ///
  /// In en, this message translates to:
  /// **'{fps} fps'**
  String framesPerSecond(String fps);

  /// No description provided for @megabitsPerSecond.
  ///
  /// In en, this message translates to:
  /// **'{rate} Mbit/s'**
  String megabitsPerSecond(String rate);
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
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
