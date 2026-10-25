// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'StashTube';

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
  String get tabSubscriptions => 'Favoriten';

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
  String get loading => 'Wird geladen';

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
  String get sceneMoreOptions => 'Weitere Optionen';

  @override
  String durationHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Stunden',
      one: '1 Stunde',
    );
    return '$_temp0';
  }

  @override
  String durationMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Minuten',
      one: '1 Minute',
    );
    return '$_temp0';
  }

  @override
  String durationSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Sekunden',
      one: '1 Sekunde',
    );
    return '$_temp0';
  }

  @override
  String starsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Sterne',
      one: '1 Stern',
    );
    return '$_temp0';
  }

  @override
  String watchedPercent(int percent) {
    return '$percent % gesehen';
  }

  @override
  String markerAt(String time) {
    return 'Marker bei $time';
  }

  @override
  String markerFromTo(String start, String end) {
    return 'Marker von $start bis $end';
  }

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
  String get homeEmptyTitle => 'Deine Bibliothek ist noch leer';

  @override
  String get homeEmptyHint =>
      'Stash muss deine Medienordner erst scannen, bevor hier Szenen erscheinen. Starte einen Scan in den Server-Aufgaben.';

  @override
  String get openServerTasks => 'Server-Aufgaben öffnen';

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
  String get playbackFailed => 'Video konnte nicht abgespielt werden';

  @override
  String get otherQuality => 'Andere Qualität';

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
  String get addToGroup => 'Zu Gruppe hinzufügen…';

  @override
  String get addToGroupTitle => 'Zu Gruppe hinzufügen';

  @override
  String get searchGroups => 'Gruppen suchen';

  @override
  String get groupsNoMatch => 'Keine passenden Gruppen';

  @override
  String get newGroup => 'Neue Gruppe';

  @override
  String get groupName => 'Name der Gruppe';

  @override
  String addedToGroup(String group) {
    return 'Zu „$group“ hinzugefügt';
  }

  @override
  String removedFromGroup(String group) {
    return 'Aus „$group“ entfernt';
  }

  @override
  String groupUpdateFailed(String error) {
    return 'Die Gruppe konnte nicht geändert werden: $error';
  }

  @override
  String groupCreateFailed(String error) {
    return 'Die Gruppe konnte nicht angelegt werden: $error';
  }

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
  String get statsWatchHistory => 'Wiedergabeverlauf';

  @override
  String get statsChartWeeks => '12 Wochen';

  @override
  String get statsChartDays => '30 Tage';

  @override
  String get statsPlaysPerWeek => 'Wiedergaben pro Woche';

  @override
  String get statsPlaysPerDay => 'Wiedergaben pro Tag';

  @override
  String get statsChartTotal => 'Gesamt';

  @override
  String get statsChartAverage => 'Durchschnitt';

  @override
  String statsAveragePerWeek(String average) {
    return '$average pro Woche';
  }

  @override
  String statsAveragePerDay(String average) {
    return '$average pro Tag';
  }

  @override
  String statsChartSummaryWeek(int count, String average) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Wiedergaben diese Woche, $average im Durchschnitt',
      one: '1 Wiedergabe diese Woche, $average im Durchschnitt',
    );
    return '$_temp0';
  }

  @override
  String statsChartSummaryDay(int count, String average) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Wiedergaben heute, $average im Durchschnitt',
      one: '1 Wiedergabe heute, $average im Durchschnitt',
    );
    return '$_temp0';
  }

  @override
  String statsChartWeekOf(String date) {
    return 'Woche ab $date';
  }

  @override
  String statsChartBar(String period, String plays) {
    return '$period: $plays';
  }

  @override
  String get statsChartEmpty => 'Keine Wiedergaben in diesem Zeitraum';

  @override
  String get statsChartPlaysNote =>
      'Stash speichert die Wiedergabezeit pro Szene, nicht pro Wiedergabe, daher zählt das Diagramm Wiedergaben.';

  @override
  String statsChartTruncated(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Basiert auf den $countString zuletzt angesehenen Szenen.';
  }

  @override
  String get watchLaterEmpty => 'Noch nichts gespeichert';

  @override
  String get watchLaterEmptyHint =>
      'Tippe bei einer Szene auf „Später“, um sie danach anzusehen.';

  @override
  String get watchLaterDeviceOnly =>
      'Nur auf diesem Gerät gespeichert, nicht auf dem Server.';

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
  String get newPerformer => 'Neuer Darsteller';

  @override
  String get newStudio => 'Neues Studio';

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
  String get subscriptionsEmpty => 'Noch keine Favoriten';

  @override
  String get subscriptionsEmptyHint =>
      'Markiere Darsteller als Favoriten, um hier ihre neuesten Szenen zu sehen.';

  @override
  String performerHasNewScenes(String name) {
    return '$name, neue Szenen';
  }

  @override
  String newSinceLastVisit(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count neue Videos seit deinem letzten Besuch',
      one: '1 neues Video seit deinem letzten Besuch',
    );
    return '$_temp0';
  }

  @override
  String get newSinceLastVisitTitle => 'Neu seit deinem letzten Besuch';

  @override
  String get newSinceLastVisitEmpty =>
      'Nichts Neues seit deinem letzten Besuch';

  @override
  String get randomScene => 'Zufällige Szene abspielen';

  @override
  String get randomSceneNone => 'Es gibt keine Szenen zur Auswahl';

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
  String get addServerTitle => 'Einen Server hinzufügen';

  @override
  String get connectToStash => 'Mit Stash verbinden';

  @override
  String get loginIntro =>
      'Gib die Adresse deines Stash-Servers ein, z. B. 192.168.1.10. Ohne Port wird auch Stashs Standard-Port 9999 probiert.';

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
  String get signInWithPasswordHint =>
      'Statt mit API-Schlüssel. Zum Streamen auf einen Fernseher braucht es den API-Schlüssel.';

  @override
  String get username => 'Benutzername';

  @override
  String get password => 'Passwort';

  @override
  String get loginIncomplete => 'Benutzername und Passwort eingeben.';

  @override
  String get apiKeyRequired => 'API-Schlüssel eingeben.';

  @override
  String get loginAuthTitle => 'Dieser Server verlangt eine Anmeldung';

  @override
  String loginAuthServer(String name, String host) {
    return '$name · $host';
  }

  @override
  String get loginAuthIntro =>
      'Melde dich mit einem API-Schlüssel oder mit deinem Stash-Benutzernamen und Passwort an.';

  @override
  String get loginMethodPassword => 'Benutzername & Passwort';

  @override
  String get apiKeyWhere =>
      'Du findest ihn in Stash unter Settings → Security → API Key.';

  @override
  String get signIn => 'Anmelden';

  @override
  String get changeServerAddress => 'Adresse ändern';

  @override
  String get connect => 'Verbinden';

  @override
  String get tryDemo => 'Demo ausprobieren';

  @override
  String get tryDemoHint =>
      'Kein Stash-Server zur Hand? Probier die App mit Beispielvideos aus Big Buck Bunny aus, dem Open Movie der Blender Foundation (CC BY 3.0).';

  @override
  String get demoServerName => 'Demo';

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
  String castPlayFailed(String device, String error) {
    return 'Wiedergabe auf $device fehlgeschlagen: $error';
  }

  @override
  String get backToPreviousVideo => 'Zurück zum vorherigen Video';

  @override
  String get forwardToNextVideo => 'Weiter zum nächsten Video';

  @override
  String get minimize => 'Minimieren';

  @override
  String get back10 => '10 s zurück';

  @override
  String get forward10 => '10 s vor';

  @override
  String seekForwardSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Sekunden vor',
      one: '1 Sekunde vor',
    );
    return '$_temp0';
  }

  @override
  String seekBackSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Sekunden zurück',
      one: '1 Sekunde zurück',
    );
    return '$_temp0';
  }

  @override
  String get seekBar => 'Zeitleiste';

  @override
  String seekBarValue(String position, String duration) {
    return '$position von $duration';
  }

  @override
  String get pause => 'Pause';

  @override
  String get play => 'Abspielen';

  @override
  String get previousScene => 'Vorherige Szene';

  @override
  String get nextScene => 'Nächste Szene';

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
  String qualitySummary(String quality) {
    return 'Qualität: $quality';
  }

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
  String get appLockOnSummary => 'App-Sperre an';

  @override
  String get appLockOffSummary => 'App-Sperre aus';

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
  String get appIconStash => 'StashTube';

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
  String get chapters => 'Marker';

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
  String queuePosition(int position, int count) {
    return '$position / $count';
  }

  @override
  String queuePositionSemantics(int position, int count) {
    return 'Szene $position von $count';
  }

  @override
  String get addTags => 'Tags hinzufügen';

  @override
  String get editTags => 'Tags bearbeiten';

  @override
  String get showMore => '...mehr';

  @override
  String moreTags(int count) {
    return '+$count';
  }

  @override
  String moreTagsSemantics(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count weitere Tags',
      one: '1 weiterer Tag',
    );
    return '$_temp0';
  }

  @override
  String get showDescription => 'Beschreibung anzeigen';

  @override
  String get sceneDescription => 'Beschreibung';

  @override
  String get noDescription => 'Keine Beschreibung';

  @override
  String saveFailed(String error) {
    return 'Speichern fehlgeschlagen: $error';
  }

  @override
  String get removeRating => 'Bewertung entfernen';

  @override
  String get rateScene => 'Bewerten';

  @override
  String get rateThisPerformer => 'Darsteller bewerten';

  @override
  String get rateThisStudio => 'Studio bewerten';

  @override
  String get rateThisScene => 'Szene bewerten';

  @override
  String ratingButtonSemantics(String rating) {
    return 'Bewertung: $rating';
  }

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
  String get ratingLabel => 'Bewertung';

  @override
  String ratingValue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count von 5 Sternen',
      one: '1 von 5 Sternen',
      zero: 'Keine Bewertung',
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
  String oCounterLabel(int count) {
    return 'O · $count';
  }

  @override
  String oCounterSemantics(int count) {
    return 'O-Zähler: $count';
  }

  @override
  String get oCounterTitle => 'O-Zähler';

  @override
  String get removeO => 'Ein O entfernen';

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
  String markerRange(String start, String end) {
    return '$start–$end';
  }

  @override
  String markerRangeWithLength(String range, String length) {
    return '$range · $length';
  }

  @override
  String get markerEndOptional => 'Ende (optional)';

  @override
  String get markerEndSet => 'Ende auf aktuelle Position setzen';

  @override
  String get markerEndEarlier => 'Ende 5 Sekunden früher';

  @override
  String get markerEndLater => 'Ende 5 Sekunden später';

  @override
  String get markerEndClear => 'Ende entfernen';

  @override
  String get markerEndInvalid => 'Das Ende muss nach dem Start liegen.';

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
  String get connectionLostTitle => 'Server nicht erreichbar';

  @override
  String connectionLostBody(String server) {
    return '$server antwortet nicht. Bist du außerhalb deines Heimnetzes?';
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
  String get errorLocalNetworkDenied =>
      'StashTube kann dein lokales Netzwerk nicht erreichen. Erlaube es unter Einstellungen → Datenschutz & Sicherheit → Lokales Netzwerk → StashTube.';

  @override
  String get errorLocalNetworkTitle => 'Kein Zugriff aufs lokale Netzwerk';

  @override
  String get errorUnreachableTitle => 'Server nicht erreichbar';

  @override
  String get errorUnreachableHint =>
      'Prüfe, ob der Server läuft und du in seinem Netzwerk oder mit deinem VPN verbunden bist.';

  @override
  String get errorUnauthorizedTitle => 'Zugriff verweigert';

  @override
  String get errorUnauthorizedHint =>
      'Der Server hat API-Schlüssel oder Login nicht angenommen. Prüfe sie in den Servereinstellungen.';

  @override
  String get errorInvalidCredentialsTitle => 'Anmeldung fehlgeschlagen';

  @override
  String get errorNotReadyTitle => 'Server nicht bereit';

  @override
  String get errorNotReadyHint =>
      'Der Server läuft, ist aber noch nicht eingerichtet. Schließe die Einrichtung in der Weboberfläche von Stash ab.';

  @override
  String get errorNotFoundTitle => 'Nicht gefunden';

  @override
  String get errorNotFoundHint =>
      'Vielleicht wurde es auf dem Server gelöscht oder verschoben.';

  @override
  String get errorServerHint =>
      'Der Server hat einen Fehler gemeldet. Die Details helfen vielleicht weiter.';

  @override
  String get errorUnexpectedHint =>
      'Etwas Unerwartetes ist passiert. Versuche es erneut oder sieh dir die Details an.';

  @override
  String get errorShowDetails => 'Details';

  @override
  String get errorHideDetails => 'Details ausblenden';

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
  String get imageInfo => 'Bildinfo';

  @override
  String get imagePhotographer => 'Fotograf';

  @override
  String get imageDimensions => 'Abmessungen';

  @override
  String get imageOCounter => 'O-Zähler';

  @override
  String get imageTags => 'Tags';

  @override
  String get imageGalleries => 'Galerien';

  @override
  String get imageCreated => 'Hinzugefügt';

  @override
  String get imageUpdated => 'Aktualisiert';

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
  String get shortsMaxLengthHint =>
      'Nur für Videos: Ein Marker spielt seine markierte Stelle.';

  @override
  String get shortsPortraitOnly => 'Nur Hochkant-Videos';

  @override
  String get shortsContent => 'Inhalt';

  @override
  String get shortsContentHint =>
      'Marker spielen die markierte Stelle einer Szene als Short.';

  @override
  String get shortsContentVideos => 'Nur Videos';

  @override
  String get shortsContentMixed => 'Videos & Marker';

  @override
  String get shortsContentMarkers => 'Nur Marker';

  @override
  String shortMarkerSemantics(String title) {
    return 'Marker: $title';
  }

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
  String get sectionPreviewsCards => 'Vorschauen & Karten';

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
  String get gestureTipsTitle => 'Gesten im Player';

  @override
  String gestureTipDoubleTap(int seconds) {
    return 'Links oder rechts doppeltippen: $seconds s zurück/vor, weitertippen springt weiter';
  }

  @override
  String get gestureTipHold => 'Halten: 2× Tempo';

  @override
  String get gestureTipPinch => 'Mit zwei Fingern spreizen: Zoom';

  @override
  String get gestureTipSwipeDown => 'Nach unten wischen: minimieren';

  @override
  String get gestureTipsDone => 'Verstanden';

  @override
  String get showGestureTipsAgain => 'Gesten-Tipps erneut zeigen';

  @override
  String get showGestureTipsAgainSubtitle =>
      'Wenn die Player-Steuerung das nächste Mal erscheint';

  @override
  String get sectionDoubleTapSeek => 'Doppeltippen zum Spulen';

  @override
  String get doubleTapSeek => 'Spulen per Doppeltippen';

  @override
  String get doubleTapSeekSubtitle =>
      'Links oder rechts auf das Video doppeltippen. Aus: Ein Tippen zeigt die Steuerung sofort.';

  @override
  String get seekStep => 'Sprungweite';

  @override
  String get seekCumulative => 'Weitertippen springt immer weiter';

  @override
  String seekSequenceExample(String totals) {
    return 'Insgesamt: $totals s …';
  }

  @override
  String get lockTouch => 'Bildschirm sperren';

  @override
  String get touchLocked => 'Bildschirm gesperrt';

  @override
  String get holdToUnlock => 'Zum Entsperren halten';

  @override
  String get unlockTouch => 'Entsperren';

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
  String get moreViews => 'Weitere Ansichten';

  @override
  String get tabYou => 'Du';

  @override
  String get colorStashTube => 'StashTube';

  @override
  String get searchScenes => 'Szenen suchen';

  @override
  String get searchGalleries => 'Galerien suchen';

  @override
  String searchNoResults(String term) {
    return 'Nichts gefunden zu „$term“';
  }

  @override
  String searchFor(String text) {
    return 'Nach $text suchen';
  }

  @override
  String get searchFillIn => 'Übernehmen';

  @override
  String searchFillInText(String text) {
    return '$text übernehmen';
  }

  @override
  String searchRemoveFromHistory(String text) {
    return '$text aus den letzten Suchen entfernen';
  }

  @override
  String get searchGoTo => 'Direkt zu';

  @override
  String get searchOtherAreas => 'In anderen Bereichen suchen';

  @override
  String get searchClearFilters => 'Filter zurücksetzen';

  @override
  String get searchFiltersActiveHint =>
      'Aktive Filter blenden womöglich Treffer aus.';

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
  String get channelTabVideos => 'Videos';

  @override
  String get channelTabShorts => 'Shorts';

  @override
  String get channelTabMarkers => 'Marker';

  @override
  String get channelTabImages => 'Bilder';

  @override
  String get channelTabGalleries => 'Galerien';

  @override
  String get channelTabAbout => 'Info';

  @override
  String get channelAboutEmpty => 'Hier gibt es noch nichts';

  @override
  String get channelLinks => 'Links';

  @override
  String get copyLink => 'Link kopieren';

  @override
  String get linkCopied => 'Link kopiert';

  @override
  String get openLink => 'Link öffnen';

  @override
  String openLinkFailed(String url) {
    return '$url konnte nicht geöffnet werden';
  }

  @override
  String get openInStash => 'In Stash öffnen';

  @override
  String get fieldAliases => 'Auch bekannt als';

  @override
  String get fieldDeathDate => 'Gestorben';

  @override
  String get fieldCountry => 'Land';

  @override
  String get fieldEthnicity => 'Ethnie';

  @override
  String get fieldHairColor => 'Haarfarbe';

  @override
  String get fieldEyeColor => 'Augenfarbe';

  @override
  String get fieldHeight => 'Größe';

  @override
  String get fieldWeight => 'Gewicht';

  @override
  String get fieldMeasurements => 'Maße';

  @override
  String get fieldCareer => 'Karriere';

  @override
  String get fieldTattoos => 'Tattoos';

  @override
  String get fieldPiercings => 'Piercings';

  @override
  String heightCm(int cm) {
    return '$cm cm';
  }

  @override
  String weightKg(int kg) {
    return '$kg kg';
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
  String get markersPlayAsShorts => 'Als Shorts abspielen';

  @override
  String get markerPlayAsShort => 'Als Short abspielen';

  @override
  String get markerMoreOptions => 'Marker-Optionen';

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
  String get previewsOffSummary => 'Vorschauen aus';

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
  String get previewsWifiOnly => 'Nur im WLAN';

  @override
  String get previewsWifiOnlySubtitle =>
      'Über mobile Daten spielen keine Vorschauen.';

  @override
  String get previewsHint =>
      'Vorschauen brauchen Stashs animierte (WebP-)Vorschauen, die Stash standardmäßig nicht erstellt. Erzeuge sie in Stash unter Einstellungen → Aufgaben → Generieren mit „Animierte Bildvorschauen“ und „Animierte Vorschau für Markierungen“.';

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
      'Lizenzen der Pakete, die StashTube verwendet';

  @override
  String get aboutLegalese =>
      'Ein Client für Stash-Server. Nicht mit dem Stash-Projekt verbunden.';

  @override
  String get pinTooManyAttempts => 'Zu viele falsche PINs.';

  @override
  String pinTryAgainIn(String time) {
    return 'Neuer Versuch in $time.';
  }

  @override
  String get insecureConnectionTitle => 'Unverschlüsselte Verbindung';

  @override
  String insecureConnectionBody(String host) {
    return '$host liegt außerhalb deines Heimnetzes und wird über unverschlüsseltes HTTP erreicht. Dein API-Key oder Passwort und alles, was du ansiehst, können unterwegs mitgelesen werden. Nutze https:// oder ein VPN.';
  }

  @override
  String get connectAnyway => 'Trotzdem verbinden';

  @override
  String get castApiKeyHint =>
      'Beim Streamen erhält das Cast-Gerät die Stream-Adresse samt deinem API-Key. Andere Geräte in diesem WLAN können sie unter Umständen auslesen.';

  @override
  String get serverTasks => 'Server-Aufgaben';

  @override
  String get serverTasksSubtitle => 'Scannen, Generieren, Vorschauen prüfen';

  @override
  String get sectionPreviewCheck => 'Vorschauen auf dem Server';

  @override
  String get previewCheckAnimated => 'Animierte Vorschauen (WebP)';

  @override
  String get previewCheckVideo => 'Video-Vorschauen (MP4)';

  @override
  String get previewCheckMarkers => 'Marker-Vorschauen (WebP)';

  @override
  String previewCheckFound(int found, int checked) {
    return 'Bei $found von $checked Stichproben vorhanden';
  }

  @override
  String get previewCheckNothing => 'Keine Szenen zum Prüfen';

  @override
  String get previewCheckMissingHint =>
      'Listen und Marker spielen die animierten Vorschauen, die Stash standardmäßig nicht erstellt. Erzeuge sie hier oder stelle in den Einstellungen das Vorschau-Format auf Video um.';

  @override
  String get generateAnimatedPreviews => 'Animierte Vorschauen erzeugen';

  @override
  String get checkAgain => 'Erneut prüfen';

  @override
  String get sectionTasks => 'Aufgaben';

  @override
  String get taskScan => 'Bibliothek scannen';

  @override
  String get taskScanSubtitle => 'Findet neue und geänderte Dateien';

  @override
  String get taskGenerate => 'Generieren';

  @override
  String get taskGenerateSubtitle =>
      'Vorschauen, Sprites, Cover u. a. für Dateien, denen sie fehlen';

  @override
  String get taskAutoTag => 'Automatisch taggen';

  @override
  String get taskAutoTagSubtitle =>
      'Ordnet Darsteller, Studios und Tags zu, die in Dateipfaden vorkommen';

  @override
  String get taskClean => 'Aufräumen';

  @override
  String get taskCleanSubtitle =>
      'Entfernt Einträge von Dateien, die es nicht mehr gibt';

  @override
  String get taskCleanConfirm =>
      'Einträge fehlender Dateien aus der Bibliothek entfernen? Ihre Bewertungen, Wiedergaben und Marker gehen verloren.';

  @override
  String get taskScanGenerates => 'Für neue Dateien auch erzeugen';

  @override
  String get startTask => 'Starten';

  @override
  String get taskStarted => 'Aufgabe auf dem Server gestartet';

  @override
  String taskFinishedNamed(String task) {
    return 'Fertig: $task';
  }

  @override
  String taskFailedNamed(String task) {
    return 'Fehlgeschlagen: $task';
  }

  @override
  String get sectionNotifications => 'Benachrichtigungen';

  @override
  String get systemNotifications => 'Systembenachrichtigungen';

  @override
  String get systemNotificationsSubtitle =>
      'Meldet, wenn eine von dir gestartete Server-Aufgabe endet, während StashTube im Hintergrund ist. Nur solange das System die App laufen lässt: Android beendet sie nach einer Weile, iOS pausiert sie kurz nach dem Verlassen.';

  @override
  String get discreetNotifications => 'Diskrete Benachrichtigungen';

  @override
  String get discreetNotificationsSubtitle =>
      'Nur „StashTube“ und ein neutraler Text, ohne Aufgaben- oder Servernamen. Auf dem Sperrbildschirm ausgeblendet.';

  @override
  String get notificationsDenied => 'Benachrichtigungen nicht erlaubt';

  @override
  String get notificationsDeniedBody =>
      'StashTube darf keine Benachrichtigungen zeigen. Erlaube sie in den Systemeinstellungen und schalte sie dann hier wieder ein.';

  @override
  String get notificationTaskFinished => 'Eine Aufgabe ist fertig';

  @override
  String get notificationTaskFailed => 'Eine Aufgabe ist fehlgeschlagen';

  @override
  String get sectionJobs => 'Laufende Aufgaben';

  @override
  String get noJobs => 'Keine laufenden Aufgaben';

  @override
  String get stopJob => 'Aufgabe abbrechen';

  @override
  String get jobReady => 'Wartet';

  @override
  String get jobRunning => 'Läuft';

  @override
  String get jobFinished => 'Fertig';

  @override
  String get jobStopping => 'Wird abgebrochen';

  @override
  String get jobCancelled => 'Abgebrochen';

  @override
  String get jobFailed => 'Fehlgeschlagen';

  @override
  String get optionRescan => 'Unveränderte Dateien neu scannen';

  @override
  String get optionCovers => 'Cover';

  @override
  String get optionPreviews => 'Video-Vorschauen (MP4)';

  @override
  String get optionImagePreviews => 'Animierte Vorschauen (WebP)';

  @override
  String get optionSprites => 'Vorschaubilder der Zeitleiste (Sprites)';

  @override
  String get optionMarkers => 'Marker-Vorschauen (MP4)';

  @override
  String get optionMarkerImagePreviews => 'Animierte Marker-Vorschauen (WebP)';

  @override
  String get optionMarkerScreenshots => 'Marker-Standbilder';

  @override
  String get optionPhashes => 'Wahrnehmungs-Hashes (Duplikate)';

  @override
  String get previewSource => 'Vorschau-Format';

  @override
  String get previewSourceAnimated => 'Animiertes Bild (WebP)';

  @override
  String get previewSourceVideo => 'Video (MP4)';

  @override
  String get previewSourceVideoHint =>
      'Video-Vorschauen nutzen den Video-Decoder des Telefons und laufen flüssig; jede öffnet kurz einen eigenen Videoplayer. Animierte Bilder werden Bild für Bild dekodiert und können bei großen Vorschauen ruckeln. Marker spielen weiter die WebP-Vorschauen.';

  @override
  String get previewsOnServer => 'Vorschauen auf dem Server prüfen';

  @override
  String get previewsOnServerSubtitle =>
      'Ob Stash sie erstellt hat, und fehlende erzeugen';
}
