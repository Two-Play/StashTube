// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Stashy';

  @override
  String scenesCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString scenes',
      one: '1 scene',
    );
    return '$_temp0';
  }

  @override
  String imagesCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString images',
      one: '1 image',
    );
    return '$_temp0';
  }

  @override
  String playsCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString plays',
      one: '1 play',
      zero: 'No plays',
    );
    return '$_temp0';
  }

  @override
  String savedServersCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString saved servers',
      one: '1 saved server',
    );
    return '$_temp0';
  }

  @override
  String subStudiosCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString sub-studios',
      one: '1 sub-studio',
    );
    return '$_temp0';
  }

  @override
  String get timeUpcoming => 'upcoming';

  @override
  String get timeJustNow => 'just now';

  @override
  String timeYearsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count years ago',
      one: '1 year ago',
    );
    return '$_temp0';
  }

  @override
  String timeMonthsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count months ago',
      one: '1 month ago',
    );
    return '$_temp0';
  }

  @override
  String timeWeeksAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count weeks ago',
      one: '1 week ago',
    );
    return '$_temp0';
  }

  @override
  String timeDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String timeHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours ago',
      one: '1 hour ago',
    );
    return '$_temp0';
  }

  @override
  String timeMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes ago',
      one: '1 minute ago',
    );
    return '$_temp0';
  }

  @override
  String get libraryTitle => 'Library';

  @override
  String get libraryScenes => 'Scenes';

  @override
  String get libraryHistory => 'History';

  @override
  String get libraryWatchLater => 'Watch later';

  @override
  String get libraryGroups => 'Groups';

  @override
  String get libraryImages => 'Images';

  @override
  String get libraryGalleries => 'Galleries';

  @override
  String get libraryStats => 'Stats';

  @override
  String get historyEmpty => 'Nothing watched yet';

  @override
  String get historyEmptyHint => 'Scenes you play show up here.';

  @override
  String get tabHome => 'Home';

  @override
  String get tabPerformers => 'Performers';

  @override
  String get tabStudios => 'Studios';

  @override
  String get tabLibrary => 'Library';

  @override
  String get tabWatchLater => 'Later';

  @override
  String get tabTags => 'Tags';

  @override
  String get tabSearch => 'Search';

  @override
  String get emptyDefault => 'Nothing here yet';

  @override
  String get loadMoreFailed => 'Couldn\'t load more – tap to retry';

  @override
  String pageOf(int page, int count) {
    return 'Page $page of $count';
  }

  @override
  String get pageLoadFailed => 'Couldn\'t load the page – try again';

  @override
  String get firstPage => 'First page';

  @override
  String get previousPage => 'Previous page';

  @override
  String get nextPage => 'Next page';

  @override
  String get lastPage => 'Last page';

  @override
  String get goToPage => 'Go to page';

  @override
  String pageRange(int count) {
    return '1–$count';
  }

  @override
  String get go => 'Go';

  @override
  String get listPaging => 'Long lists';

  @override
  String get pagingInfinite => 'Infinite scrolling';

  @override
  String get pagingPages => 'Pages';

  @override
  String get channelUnknown => 'Unknown';

  @override
  String get sceneMenuPlay => 'Play';

  @override
  String get watchLaterRemove => 'Remove from Watch later';

  @override
  String get watchLaterSave => 'Save to Watch later';

  @override
  String get editDetails => 'Edit details';

  @override
  String goTo(String name) {
    return 'Go to $name';
  }

  @override
  String get scenesEmpty => 'No scenes found';

  @override
  String savedFilterUnsupported(String name, String criteria) {
    return '\"$name\": ignored unsupported criteria ($criteria)';
  }

  @override
  String get filter => 'Filter';

  @override
  String get filterScenes => 'Filter scenes';

  @override
  String get filterImages => 'Filter images';

  @override
  String get filterTagsAllOf => 'Tags (all of)';

  @override
  String get searchTags => 'Search tags';

  @override
  String get minimumRating => 'Minimum rating';

  @override
  String get ratingAny => 'Any';

  @override
  String get duration => 'Duration';

  @override
  String get quality => 'Quality';

  @override
  String get reset => 'Reset';

  @override
  String get apply => 'Apply';

  @override
  String get errorTitle => 'Something went wrong';

  @override
  String get retry => 'Retry';

  @override
  String get sortRecentlyAdded => 'Recently added';

  @override
  String get sortNewest => 'Newest';

  @override
  String get sortShuffle => 'Shuffle';

  @override
  String get sortTopRated => 'Top rated';

  @override
  String get sortMostPlayed => 'Most played';

  @override
  String get sortRecentlyWatched => 'Recently watched';

  @override
  String get sortAlphabetical => 'A–Z';

  @override
  String get sortGroupOrder => 'Group order';

  @override
  String get sortName => 'Name';

  @override
  String get sortMostScenes => 'Most scenes';

  @override
  String get sortFavorites => 'Favorites';

  @override
  String get sortFileName => 'File name';

  @override
  String get sortMostImages => 'Most images';

  @override
  String get durationAny => 'Any length';

  @override
  String get durationShort => 'Under 10 min';

  @override
  String get durationMedium => '10–30 min';

  @override
  String get durationLong => 'Over 30 min';

  @override
  String get resolutionAny => 'Any quality';

  @override
  String galleriesCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString galleries',
      one: '1 gallery',
    );
    return '$_temp0';
  }

  @override
  String get galleriesEmpty => 'No galleries yet';

  @override
  String get galleriesEmptyHint =>
      'Add image folders or zip files to your Stash library.';

  @override
  String get edit => 'Edit';

  @override
  String get groupsEmpty => 'No groups yet';

  @override
  String get groupsEmptyHint => 'Groups need Stash v0.27 or newer.';

  @override
  String groupLoadFailed(String error) {
    return 'Couldn\'t load the group: $error';
  }

  @override
  String get groupNoScenes => 'This group has no scenes';

  @override
  String get playAll => 'Play all';

  @override
  String get imagesEmpty => 'No images yet';

  @override
  String get statsLibrary => 'Library';

  @override
  String get statsScenes => 'Scenes';

  @override
  String get statsImages => 'Images';

  @override
  String get statsGalleries => 'Galleries';

  @override
  String get statsPerformers => 'Performers';

  @override
  String get statsStudios => 'Studios';

  @override
  String get statsTags => 'Tags';

  @override
  String get statsStorage => 'Storage';

  @override
  String get statsTotalSize => 'Total size';

  @override
  String get statsAverageScene => 'Average scene';

  @override
  String get statsWatching => 'Watching';

  @override
  String get statsPlays => 'Plays';

  @override
  String get statsWatchTime => 'Watch time';

  @override
  String get statsScenesWatched => 'Scenes watched';

  @override
  String get statsOCount => 'O-count';

  @override
  String get watchLaterEmpty => 'Nothing saved yet';

  @override
  String get watchLaterEmptyHint =>
      'Tap \"Later\" on a scene to watch it afterwards.';

  @override
  String favoriteUpdateFailed(String error) {
    return 'Couldn\'t update favorite: $error';
  }

  @override
  String get favorited => 'Favorited';

  @override
  String get favorite => 'Favorite';

  @override
  String get favoriteRemove => 'Remove from favorites';

  @override
  String get favoriteAdd => 'Add to favorites';

  @override
  String ageYears(int age) {
    return '$age years';
  }

  @override
  String get performersTitle => 'Performers';

  @override
  String get performersEmpty => 'No performers found';

  @override
  String partOf(String name) {
    return 'Part of $name';
  }

  @override
  String get includeSubStudios => 'Include sub-studios';

  @override
  String get subStudios => 'Sub-studios';

  @override
  String get studiosTitle => 'Studios';

  @override
  String get studiosEmpty => 'No studios yet';

  @override
  String get studiosEmptyHint =>
      'Studios appear here once scenes in Stash have one.';

  @override
  String get newTag => 'New tag';

  @override
  String get name => 'Name';

  @override
  String get cancel => 'Cancel';

  @override
  String get create => 'Create';

  @override
  String tagCreateFailed(String error) {
    return 'Couldn\'t create tag: $error';
  }

  @override
  String tagsSaveFailed(String error) {
    return 'Couldn\'t save tags: $error';
  }

  @override
  String get tagsTitle => 'Tags';

  @override
  String get tagsEmpty => 'No tags yet';

  @override
  String get tagAddOrCreate => 'Add or create a tag';

  @override
  String tagCreate(String name) {
    return 'Create #$name';
  }

  @override
  String get tagsSave => 'Save tags';

  @override
  String get tagsEmptyHint => 'Create one with \"New tag\".';

  @override
  String get search => 'Search';

  @override
  String get continueWatching => 'Continue watching';

  @override
  String get newFromFavorites => 'New from favorites';

  @override
  String get searchHint => 'Search Stash';

  @override
  String searchNoScenes(String term) {
    return 'No scenes match \"$term\"';
  }

  @override
  String get searchNoScenesHint => 'Try other words or check the spelling.';

  @override
  String get recentSearches => 'Recent searches';

  @override
  String get clear => 'Clear';

  @override
  String get remove => 'Remove';

  @override
  String get popularTags => 'Popular tags';

  @override
  String get seeAll => 'See all';

  @override
  String get searchIntro =>
      'Search scenes, images, galleries, performers and studios';

  @override
  String get addServer => 'Add server';

  @override
  String get connectToStash => 'Connect to Stash';

  @override
  String get loginIntro =>
      'Enter the address of your Stash server, e.g. http://192.168.1.10:9999';

  @override
  String get savedServers => 'Saved servers';

  @override
  String get orAddAnotherServer => 'Or add another server';

  @override
  String get nameOptional => 'Name (optional)';

  @override
  String get nameHint => 'e.g. Home';

  @override
  String get serverUrl => 'Server URL';

  @override
  String get serverUrlInvalid => 'Enter a valid http(s) URL';

  @override
  String get apiKeyOptional => 'API key (optional)';

  @override
  String get apiKeyHelper =>
      'For a server with a password: the API key (Stash → Settings → Security), or sign in below.';

  @override
  String get orSignIn => 'Or sign in';

  @override
  String get orSignInHint =>
      'With the username and password of your Stash server. Casting to a TV needs the API key.';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get loginIncomplete => 'Enter username and password.';

  @override
  String get connect => 'Connect';

  @override
  String removeServerTitle(String name) {
    return 'Remove \"$name\"?';
  }

  @override
  String get removeServerBody =>
      'Its URL and API key, watch later list and search history are removed from this device.';

  @override
  String get servers => 'Servers';

  @override
  String get serverOptions => 'Server options';

  @override
  String get rename => 'Rename';

  @override
  String get renameServer => 'Rename server';

  @override
  String get save => 'Save';

  @override
  String get castDevice => 'Cast device';

  @override
  String get cast => 'Cast';

  @override
  String castingTo(String device) {
    return 'Casting to $device';
  }

  @override
  String get stopCasting => 'Stop casting';

  @override
  String get castTo => 'Cast to';

  @override
  String get castSearching => 'Searching for devices…';

  @override
  String get castSearchingHint =>
      'Chromecast and the phone must be on the same Wi-Fi.';

  @override
  String castConnectFailed(String device, String error) {
    return 'Couldn\'t connect to $device: $error';
  }

  @override
  String get minimize => 'Minimize';

  @override
  String get back10 => 'Back 10 s';

  @override
  String get forward10 => 'Forward 10 s';

  @override
  String get pause => 'Pause';

  @override
  String get play => 'Play';

  @override
  String get navBarTitle => 'Navigation bar';

  @override
  String navBarIntro(int max) {
    return 'Choose up to $max tabs and drag them into order. The first tab opens when the app starts.';
  }

  @override
  String get navBarAlwaysShown => 'Always shown';

  @override
  String navBarAtLeast(int count) {
    return 'At least $count tabs';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get sectionServer => 'Server';

  @override
  String stashVersion(String version) {
    return 'Stash $version';
  }

  @override
  String get unknownVersion => 'unknown version';

  @override
  String get notReachable => 'Not reachable';

  @override
  String get checking => 'Checking…';

  @override
  String get switchServer => 'Switch server';

  @override
  String get apiKey => 'API key';

  @override
  String get notSet => 'Not set';

  @override
  String get isSet => 'Set';

  @override
  String get serverAccess => 'API key or login';

  @override
  String signedInAs(String name) {
    return 'Signed in as $name';
  }

  @override
  String get sectionAppearance => 'Appearance';

  @override
  String get themeLight => 'Light';

  @override
  String get themeSystem => 'System';

  @override
  String get themeDark => 'Dark';

  @override
  String get accentColor => 'Accent color';

  @override
  String accentColorLabel(String name) {
    return '$name accent color';
  }

  @override
  String get colorRed => 'Red';

  @override
  String get colorPink => 'Pink';

  @override
  String get colorPurple => 'Purple';

  @override
  String get colorIndigo => 'Indigo';

  @override
  String get colorBlue => 'Blue';

  @override
  String get colorTeal => 'Teal';

  @override
  String get colorGreen => 'Green';

  @override
  String get colorOrange => 'Orange';

  @override
  String get colorAmber => 'Amber';

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'System';

  @override
  String get sectionPlayback => 'Playback';

  @override
  String get preferredQuality => 'Preferred quality';

  @override
  String get qualityOriginal => 'Original';

  @override
  String get preferredQualityHint =>
      'Used when a scene offers it, otherwise the next lower one. Smaller videos play their original file. Also changes with HD in the player.';

  @override
  String get sectionPrivacy => 'Privacy & security';

  @override
  String get removeThisServer => 'Remove this server';

  @override
  String get lockImmediately => 'Immediately';

  @override
  String lockAfterMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'After $count minutes',
      one: 'After 1 minute',
    );
    return '$_temp0';
  }

  @override
  String get appLock => 'App lock';

  @override
  String get appLockSubtitle => 'Ask for a PIN when opening the app';

  @override
  String get unlockBiometric => 'Unlock with Face ID / fingerprint';

  @override
  String get lockNow => 'Lock';

  @override
  String get changePin => 'Change PIN';

  @override
  String get hideInSwitcher => 'Hide in app switcher';

  @override
  String get hideInSwitcherSubtitle =>
      'Covers the app in the recent apps view. On Android this also blocks screenshots.';

  @override
  String get appIcon => 'App icon';

  @override
  String get appIconHint =>
      'On Android the name on the home screen changes too and the launcher may need a moment. On iOS only the icon changes and the system shows a confirmation.';

  @override
  String appIconFailed(String error) {
    return 'Couldn\'t change the icon: $error';
  }

  @override
  String get appIconStash => 'Stashy';

  @override
  String get appIconNotes => 'Notes';

  @override
  String get appIconCalculator => 'Calculator';

  @override
  String get unlockReason => 'Unlock Stash';

  @override
  String get enterPin => 'Enter PIN';

  @override
  String get choosePin => 'Choose a PIN';

  @override
  String get repeatPin => 'Repeat the PIN';

  @override
  String get enterYourPin => 'Enter your PIN';

  @override
  String get streamOriginal => 'Original file';

  @override
  String get streamAdaptive => 'Adaptive streaming';

  @override
  String get streamTranscoded => 'Transcoded – seeking may be limited';

  @override
  String get noAlternativeStreams => 'No alternative streams available';

  @override
  String get streamsLoadFailed => 'Couldn\'t load streams';

  @override
  String get chapters => 'Chapters';

  @override
  String get close => 'Close';

  @override
  String get upNextEmpty => 'Nothing else to watch here';

  @override
  String moreFrom(String name) {
    return 'More from $name';
  }

  @override
  String get upNext => 'Up next';

  @override
  String get addTags => 'Add tags';

  @override
  String get editTags => 'Edit tags';

  @override
  String get showLess => 'Show less';

  @override
  String get showMore => '...more';

  @override
  String saveFailed(String error) {
    return 'Couldn\'t save: $error';
  }

  @override
  String get removeRating => 'Remove rating';

  @override
  String rateStars(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Rate $count stars',
      one: 'Rate 1 star',
    );
    return '$_temp0';
  }

  @override
  String get addO => 'Add O';

  @override
  String oCountValue(int count) {
    return 'O-count: $count';
  }

  @override
  String get undo => 'Undo';

  @override
  String get editSceneDetails => 'Edit scene details';

  @override
  String get marker => 'Marker';

  @override
  String get addMarkerHere => 'Add a marker at the current position';

  @override
  String markerAdded(String time) {
    return 'Marker added at $time';
  }

  @override
  String markerAddFailed(String error) {
    return 'Couldn\'t add marker: $error';
  }

  @override
  String addMarkerAt(String time) {
    return 'Add marker at $time';
  }

  @override
  String get titleOptional => 'Title (optional)';

  @override
  String get primaryTagRequired => 'Primary tag (required)';

  @override
  String get addMarker => 'Add marker';

  @override
  String get saved => 'Saved';

  @override
  String get later => 'Later';

  @override
  String get exitFullscreen => 'Exit fullscreen';

  @override
  String get fullscreen => 'Fullscreen';

  @override
  String get clearField => 'Clear';

  @override
  String get searchStudios => 'Search studios';

  @override
  String get searchPerformers => 'Search performers';

  @override
  String get searchImages => 'Search images';

  @override
  String get imagesNoMatch => 'No images match the search or filters.';

  @override
  String get done => 'Done';

  @override
  String get editScene => 'Edit scene';

  @override
  String get fieldCover => 'Cover';

  @override
  String get fieldTitle => 'Title';

  @override
  String get fieldDetails => 'Details';

  @override
  String get fieldDate => 'Date';

  @override
  String get fieldStudio => 'Studio';

  @override
  String get fieldPerformers => 'Performers';

  @override
  String get organized => 'Organized';

  @override
  String get organizedSubtitle => 'Metadata is complete';

  @override
  String get genderFemale => 'Female';

  @override
  String get genderMale => 'Male';

  @override
  String get genderTransFemale => 'Trans female';

  @override
  String get genderTransMale => 'Trans male';

  @override
  String get genderIntersex => 'Intersex';

  @override
  String get genderNonBinary => 'Non-binary';

  @override
  String get nameRequired => 'A name is required';

  @override
  String get editPerformer => 'Edit performer';

  @override
  String get fieldImage => 'Image';

  @override
  String get fieldName => 'Name';

  @override
  String get fieldDisambiguation => 'Disambiguation';

  @override
  String get fieldGender => 'Gender';

  @override
  String get fieldBirthdate => 'Birthdate';

  @override
  String get fieldCountryCode => 'Country code';

  @override
  String get countryCodeHint => 'e.g. DE';

  @override
  String get editStudio => 'Edit studio';

  @override
  String get fieldLogo => 'Logo';

  @override
  String get fieldParentStudio => 'Parent studio';

  @override
  String get studioOwnParent => 'A studio can\'t be its own parent';

  @override
  String get fieldWebsite => 'Website';

  @override
  String get editTag => 'Edit tag';

  @override
  String get fieldDescription => 'Description';

  @override
  String get editGallery => 'Edit gallery';

  @override
  String get invalidUrl => 'That is not a valid URL';

  @override
  String get choosePhoto => 'Choose photo';

  @override
  String get fromUrl => 'From URL';

  @override
  String get keepCurrentImage => 'Keep current image';

  @override
  String get imageFromUrl => 'Image from URL';

  @override
  String get use => 'Use';

  @override
  String get enterFullUrl => 'Enter a full URL, e.g. https://…';

  @override
  String get urls => 'URLs';

  @override
  String get removeUrl => 'Remove URL';

  @override
  String get addUrl => 'Add URL';

  @override
  String errorUnreachable(String detail) {
    return 'Could not reach the server: $detail';
  }

  @override
  String get errorUnauthorized =>
      'Not authorized – check the API key or login.';

  @override
  String get errorInvalidCredentials => 'Wrong username or password.';

  @override
  String errorNotReady(String status) {
    return 'Server is reachable but not ready (status: $status).';
  }

  @override
  String get errorNotFound => 'Not found.';

  @override
  String get errorNotSaved => 'Nothing was saved.';

  @override
  String navBarCount(int count, int max) {
    return '$count of $max tabs chosen';
  }

  @override
  String get fileInfo => 'File info';

  @override
  String fileInfoFiles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'File info ($count files)',
      one: 'File info',
    );
    return '$_temp0';
  }

  @override
  String get fileName => 'File';

  @override
  String get filePath => 'Path';

  @override
  String get fileSize => 'Size';

  @override
  String get fileFormat => 'Format';

  @override
  String get fileResolution => 'Resolution';

  @override
  String get fileDuration => 'Duration';

  @override
  String get fileVideoCodec => 'Video codec';

  @override
  String get fileAudioCodec => 'Audio codec';

  @override
  String get fileFrameRate => 'Frame rate';

  @override
  String get fileBitRate => 'Bit rate';

  @override
  String get fileModified => 'Modified';

  @override
  String get copyPath => 'Copy path';

  @override
  String get pathCopied => 'Path copied';

  @override
  String framesPerSecond(String fps) {
    return '$fps fps';
  }

  @override
  String megabitsPerSecond(String rate) {
    return '$rate Mbit/s';
  }

  @override
  String get tabShorts => 'Shorts';

  @override
  String get shortsSettings => 'Shorts settings';

  @override
  String get shortsTags => 'Preferred tags';

  @override
  String get shortsTagsHint =>
      'Videos with one of these tags show up more often.';

  @override
  String get shortsOnlyTags => 'Only these tags';

  @override
  String get shortsOnlyTagsHint => 'Leave out videos without any of the tags';

  @override
  String get shortsMaxLength => 'Maximum length';

  @override
  String get shortsLengthOneMinute => 'Up to 1 min';

  @override
  String get shortsLengthThreeMinutes => 'Up to 3 min';

  @override
  String get shortsLengthTenMinutes => 'Up to 10 min';

  @override
  String get shortsPortraitOnly => 'Portrait videos only';

  @override
  String get shortsEmpty => 'No shorts found';

  @override
  String get shortsEmptyHint =>
      'Shorts are short portrait videos. Try a longer maximum length or other tags.';

  @override
  String get shortsFullVideo => 'Full video';

  @override
  String get sectionSceneCards => 'Video cards';

  @override
  String get cardChannel => 'Channel on cards';

  @override
  String get cardChannelStudio => 'Studio';

  @override
  String get cardChannelPerformers => 'Performers';

  @override
  String get cardShowPlays => 'Show plays';

  @override
  String get cardShowRating => 'Show rating';

  @override
  String get shortsRate => 'Rate';

  @override
  String get mute => 'Mute';

  @override
  String get unmute => 'Unmute';

  @override
  String get moreActions => 'More';

  @override
  String get fastForward2x => '2× speed';

  @override
  String get unknownStudio => 'Unknown studio';

  @override
  String get unknownPerformer => 'Unknown performer';

  @override
  String get playbackSpeed => 'Playback speed';

  @override
  String get speedNormal => 'Normal';

  @override
  String speedValue(double rate) {
    final intl.NumberFormat rateNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String rateString = rateNumberFormat.format(rate);

    return '$rateString×';
  }

  @override
  String get editServer => 'Edit server';

  @override
  String get statsAndServer => 'Stats & server';

  @override
  String get airPlay => 'AirPlay';

  @override
  String get airPlayHint => 'Apple TV and AirPlay TVs';

  @override
  String get allViews => 'All views';

  @override
  String get tabAll => 'All';

  @override
  String get colorStashy => 'Stashy';

  @override
  String get searchScenes => 'Search scenes';

  @override
  String get searchGalleries => 'Search galleries';

  @override
  String searchNoResults(String term) {
    return 'Nothing matches \"$term\"';
  }

  @override
  String get pictureInPicture => 'Picture-in-picture';

  @override
  String get pipUnavailable =>
      'Picture-in-picture isn\'t available for this video.';

  @override
  String get autoPip => 'Picture-in-picture when leaving the app';

  @override
  String get autoPipSubtitle => 'A playing video continues in a small window.';

  @override
  String get backgroundPlayback => 'Background playback';

  @override
  String get backgroundPlaybackSubtitle =>
      'The sound keeps playing while the app is in the background.';

  @override
  String performerShorts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count shorts',
      one: '1 short',
    );
    return '$_temp0';
  }

  @override
  String get themeWelcomeTitle => 'Choose your look';

  @override
  String get themeWelcomeText =>
      'Light or dark, and an accent color. You can change this anytime in the settings.';

  @override
  String get lockScreenControls => 'Show on the lock screen';

  @override
  String get lockScreenControlsSubtitle =>
      'Title, picture and controls on the lock screen and in the notification. Leave off for discretion.';

  @override
  String get libraryMarkers => 'Markers';

  @override
  String get markersEmpty => 'No markers yet';

  @override
  String get markersEmptyHint => 'Mark a moment in the player with \"Marker\".';

  @override
  String markersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count markers',
      one: '1 marker',
    );
    return '$_temp0';
  }

  @override
  String get hideInSwitcherLocked => 'Always on while the app lock is on.';

  @override
  String get haptics => 'Haptic feedback';

  @override
  String get hapticsOff => 'Off';

  @override
  String get hapticsLight => 'Light';

  @override
  String get hapticsNormal => 'Normal';

  @override
  String get feedPreviews => 'Play previews in lists';

  @override
  String get feedPreviewsSubtitle =>
      'The first fully shown video plays a short preview.';

  @override
  String get feedPreviewDelay => 'Preview starts after';

  @override
  String secondsValue(double seconds) {
    final intl.NumberFormat secondsNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String secondsString = secondsNumberFormat.format(seconds);

    return '$secondsString s';
  }

  @override
  String get markerPreviews => 'Play marker previews';

  @override
  String get markerPreviewsSubtitle =>
      'Markers loop a short clip instead of a still frame.';

  @override
  String get sectionAbout => 'About';

  @override
  String get appVersion => 'Version';

  @override
  String appVersionValue(String version, String build) {
    return '$version (build $build)';
  }

  @override
  String get openSourceLicenses => 'Open source licenses';

  @override
  String get openSourceLicensesSubtitle =>
      'Licenses of the packages Stashy uses';

  @override
  String get aboutLegalese =>
      'A client for Stash servers. Not affiliated with the Stash project.';
}
