// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

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
      other: '$countString Szenen',
      one: '1 Szene',
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
      other: '$countString Bilder',
      one: '1 Bild',
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
      other: '$countString Wiedergaben',
      one: '1 Wiedergabe',
      zero: 'Keine Wiedergaben',
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
      other: '$countString gespeicherte Server',
      one: '1 gespeicherter Server',
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
      other: '$countString Unterstudios',
      one: '1 Unterstudio',
    );
    return '$_temp0';
  }

  @override
  String get timeUpcoming => 'demnächst';

  @override
  String get timeJustNow => 'gerade eben';

  @override
  String timeYearsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'vor $count Jahren',
      one: 'vor 1 Jahr',
    );
    return '$_temp0';
  }

  @override
  String timeMonthsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'vor $count Monaten',
      one: 'vor 1 Monat',
    );
    return '$_temp0';
  }

  @override
  String timeWeeksAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'vor $count Wochen',
      one: 'vor 1 Woche',
    );
    return '$_temp0';
  }

  @override
  String timeDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'vor $count Tagen',
      one: 'vor 1 Tag',
    );
    return '$_temp0';
  }

  @override
  String timeHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'vor $count Stunden',
      one: 'vor 1 Stunde',
    );
    return '$_temp0';
  }

  @override
  String timeMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'vor $count Minuten',
      one: 'vor 1 Minute',
    );
    return '$_temp0';
  }

  @override
  String get libraryTitle => 'Bibliothek';

  @override
  String get libraryScenes => 'Szenen';

  @override
  String get libraryHistory => 'Verlauf';

  @override
  String get libraryWatchLater => 'Später ansehen';

  @override
  String get libraryGroups => 'Gruppen';

  @override
  String get libraryImages => 'Bilder';

  @override
  String get libraryGalleries => 'Galerien';

  @override
  String get libraryStats => 'Statistik';

  @override
  String get historyEmpty => 'Noch nichts angesehen';

  @override
  String get historyEmptyHint => 'Szenen, die du abspielst, erscheinen hier.';

  @override
  String get tabHome => 'Start';

  @override
  String get tabPerformers => 'Performer';

  @override
  String get tabStudios => 'Studios';

  @override
  String get tabLibrary => 'Bibliothek';

  @override
  String get tabWatchLater => 'Später';

  @override
  String get tabTags => 'Tags';

  @override
  String get tabSearch => 'Suche';

  @override
  String get emptyDefault => 'Hier ist noch nichts';

  @override
  String get loadMoreFailed =>
      'Weitere konnten nicht geladen werden – zum Wiederholen tippen';

  @override
  String pageOf(int page, int count) {
    return 'Seite $page von $count';
  }

  @override
  String get pageLoadFailed =>
      'Die Seite konnte nicht geladen werden – nochmal versuchen';

  @override
  String get firstPage => 'Erste Seite';

  @override
  String get previousPage => 'Vorherige Seite';

  @override
  String get nextPage => 'Nächste Seite';

  @override
  String get lastPage => 'Letzte Seite';

  @override
  String get goToPage => 'Zu Seite springen';

  @override
  String pageRange(int count) {
    return '1–$count';
  }

  @override
  String get go => 'Los';

  @override
  String get listPaging => 'Lange Listen';

  @override
  String get pagingInfinite => 'Endlos scrollen';

  @override
  String get pagingPages => 'Seiten';

  @override
  String get channelUnknown => 'Unbekannt';

  @override
  String get sceneMenuPlay => 'Abspielen';

  @override
  String get watchLaterRemove => 'Aus „Später ansehen“ entfernen';

  @override
  String get watchLaterSave => 'Zu „Später ansehen“ hinzufügen';

  @override
  String get editDetails => 'Details bearbeiten';

  @override
  String goTo(String name) {
    return 'Zu $name';
  }

  @override
  String get scenesEmpty => 'Keine Szenen gefunden';

  @override
  String savedFilterUnsupported(String name, String criteria) {
    return '„$name“: nicht unterstützte Kriterien ignoriert ($criteria)';
  }

  @override
  String get filter => 'Filter';

  @override
  String get filterScenes => 'Szenen filtern';

  @override
  String get filterImages => 'Bilder filtern';

  @override
  String get filterTagsAllOf => 'Tags (alle)';

  @override
  String get searchTags => 'Tags suchen';

  @override
  String get minimumRating => 'Mindestbewertung';

  @override
  String get ratingAny => 'Alle';

  @override
  String get duration => 'Dauer';

  @override
  String get quality => 'Qualität';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String get apply => 'Anwenden';

  @override
  String get errorTitle => 'Etwas ist schiefgelaufen';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get sortRecentlyAdded => 'Neu hinzugefügt';

  @override
  String get sortNewest => 'Neueste';

  @override
  String get sortShuffle => 'Zufällig';

  @override
  String get sortTopRated => 'Top bewertet';

  @override
  String get sortMostPlayed => 'Meistgespielt';

  @override
  String get sortRecentlyWatched => 'Zuletzt angesehen';

  @override
  String get sortAlphabetical => 'A–Z';

  @override
  String get sortGroupOrder => 'Reihenfolge der Gruppe';

  @override
  String get sortName => 'Name';

  @override
  String get sortMostScenes => 'Meiste Szenen';

  @override
  String get sortFavorites => 'Favoriten';

  @override
  String get sortFileName => 'Dateiname';

  @override
  String get sortMostImages => 'Meiste Bilder';

  @override
  String get durationAny => 'Beliebige Länge';

  @override
  String get durationShort => 'Unter 10 Min.';

  @override
  String get durationMedium => '10–30 Min.';

  @override
  String get durationLong => 'Über 30 Min.';

  @override
  String get resolutionAny => 'Beliebige Qualität';

  @override
  String galleriesCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Galerien',
      one: '1 Galerie',
    );
    return '$_temp0';
  }

  @override
  String get galleriesEmpty => 'Noch keine Galerien';

  @override
  String get galleriesEmptyHint =>
      'Füge deiner Stash-Bibliothek Bildordner oder ZIP-Dateien hinzu.';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get groupsEmpty => 'Noch keine Gruppen';

  @override
  String get groupsEmptyHint => 'Gruppen brauchen Stash v0.27 oder neuer.';

  @override
  String groupLoadFailed(String error) {
    return 'Die Gruppe konnte nicht geladen werden: $error';
  }

  @override
  String get groupNoScenes => 'Diese Gruppe hat keine Szenen';

  @override
  String get playAll => 'Alle abspielen';

  @override
  String get imagesEmpty => 'Noch keine Bilder';

  @override
  String get statsLibrary => 'Bibliothek';

  @override
  String get statsScenes => 'Szenen';

  @override
  String get statsImages => 'Bilder';

  @override
  String get statsGalleries => 'Galerien';

  @override
  String get statsPerformers => 'Performer';

  @override
  String get statsStudios => 'Studios';

  @override
  String get statsTags => 'Tags';

  @override
  String get statsStorage => 'Speicher';

  @override
  String get statsTotalSize => 'Gesamtgröße';

  @override
  String get statsAverageScene => 'Durchschnittliche Szene';

  @override
  String get statsWatching => 'Wiedergabe';

  @override
  String get statsPlays => 'Wiedergaben';

  @override
  String get statsWatchTime => 'Wiedergabezeit';

  @override
  String get statsScenesWatched => 'Angesehene Szenen';

  @override
  String get statsOCount => 'O-Zähler';

  @override
  String get watchLaterEmpty => 'Noch nichts gespeichert';

  @override
  String get watchLaterEmptyHint =>
      'Tippe bei einer Szene auf „Später“, um sie danach anzusehen.';

  @override
  String favoriteUpdateFailed(String error) {
    return 'Favorit konnte nicht geändert werden: $error';
  }

  @override
  String get favorited => 'Favorit';

  @override
  String get favorite => 'Favorisieren';

  @override
  String get favoriteRemove => 'Aus Favoriten entfernen';

  @override
  String get favoriteAdd => 'Zu Favoriten hinzufügen';

  @override
  String ageYears(int age) {
    return '$age Jahre';
  }

  @override
  String get performersTitle => 'Performer';

  @override
  String get performersEmpty => 'Keine Performer gefunden';

  @override
  String partOf(String name) {
    return 'Teil von $name';
  }

  @override
  String get includeSubStudios => 'Unterstudios einbeziehen';

  @override
  String get subStudios => 'Unterstudios';

  @override
  String get studiosTitle => 'Studios';

  @override
  String get studiosEmpty => 'Noch keine Studios';

  @override
  String get studiosEmptyHint =>
      'Studios erscheinen hier, sobald Szenen in Stash eines haben.';

  @override
  String get newTag => 'Neuer Tag';

  @override
  String get name => 'Name';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get create => 'Erstellen';

  @override
  String tagCreateFailed(String error) {
    return 'Tag konnte nicht erstellt werden: $error';
  }

  @override
  String tagsSaveFailed(String error) {
    return 'Tags konnten nicht gespeichert werden: $error';
  }

  @override
  String get tagsTitle => 'Tags';

  @override
  String get tagsEmpty => 'Noch keine Tags';

  @override
  String get tagAddOrCreate => 'Tag hinzufügen oder erstellen';

  @override
  String tagCreate(String name) {
    return '#$name erstellen';
  }

  @override
  String get tagsSave => 'Tags speichern';

  @override
  String get tagsEmptyHint => 'Erstelle einen mit „Neuer Tag“.';

  @override
  String get search => 'Suche';

  @override
  String get continueWatching => 'Weiterschauen';

  @override
  String get newFromFavorites => 'Neu von Favoriten';

  @override
  String get searchHint => 'Stash durchsuchen';

  @override
  String searchNoScenes(String term) {
    return 'Keine Szenen zu „$term“';
  }

  @override
  String get searchNoScenesHint =>
      'Versuche andere Wörter oder prüfe die Schreibweise.';

  @override
  String get recentSearches => 'Letzte Suchen';

  @override
  String get clear => 'Leeren';

  @override
  String get remove => 'Entfernen';

  @override
  String get popularTags => 'Beliebte Tags';

  @override
  String get seeAll => 'Alle anzeigen';

  @override
  String get searchIntro =>
      'Szenen, Bilder, Galerien, Performer und Studios durchsuchen';

  @override
  String get addServer => 'Server hinzufügen';

  @override
  String get connectToStash => 'Mit Stash verbinden';

  @override
  String get loginIntro =>
      'Gib die Adresse deines Stash-Servers ein, z. B. http://192.168.1.10:9999';

  @override
  String get savedServers => 'Gespeicherte Server';

  @override
  String get orAddAnotherServer => 'Oder einen weiteren Server hinzufügen';

  @override
  String get nameOptional => 'Name (optional)';

  @override
  String get nameHint => 'z. B. Zuhause';

  @override
  String get serverUrl => 'Server-URL';

  @override
  String get serverUrlInvalid => 'Gib eine gültige http(s)-URL ein';

  @override
  String get apiKeyOptional => 'API-Schlüssel (optional)';

  @override
  String get apiKeyHelper =>
      'Für einen Server mit Passwort: der API-Schlüssel (Stash → Settings → Security) oder unten anmelden.';

  @override
  String get orSignIn => 'Oder anmelden';

  @override
  String get orSignInHint =>
      'Mit Benutzername und Passwort deines Stash-Servers. Zum Streamen auf einen Fernseher braucht es den API-Schlüssel.';

  @override
  String get username => 'Benutzername';

  @override
  String get password => 'Passwort';

  @override
  String get loginIncomplete => 'Benutzername und Passwort eingeben.';

  @override
  String get connect => 'Verbinden';

  @override
  String removeServerTitle(String name) {
    return '„$name“ entfernen?';
  }

  @override
  String get removeServerBody =>
      'URL und API-Schlüssel, die „Später ansehen“-Liste und der Suchverlauf werden von diesem Gerät entfernt.';

  @override
  String get servers => 'Server';

  @override
  String get serverOptions => 'Server-Optionen';

  @override
  String get rename => 'Umbenennen';

  @override
  String get renameServer => 'Server umbenennen';

  @override
  String get save => 'Speichern';

  @override
  String get castDevice => 'Cast-Gerät';

  @override
  String get cast => 'Streamen';

  @override
  String castingTo(String device) {
    return 'Wird auf $device gestreamt';
  }

  @override
  String get stopCasting => 'Streamen beenden';

  @override
  String get castTo => 'Streamen auf';

  @override
  String get castSearching => 'Suche nach Geräten…';

  @override
  String get castSearchingHint =>
      'Chromecast und Telefon müssen im selben WLAN sein.';

  @override
  String castConnectFailed(String device, String error) {
    return 'Verbindung zu $device fehlgeschlagen: $error';
  }

  @override
  String get minimize => 'Minimieren';

  @override
  String get back10 => '10 s zurück';

  @override
  String get forward10 => '10 s vor';

  @override
  String get pause => 'Pause';

  @override
  String get play => 'Abspielen';

  @override
  String get navBarTitle => 'Navigationsleiste';

  @override
  String navBarIntro(int max) {
    return 'Wähle bis zu $max Tabs und ziehe sie in die gewünschte Reihenfolge. Der erste Tab öffnet sich beim Start.';
  }

  @override
  String get navBarAlwaysShown => 'Immer sichtbar';

  @override
  String navBarAtLeast(int count) {
    return 'Mindestens $count Tabs';
  }

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get sectionServer => 'Server';

  @override
  String stashVersion(String version) {
    return 'Stash $version';
  }

  @override
  String get unknownVersion => 'unbekannte Version';

  @override
  String get notReachable => 'Nicht erreichbar';

  @override
  String get checking => 'Wird geprüft…';

  @override
  String get switchServer => 'Server wechseln';

  @override
  String get apiKey => 'API-Schlüssel';

  @override
  String get notSet => 'Nicht gesetzt';

  @override
  String get isSet => 'Gesetzt';

  @override
  String get serverAccess => 'API-Schlüssel oder Login';

  @override
  String signedInAs(String name) {
    return 'Angemeldet als $name';
  }

  @override
  String get sectionAppearance => 'Darstellung';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeSystem => 'System';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get accentColor => 'Akzentfarbe';

  @override
  String accentColorLabel(String name) {
    return 'Akzentfarbe $name';
  }

  @override
  String get colorRed => 'Rot';

  @override
  String get colorPink => 'Pink';

  @override
  String get colorPurple => 'Lila';

  @override
  String get colorIndigo => 'Indigo';

  @override
  String get colorBlue => 'Blau';

  @override
  String get colorTeal => 'Petrol';

  @override
  String get colorGreen => 'Grün';

  @override
  String get colorOrange => 'Orange';

  @override
  String get colorAmber => 'Bernstein';

  @override
  String get language => 'Sprache';

  @override
  String get languageSystem => 'System';

  @override
  String get sectionPlayback => 'Wiedergabe';

  @override
  String get preferredQuality => 'Bevorzugte Qualität';

  @override
  String get qualityOriginal => 'Original';

  @override
  String get preferredQualityHint =>
      'Gilt, wenn eine Szene sie anbietet, sonst die nächstniedrigere. Kleinere Videos laufen als Originaldatei. Ändert sich auch über HD im Player.';

  @override
  String get sectionPrivacy => 'Privatsphäre & Sicherheit';

  @override
  String get removeThisServer => 'Diesen Server entfernen';

  @override
  String get lockImmediately => 'Sofort';

  @override
  String lockAfterMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nach $count Minuten',
      one: 'Nach 1 Minute',
    );
    return '$_temp0';
  }

  @override
  String get appLock => 'App-Sperre';

  @override
  String get appLockSubtitle => 'Beim Öffnen der App nach einer PIN fragen';

  @override
  String get unlockBiometric => 'Mit Face ID / Fingerabdruck entsperren';

  @override
  String get lockNow => 'Sperren';

  @override
  String get changePin => 'PIN ändern';

  @override
  String get hideInSwitcher => 'Im App-Umschalter verbergen';

  @override
  String get hideInSwitcherSubtitle =>
      'Verdeckt die App in der Übersicht der letzten Apps. Auf Android werden auch Screenshots blockiert.';

  @override
  String get appIcon => 'App-Symbol';

  @override
  String get appIconHint =>
      'Auf Android ändert sich auch der Name auf dem Startbildschirm, und der Launcher braucht evtl. einen Moment. Auf iOS ändert sich nur das Symbol, und das System zeigt eine Bestätigung.';

  @override
  String appIconFailed(String error) {
    return 'Das Symbol konnte nicht geändert werden: $error';
  }

  @override
  String get appIconStash => 'Stashy';

  @override
  String get appIconNotes => 'Notizen';

  @override
  String get appIconCalculator => 'Rechner';

  @override
  String get unlockReason => 'Stash entsperren';

  @override
  String get enterPin => 'PIN eingeben';

  @override
  String get choosePin => 'PIN festlegen';

  @override
  String get repeatPin => 'PIN wiederholen';

  @override
  String get enterYourPin => 'Gib deine PIN ein';

  @override
  String get streamOriginal => 'Originaldatei';

  @override
  String get streamAdaptive => 'Adaptives Streaming';

  @override
  String get streamTranscoded => 'Transkodiert – Spulen evtl. eingeschränkt';

  @override
  String get noAlternativeStreams => 'Keine alternativen Streams verfügbar';

  @override
  String get streamsLoadFailed => 'Streams konnten nicht geladen werden';

  @override
  String get chapters => 'Kapitel';

  @override
  String get close => 'Schließen';

  @override
  String get upNextEmpty => 'Hier gibt es sonst nichts zu sehen';

  @override
  String moreFrom(String name) {
    return 'Mehr von $name';
  }

  @override
  String get upNext => 'Als Nächstes';

  @override
  String get addTags => 'Tags hinzufügen';

  @override
  String get editTags => 'Tags bearbeiten';

  @override
  String get showLess => 'Weniger anzeigen';

  @override
  String get showMore => '...mehr';

  @override
  String saveFailed(String error) {
    return 'Speichern fehlgeschlagen: $error';
  }

  @override
  String get removeRating => 'Bewertung entfernen';

  @override
  String rateStars(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mit $count Sternen bewerten',
      one: 'Mit 1 Stern bewerten',
    );
    return '$_temp0';
  }

  @override
  String get addO => 'O hinzufügen';

  @override
  String oCountValue(int count) {
    return 'O-Zähler: $count';
  }

  @override
  String get undo => 'Rückgängig';

  @override
  String get editSceneDetails => 'Szenendetails bearbeiten';

  @override
  String get marker => 'Marker';

  @override
  String get addMarkerHere => 'Marker an der aktuellen Position setzen';

  @override
  String markerAdded(String time) {
    return 'Marker bei $time gesetzt';
  }

  @override
  String markerAddFailed(String error) {
    return 'Marker konnte nicht gesetzt werden: $error';
  }

  @override
  String addMarkerAt(String time) {
    return 'Marker bei $time setzen';
  }

  @override
  String get titleOptional => 'Titel (optional)';

  @override
  String get primaryTagRequired => 'Haupt-Tag (erforderlich)';

  @override
  String get addMarker => 'Marker setzen';

  @override
  String get saved => 'Gespeichert';

  @override
  String get later => 'Später';

  @override
  String get exitFullscreen => 'Vollbild beenden';

  @override
  String get fullscreen => 'Vollbild';

  @override
  String get clearField => 'Leeren';

  @override
  String get searchStudios => 'Studios suchen';

  @override
  String get searchPerformers => 'Performer suchen';

  @override
  String get searchImages => 'Bilder suchen';

  @override
  String get imagesNoMatch =>
      'Keine Bilder passen zur Suche oder zu den Filtern.';

  @override
  String get done => 'Fertig';

  @override
  String get editScene => 'Szene bearbeiten';

  @override
  String get fieldCover => 'Cover';

  @override
  String get fieldTitle => 'Titel';

  @override
  String get fieldDetails => 'Details';

  @override
  String get fieldDate => 'Datum';

  @override
  String get fieldStudio => 'Studio';

  @override
  String get fieldPerformers => 'Performer';

  @override
  String get organized => 'Organisiert';

  @override
  String get organizedSubtitle => 'Metadaten sind vollständig';

  @override
  String get genderFemale => 'Weiblich';

  @override
  String get genderMale => 'Männlich';

  @override
  String get genderTransFemale => 'Trans weiblich';

  @override
  String get genderTransMale => 'Trans männlich';

  @override
  String get genderIntersex => 'Intergeschlechtlich';

  @override
  String get genderNonBinary => 'Nichtbinär';

  @override
  String get nameRequired => 'Ein Name ist erforderlich';

  @override
  String get editPerformer => 'Performer bearbeiten';

  @override
  String get fieldImage => 'Bild';

  @override
  String get fieldName => 'Name';

  @override
  String get fieldDisambiguation => 'Unterscheidung';

  @override
  String get fieldGender => 'Geschlecht';

  @override
  String get fieldBirthdate => 'Geburtsdatum';

  @override
  String get fieldCountryCode => 'Ländercode';

  @override
  String get countryCodeHint => 'z. B. DE';

  @override
  String get editStudio => 'Studio bearbeiten';

  @override
  String get fieldLogo => 'Logo';

  @override
  String get fieldParentStudio => 'Übergeordnetes Studio';

  @override
  String get studioOwnParent =>
      'Ein Studio kann nicht sein eigenes übergeordnetes Studio sein';

  @override
  String get fieldWebsite => 'Website';

  @override
  String get editTag => 'Tag bearbeiten';

  @override
  String get fieldDescription => 'Beschreibung';

  @override
  String get editGallery => 'Galerie bearbeiten';

  @override
  String get invalidUrl => 'Das ist keine gültige URL';

  @override
  String get choosePhoto => 'Foto auswählen';

  @override
  String get fromUrl => 'Von URL';

  @override
  String get keepCurrentImage => 'Aktuelles Bild behalten';

  @override
  String get imageFromUrl => 'Bild von URL';

  @override
  String get use => 'Verwenden';

  @override
  String get enterFullUrl => 'Gib eine vollständige URL ein, z. B. https://…';

  @override
  String get urls => 'URLs';

  @override
  String get removeUrl => 'URL entfernen';

  @override
  String get addUrl => 'URL hinzufügen';

  @override
  String errorUnreachable(String detail) {
    return 'Server nicht erreichbar: $detail';
  }

  @override
  String get errorUnauthorized =>
      'Nicht berechtigt – prüfe API-Schlüssel oder Login.';

  @override
  String get errorInvalidCredentials =>
      'Benutzername oder Passwort ist falsch.';

  @override
  String errorNotReady(String status) {
    return 'Der Server ist erreichbar, aber nicht bereit (Status: $status).';
  }

  @override
  String get errorNotFound => 'Nicht gefunden.';

  @override
  String get errorNotSaved => 'Es wurde nichts gespeichert.';

  @override
  String navBarCount(int count, int max) {
    return '$count von $max Tabs gewählt';
  }

  @override
  String get fileInfo => 'Dateiinfos';

  @override
  String fileInfoFiles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dateiinfos ($count Dateien)',
      one: 'Dateiinfos',
    );
    return '$_temp0';
  }

  @override
  String get fileName => 'Datei';

  @override
  String get filePath => 'Pfad';

  @override
  String get fileSize => 'Größe';

  @override
  String get fileFormat => 'Format';

  @override
  String get fileResolution => 'Auflösung';

  @override
  String get fileDuration => 'Dauer';

  @override
  String get fileVideoCodec => 'Video-Codec';

  @override
  String get fileAudioCodec => 'Audio-Codec';

  @override
  String get fileFrameRate => 'Bildrate';

  @override
  String get fileBitRate => 'Bitrate';

  @override
  String get fileModified => 'Geändert';

  @override
  String get copyPath => 'Pfad kopieren';

  @override
  String get pathCopied => 'Pfad kopiert';

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
  String get shortsSettings => 'Shorts-Einstellungen';

  @override
  String get shortsTags => 'Bevorzugte Tags';

  @override
  String get shortsTagsHint =>
      'Videos mit einem dieser Tags kommen häufiger vor.';

  @override
  String get shortsOnlyTags => 'Nur diese Tags';

  @override
  String get shortsOnlyTagsHint => 'Videos ohne einen der Tags weglassen';

  @override
  String get shortsMaxLength => 'Maximale Länge';

  @override
  String get shortsLengthOneMinute => 'Bis 1 Min.';

  @override
  String get shortsLengthThreeMinutes => 'Bis 3 Min.';

  @override
  String get shortsLengthTenMinutes => 'Bis 10 Min.';

  @override
  String get shortsPortraitOnly => 'Nur Hochkant-Videos';

  @override
  String get shortsEmpty => 'Keine Shorts gefunden';

  @override
  String get shortsEmptyHint =>
      'Shorts sind kurze Hochkant-Videos. Versuche eine längere Maximallänge oder andere Tags.';

  @override
  String get shortsFullVideo => 'Ganzes Video';

  @override
  String get sectionSceneCards => 'Videokarten';

  @override
  String get cardChannel => 'Kanal auf den Karten';

  @override
  String get cardChannelStudio => 'Studio';

  @override
  String get cardChannelPerformers => 'Performer';

  @override
  String get cardShowPlays => 'Wiedergaben anzeigen';

  @override
  String get cardShowRating => 'Bewertung anzeigen';

  @override
  String get shortsRate => 'Bewerten';

  @override
  String get mute => 'Ton aus';

  @override
  String get unmute => 'Ton an';

  @override
  String get moreActions => 'Mehr';

  @override
  String get fastForward2x => '2× Tempo';

  @override
  String get unknownStudio => 'Unbekanntes Studio';

  @override
  String get unknownPerformer => 'Unbekannter Performer';

  @override
  String get playbackSpeed => 'Wiedergabetempo';

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
  String get editServer => 'Server bearbeiten';

  @override
  String get statsAndServer => 'Statistik & Server';

  @override
  String get airPlay => 'AirPlay';

  @override
  String get airPlayHint => 'Apple TV und AirPlay-Fernseher';

  @override
  String get allViews => 'Alle Ansichten';

  @override
  String get tabAll => 'Alle';

  @override
  String get colorStash => 'Stash (Blau/Braun)';

  @override
  String get searchScenes => 'Szenen suchen';

  @override
  String get searchGalleries => 'Galerien suchen';

  @override
  String searchNoResults(String term) {
    return 'Nichts gefunden zu „$term“';
  }

  @override
  String get pictureInPicture => 'Bild-in-Bild';

  @override
  String get pipUnavailable =>
      'Bild-in-Bild ist für dieses Video nicht verfügbar.';

  @override
  String get autoPip => 'Bild-in-Bild beim Verlassen der App';

  @override
  String get autoPipSubtitle =>
      'Ein laufendes Video spielt in einem kleinen Fenster weiter.';

  @override
  String get backgroundPlayback => 'Hintergrundwiedergabe';

  @override
  String get backgroundPlaybackSubtitle =>
      'Der Ton läuft weiter, während die App im Hintergrund ist.';

  @override
  String performerShorts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Shorts',
      one: '1 Short',
    );
    return '$_temp0';
  }

  @override
  String get themeWelcomeTitle => 'Wähle dein Design';

  @override
  String get themeWelcomeText =>
      'Hell oder dunkel und eine Akzentfarbe. Das kannst du jederzeit in den Einstellungen ändern.';

  @override
  String get lockScreenControls => 'Auf dem Sperrbildschirm anzeigen';

  @override
  String get lockScreenControlsSubtitle =>
      'Titel, Vorschaubild und Steuerung auf dem Sperrbildschirm und in der Benachrichtigung. Für mehr Diskretion aus lassen.';

  @override
  String get libraryMarkers => 'Marker';

  @override
  String get markersEmpty => 'Noch keine Marker';

  @override
  String get markersEmptyHint => 'Markiere eine Stelle im Player mit „Marker“.';

  @override
  String markersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Marker',
      one: '1 Marker',
    );
    return '$_temp0';
  }

  @override
  String get hideInSwitcherLocked =>
      'Immer an, solange die App-Sperre aktiv ist.';

  @override
  String get haptics => 'Haptisches Feedback';

  @override
  String get hapticsOff => 'Aus';

  @override
  String get hapticsLight => 'Wenig';

  @override
  String get hapticsNormal => 'Normal';

  @override
  String get feedPreviews => 'Vorschauen in Listen abspielen';

  @override
  String get feedPreviewsSubtitle =>
      'Das erste vollständig sichtbare Video spielt eine kurze Vorschau.';

  @override
  String get feedPreviewDelay => 'Vorschau startet nach';

  @override
  String secondsValue(double seconds) {
    final intl.NumberFormat secondsNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String secondsString = secondsNumberFormat.format(seconds);

    return '$secondsString s';
  }

  @override
  String get markerPreviews => 'Marker-Vorschauen abspielen';

  @override
  String get markerPreviewsSubtitle =>
      'Marker zeigen einen kurzen Clip in Dauerschleife statt eines Standbilds.';

  @override
  String get sectionAbout => 'Über';

  @override
  String get appVersion => 'Version';

  @override
  String appVersionValue(String version, String build) {
    return '$version (Build $build)';
  }

  @override
  String get openSourceLicenses => 'Open-Source-Lizenzen';

  @override
  String get openSourceLicensesSubtitle =>
      'Lizenzen der Pakete, die Stashy verwendet';

  @override
  String get aboutLegalese =>
      'Ein Client für Stash-Server. Nicht mit dem Stash-Projekt verbunden.';
}
