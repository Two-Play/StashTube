# UX/UI-Review StashTube – Phase 1 (Vorschlag)

Stand: 24.10.2026, Branch `feature/ux-review` (von `develop`). Grundlage: README-Screenshots (`docs/images/screenshots/`), Code unter `lib/` und `docs/BACKLOG.md`. **Noch keine Codeänderungen**: Phase 2 beginnt erst nach Freigabe einzelner IDs.

Maßstab: Material Design 3, Apple Human Interface Guidelines, WCAG 2.2 AA, Flutter-Best-Practices.

## 0. Einordnung

StashTube ist kein YouTube mit Konten, sondern ein Client für die **eigene** Stash-Bibliothek. Einige Bereiche aus dem Auftrag gibt es daher nicht 1:1; sie werden so übersetzt:

| Auftrag | Entspricht in StashTube |
|---|---|
| Playlists | Gruppen (Groups/Movies), „Später ansehen“, Wiedergabe-Warteschlange |
| User Profiles | Kanalseiten von Performern und Studios |
| Subscriptions | Favoriten-Performer („Neu von Favoriten“, Story 6.5) |
| Notifications | gibt es nicht (kein Push von Stash); siehe Ideen |
| Upload Flow | gibt es nicht (Stash indiziert Dateien auf dem Server); nächstes Gegenstück: Server-Aufgaben (Scan) |
| Onboarding | Login, Demo, Design-Auswahl nach dem ersten Login |

**Gesamturteil:** Die App ist funktional sehr weit (Player-Transition, Shorts, Cast/AirPlay, PiP, App-Sperre, Lokalisierung, Kontrastprüfung des Akzents, reduzierte Bewegung). Die größten Hebel liegen nicht in neuen Funktionen, sondern in **Fehler-Feedback beim Abspielen**, **Barrierefreiheit (Screenreader, Textgröße, Trefferflächen)**, **Informationsarchitektur der Bibliothek/Navigation** und **visueller Gewichtung auf der Watch-Seite und der Startseite**.

Stärken, die erhalten bleiben sollen: ein Miniplayer, der sich nahtlos aufzieht; ausblendende App-Bar auf Home; Leer-/Fehleransichten mit Retry in `PagedSliver`; zentrale Haptik; reduzierte Bewegung wird respektiert; Akzentfarbe mit WCAG-Prüfung im Test; konfigurierbare Navigationsleiste.

---

## 1. Befunde nach Bereich

Format je Befund: **Problem** · **Warum** · **Lösung** · **Nutzen** · **Priorität**. Die IDs dienen zur Freigabe.

### 1.1 Navigation & Informationsarchitektur

**NAV-1 Bibliothek bündelt zu viel** · Die Bibliothek hat 8 Unter-Tabs (Szenen, Verlauf, Später, Gruppen, Marker, Bilder, Galerien, Statistik) in einer scrollenden Icon+Text-TabBar; „Watch later“ ist im Screenshot links abgeschnitten. Persönliche Listen, Medientypen und Statistik stehen gleichrangig nebeneinander. · Scrollende Tabs verstecken Ziele (Discoverability), Icon+Label-Tabs kosten ~72 dp Höhe, die Mischung aus „meins“ und „alles“ hat kein klares mentales Modell. · Zwei Ebenen: **„Du“** (Verlauf, Später ansehen, Gruppen/Playlists, Marker, Statistik – YouTube-„Du“-Seite mit horizontalen Reihen und „Alle ansehen“) und **„Bibliothek“** (Szenen, Bilder, Galerien als Segmented Button/Filter-Chips statt Tabs). Tabs ohne Icons (nur Text) oder `SegmentedButton`. · Schnellere Orientierung, weniger Höhe verschwendet, keine abgeschnittenen Tabs. · **Hoch**

**NAV-2 Mehrfache Einstiege ohne klare Hierarchie** · Shorts: App-Bar-Icon auf Home, Shorts-Regal auf Home, optionaler Tab. Statistik: optionaler Tab und Bibliotheks-Unter-Tab. Einstellungen: Zahnrad in jeder App-Bar und Kachel in „Alle“. · Viele gleichwertige Wege erhöhen die kognitive Last; das Home-App-Bar hat 4 Icons (Cast, Shorts, Suche, Einstellungen) oben rechts – außerhalb der Daumenzone. · Pro Ziel ein primärer Weg: Shorts als Standard-Tab (statt App-Bar-Icon), Einstellungen über einen **Server-Avatar** oben rechts (öffnet Konto-/Server-Sheet mit Serverwechsel, Einstellungen, Server-Aufgaben – YouTube-Muster), Statistik nur unter „Du“. · Ruhigere App-Bars, klareres Modell. · **Mittel**

**NAV-3 „Alle“-Tab belegt einen von 5 Plätzen** · Der feste letzte Tab ist ein Raster der übrigen Ansichten. · Ein Navigations-Slot nur für Navigation ist teuer; M3 empfiehlt 3–5 Hauptziele. · „Alle“ in die „Du“-Seite (NAV-1) integrieren („Weitere Ansichten“) oder als `NavigationDrawer`/Sheet hinter dem Avatar. Standardleiste: **Home · Shorts · Suche · Bibliothek · Du**. · Ein Slot mehr für häufig genutzte Ziele. · **Mittel**

**NAV-4 Tablets/Querformat nutzen die Bottom-Bar** · Ab 600 dp gibt es Spalten, aber weiterhin eine `NavigationBar` unten. · M3 sieht ab „medium“ (600 dp) eine `NavigationRail` vor; auf iPad ist eine Seitenleiste üblich. · `AdaptiveScaffold`-Muster: Bar < 600 dp, Rail 600–1240 dp, Drawer ≥ 1240 dp. · Bessere Tablet-Ergonomie. · **Niedrig**

**NAV-5 Leere Architektur-Ordner** · `lib/features/mini_player`, `template`, `video_player` enthalten nur leere `data/domain/graphql/presentation`-Ordner. · Verwirrt beim Einstieg, widerspricht der dokumentierten Struktur. · Entfernen. · Saubere Codebasis. · **Niedrig**

### 1.2 Startseite (Home Feed)

**HOME-1 Shorts-Regal dominiert den ersten Bildschirm** · Das 2×2-Raster hochkanter Kacheln nimmt fast eine Bildschirmhöhe ein; Sortier-Chips und gespeicherte Filter des Hauptfeeds liegen erst darunter. · Der eigentliche Feed und seine Steuerung sind beim Start unsichtbar (Visual Hierarchy, Discoverability). · Shorts als **horizontale Reihe** (9:16, ~2,3 Kacheln sichtbar, Höhe ~240 dp); Sortier-/Filter-Chips als **sticky Chip-Leiste** unter der App-Bar (wie YouTube „Alle · Neu · Zufällig …“). · Mehr Inhalt „above the fold“, Filter jederzeit erreichbar. · **Hoch**

**HOME-2 Laden nur mit Spinner** · `LoadingView` (zentraler `CircularProgressIndicator`) überall; 13 Spinner-Stellen, keine Skeletons. · Spinner erzeugen Layout-Sprünge, wenn Karten erscheinen, und wirken langsamer (Performance-UX). · `SceneCardSkeleton`/`GridTileSkeleton` mit dezenter Puls-Animation (abgeschaltet bei reduzierter Bewegung) in `PagedSliver`, Regalen und Up-next. · Gefühlt schnelleres Laden, stabiles Layout. · **Mittel**

**HOME-3 Leere Bibliothek ohne Anleitung** · Ein neuer Server ohne gescannte Szenen zeigt „Nothing here yet“. · Erstnutzer wissen nicht, dass Stash erst scannen muss. · Home-Leerzustand mit Erklärung und Aktion „Server-Aufgaben → Scan starten“. · Weniger Abbrüche nach dem ersten Login. · **Mittel**

**HOME-4 Kanal-Avatar-Platzhalter** · Studios ohne Bild zeigen ein generisches Personen-Icon (Player- und Kanal-Screenshot). · Ein Personen-Icon für ein Studio ist semantisch falsch und sieht nach „fehlt“ aus. · Initialen im `primaryContainer`-Kreis bzw. Studio-Icon (`Icons.business`) für Studios. · Wertigerer Eindruck. · **Niedrig**

**HOME-5 Kontextmenü uneinheitlich** · `SceneCard` hat ⋮, `SceneGridTile` nur Long-Press. · Inkonsistent, Long-Press ist nicht auffindbar und für Screenreader schwer. · Überall ⋮ (oder Long-Press **plus** sichtbares ⋮) mit identischem Sheet. · Vorhersehbarkeit. · **Niedrig**

### 1.3 Watch-Seite

**WATCH-1 Kein Feedback bei Wiedergabefehlern** · `player.stream.error` wird nirgends ausgewertet; schlägt ein Stream fehl (Codec, 404, Auth), bleibt das Video schwarz bzw. puffert. Cast-Fehler landen nur in `debugPrint` (`player_providers.dart`). · Nutzer können nicht unterscheiden zwischen „lädt“ und „kaputt“ und haben keine Handlungsoption (WCAG 3.3.1 sinngemäß, Missing Feedback). · Fehler-Overlay im Video: Ursache in Klartext (`errorText`), Buttons „Erneut versuchen“, „Andere Qualität“ (öffnet Stream-Sheet), bei Cast eine Snackbar mit Grund. Timeout-Hinweis bei > 15 s Puffern. · Vertrauen, weniger „App ist kaputt“. · **Hoch**

**WATCH-2 Flache Detailstruktur** · Unter dem Video stehen gleichgewichtet untereinander: Titel, Meta, 5 große Sterne, 4 Chips (O-Zähler „💧 0“, Später, Bearbeiten, Marker), Studio-Zeile, Performer-Chips, Tag-Chips, Kapitel, Beschreibung, Datei-Info, dann Up next. · Up next beginnt erst weit unten; die wichtigste Entscheidung („was als Nächstes?“) liegt unter dem Fold. Bearbeiten/Datei-Info sind selten genutzt, stehen aber prominent. · YouTube-Struktur: (1) Titel + Meta-Zeile „…mehr“ → **Beschreibungs-Sheet** (Beschreibung, Tags, Datei-Info, Bearbeiten); (2) Kanalzeile (Studio-Avatar, Name, Favorit-Button); (3) **eine** scrollbare Aktionsleiste als Pill-Buttons: Bewertung (öffnet kompakten Sternen-Picker), O, Später, Marker, Teilen, ⋯; (4) Performer-Reihe; (5) Kapitel; (6) Up next. · Kürzerer Weg zu Up next, klarere Hierarchie. · **Hoch**

**WATCH-3 O-Zähler ohne Bedeutung** · Tropfen-Icon mit „0“ ohne Label. · Unklar für neue Nutzer und Screenreader (Tooltip nur bei Long-Press). · Label „O · 0“ bzw. Semantik „O-Zähler 0, erhöhen“; im Overflow konfigurierbar ausblendbar. · Verständlichkeit, Diskretion. · **Niedrig**

**WATCH-4 Feste Höhen für Chip-Reihen** · Performer-Reihe `SizedBox(height: 48)`, Tag-Reihe `height: 44` (insgesamt 15 feste Höhen im UI-Code), Sterne mit `VisualDensity.compact`. · Bei großer Schrift (iOS Dynamic Type / Android 200 %) werden Chips abgeschnitten (WCAG 1.4.4, 1.4.10); kompakte Ziele unterschreiten 48×48 dp (M3) bzw. 44×44 pt (HIG). · Höhen aus `MediaQuery.textScalerOf` ableiten oder `Wrap` mit „mehr anzeigen“ statt fester horizontaler Listen; keine `compact`-Dichte für primäre Ziele. · Nutzbar mit großer Schrift. · **Mittel**

**WATCH-5 Titel-Tippen ohne Affordanz** · Titel klappt per `GestureDetector` auf, ohne Hinweis und ohne Semantik. · Versteckte Funktion. · Mit WATCH-2 entfällt sie (Tippen auf Titel/Meta öffnet das Beschreibungs-Sheet, mit Chevron). · **Niedrig**

### 1.4 Player-Steuerung

**CTRL-1 Miniplayer-Play/Pause ohne Tooltip/Label** · In `_MiniInfo` haben die Play/Pause-Buttons kein `tooltip`. · Screenreader liest nur „Schaltfläche“ (WCAG 4.1.2). · `tooltip: playing ? pause : play`. · **Hoch** (Quick Win)

**CTRL-2 Versteckte Gesten** · Halten = 2×, Doppeltipp = ±10 s, Pinch = Zoom, Wischen = minimieren – alles ohne Hinweis. · Discoverability. · Einmalige, abschaltbare Coach-Marks beim ersten Öffnen des Players; zusätzlich „Tipps“ in den Einstellungen. · Mehr Nutzer finden die Funktionen. · **Niedrig**

**CTRL-3 Kein Bildschirm-Lock im Vollbild** · Beim Ansehen im Bett/unterwegs lösen versehentliche Berührungen Seek/Pause aus. · Ergonomie. · Lock-Knopf in den Vollbild-Controls (sperrt Touch bis Entsperr-Geste). · **Niedrig** (Feature-Idee)

**CTRL-4 Warteschlange in den Controls** · Läuft eine Queue (Später ansehen, Gruppe), gibt es in den Controls keine Vor/Zurück-Buttons. · Für Playlists erwartet (YouTube, iOS-Mediaplayer). · Bei aktiver Queue ⏮ ⏭ neben Play/Pause; Fortschritt „3/12“ im Up-next-Kopf. · **Mittel**

### 1.5 Suche

**SEARCH-1 Keine Vorschläge beim Tippen** · Ergebnisse erscheinen erst nach Debounce als volle Liste. · Performer/Tags/Studios sind häufige Ziele; ein Vorschlags-Dropdown ist schneller als Scope-Wechsel. · Typeahead-Liste unter dem Feld: passende Performer, Tags, Studios (je 3) plus „Szenen zu ‚…‘ suchen“. · Weniger Taps. · **Mittel**

**SEARCH-2 Leere Treffer ohne Ausweg** · Leere Ergebnisse zeigen nur den Text. · Kein nächster Schritt. · Aktionen „In allen Bereichen suchen“, „Filter zurücksetzen“ (wenn aktiv). · **Niedrig**

### 1.6 Playlists (Gruppen, Später ansehen, Queue)

**PL-1 Kein „Zur Playlist hinzufügen“** · Szenen können nur zu „Später ansehen“ (lokal, pro Gerät). Gruppen sind nur lesbar. · Nutzer erwarten eigene Listen. · ⋮ → „Zu Gruppe hinzufügen…“ (Stash `groupUpdate`/`sceneUpdate` mit `groups`), Sheet mit Liste + „Neue Gruppe“. · Echte, serverseitige Playlists. · **Mittel**

**PL-2 „Später ansehen“ nicht synchron** · Lokal gespeichert; auf einem zweiten Gerät leer. · Überraschung bei mehreren Geräten. · Hinweis im Leerzustand („auf diesem Gerät“) als Quick Win; optional später als Stash-Gruppe „Watch later“ speichern. · **Niedrig**

### 1.7 Kanalseiten (Performer/Studios)

**CH-1 Name doppelt** · Name in App-Bar und Header gleichzeitig (Screenshot). · Verschwendete Höhe, unruhig. · `SliverAppBar` (large/medium), der Titel erscheint erst beim Wegscrollen des Headers. · **Niedrig** (Quick Win)

**CH-2 Kanal ohne Tabs** · Header, „1 Short“-Button, Sortier-Chips, Szenen. Bilder, Galerien, Gruppen und Infos (Alter, Maße, Links) sind nicht oder schwer erreichbar. · Profil-IA unvollständig. · Tabs: **Videos · Shorts · Bilder · Galerien · Info** (sticky `TabBar` unter dem Header). · Vollständige Kanalseite. · **Mittel**

### 1.8 Abos (Favoriten)

**SUB-1 Kein Abo-Feed** · Nur die Reihe „Neu von Favoriten“ auf Home (Story 6.5 🟡). · Kernmuster von Videoplattformen fehlt. · Ansicht „Abos“: horizontale Avatarreihe der Favoriten (mit Punkt bei Neuem seit letztem Besuch) und Feed der neuesten Szenen; als optionaler Tab. · **Mittel**

### 1.9 Benachrichtigungen

**NOTIF-1 Keine Rückmeldung über Neues** · Es gibt keine Benachrichtigungen. · Neue Szenen fallen nicht auf. · In-App: Badge „N neu seit letztem Besuch“ (Zeitstempel lokal, `created_at`-Filter) auf Home/Abos; optional lokale Benachrichtigung, wenn eine gestartete Server-Aufgabe fertig ist. Kein Push-Backend nötig. · **Niedrig** (Feature-Idee)

### 1.10 Einstellungen

**SET-1 Eine lange Liste** · ~35 Einträge in 7 Abschnitten auf einer Seite; technische Vorschau-Optionen mitten zwischen Darstellung und Wiedergabe; „Diesen Server entfernen“ (destruktiv) unten in derselben Liste. · Schwer scanbar, destruktive Aktion zu nah an normalen Einträgen. · Startseite mit Kategorien (iOS-Settings-Stil, je Icon + Zusammenfassung): **Server · Darstellung · Wiedergabe · Vorschauen & Karten · Datenschutz & Sicherheit · Über**; „Server entfernen“ nur auf der Server-Unterseite, mit Bestätigung. · Schnelleres Finden. · **Mittel**

### 1.11 Onboarding & Login

**ONB-1 Alle Anmeldearten gleichzeitig** · Login-Formular: Name, URL, API-Key, Benutzername, Passwort auf einer Seite. · Nutzer wissen nicht, was sie brauchen. · Zweistufig: (1) URL eingeben → „Verbinden“; (2) nur wenn der Server 401 meldet: Wahl **API-Key** oder **Benutzername/Passwort** (`SegmentedButton`) mit Hilfetext „Wo finde ich den API-Key?“. Name optional am Ende. „Demo ausprobieren“ als sekundärer Button sichtbar bleiben. · Weniger Fehler beim Einrichten. · **Mittel**

**ONB-2 Lokales Netzwerk (iOS)** · Prüfen, ob ein abgelehnter Local-Network-Zugriff eine verständliche Meldung erzeugt (bisher generischer Verbindungsfehler). · **Niedrig**

### 1.12 Querschnitt: Barrierefreiheit

**A11Y-1 Karten werden zerstückelt vorgelesen** · Nur 7 `Semantics`-Stellen im UI-Code. Szenenkarten lesen Titel, Kanal, Meta, Dauer-Badge, Auflösung einzeln. · Screenreader-Nutzer brauchen 5+ Wischgesten pro Karte (WCAG 1.3.1, 2.4.6). · `MergeSemantics`/`Semantics(label:)` je Karte: „Titel, Studio, 12 Minuten, 3 Aufrufe, 4 Sterne, 40 % gesehen“; Badges `ExcludeSemantics`; ⋮ als eigene Aktion (`customSemanticsActions`). · **Hoch**

**A11Y-2 Bewertung nicht als Einheit** · Fünf einzelne Stern-Buttons. · Kein Kontext „4 von 5“. · Ein `Semantics(slider)`-Element mit `increase/decrease` bzw. Gruppe mit Label „Bewertung: 4 von 5“. · **Mittel**

**A11Y-3 Textskalierung nicht getestet** · Keine Tests mit großem `TextScaler`. · Regressionen fallen nicht auf. · Golden-/Widget-Tests der Hauptseiten bei 1,0 / 1,5 / 2,0. · **Mittel**

**A11Y-4 Gelber Stern fest codiert** · `Colors.amber.shade600` für Sterne. · Im Hellmodus auf Weiß ~2,1:1 (WCAG 1.4.11 verlangt 3:1 für Grafiken). · Token `ratingColor` je Modus (dunkleres Amber im Hellmodus). · **Niedrig**

### 1.13 Querschnitt: Lade-, Leer-, Fehler- und Offline-Zustände

**STATE-1 Server nicht erreichbar = n Fehlerseiten** · Ist der Server weg (unterwegs ohne VPN), zeigt jede Liste ihren eigenen `ErrorView`. · Wiederholt, ohne Hinweis auf die Ursache „du bist nicht im Heimnetz“. · Globales **Verbindungsbanner** (M3 Banner oben): „Server nicht erreichbar · Erneut versuchen · Server wechseln“, ausgelöst durch `isNetworkError`; Listen behalten zuletzt geladene Inhalte (Basis für Story 12.2). · **Hoch**

**STATE-2 Fehlertexte technisch** · `ErrorView` zeigt bis zu 6 Zeilen Fehlertext im `bodySmall`. · Kleine Schrift, technisch. · Kurze Überschrift + menschliche Erklärung, Details hinter „Details“. · **Niedrig**

### 1.14 Querschnitt: Dark Mode & Konsistenz

**DS-1 Uneinheitliche Chips und Buttons** · Player nutzt `ActionChip`s als Aktionen, Kanalseite `OutlinedButton`/`FilledButton`, Shorts eine Icon-Spalte; Chip-Höhen variieren (`compact` vs. normal). · Kein klarer Unterschied zwischen *Filter*, *Aktion* und *Navigation*. · Regel: Filter = `FilterChip`/`ChoiceChip`; Aktionen = `FilledButton.tonal`/Pill-Button; Navigation = `ListTile`/Avatar-Chip. Zentral in `ThemeData` (chipTheme, buttonTheme) statt pro Widget. · **Mittel**

**DS-2 Typografie- und Abstands-Tokens** · 17 `fontSize`-Literale und viele magische Abstände (12/16/20/40/56). · Inkonsistenz, schwer änderbar. · `AppSpacing` (4/8/12/16/24/32), nur `textTheme`-Stile, eigene `ThemeExtension` für App-Farben (Rating, Overlay-Scrim, Badge). · **Mittel**

Dark Mode selbst ist konsistent (Farben aus dem `ColorScheme`, Akzent pro Modus geprüft); feste Weiß/Schwarz-Werte stehen fast nur über Video, wo sie richtig sind.

### 1.15 Performance-UX

- Spinner statt Skeletons (HOME-2).
- Up next und Regale laden erst nach dem Video-Start; ein Skeleton verhindert das „Springen“ der Details.
- Bild-Dekodierung ist bereits auf die Anzeigebreite begrenzt (`memCacheWidth`) – gut.
- Animierte Vorschauen sind abschaltbar und verzögert – gut; Hinweis auf Datenverbrauch nur bei MP4 vorhanden, bei Mobilfunk könnte die Standard-Einstellung „nur im WLAN“ sein (**PERF-1**, Niedrig).

---

## 2. Priorisierte Pakete

### Quick Wins (klein, hohe Wirkung)

Alle Quick Wins sind auf `feature/ux-review` umgesetzt (Phase 2, Schritt 1).

| ID | Änderung | Status |
|---|---|---|
| CTRL-1 | Tooltips/Labels für Miniplayer-Play/Pause | ✅ |
| WATCH-1a | Snackbar bei Cast-Fehlern; Fehler-Overlay bei `player.stream.error` mit Retry und „Andere Qualität“ (nach 2 s ohne Fortschritt) | ✅ (Overlay noch nicht im Vollbild) |
| A11Y-1 | Ein Screenreader-Knoten je Kachel (Szenen, Regal, Marker, Galerien, Shorts, Performer) | ✅ |
| CH-1 | Kanalname nur einmal (Titel blendet beim Scrollen ein) | ✅ |
| HOME-4 | Initiale statt Personen-Icon bei fehlendem Bild | ✅ |
| HOME-5 | ⋮ auf Grid-Kacheln und Regalkarten, Long-Press bleibt | ✅ (Trefferfläche 36×48 dp) |
| A11Y-4 | Rating-Farbe als Token `AppColors.rating` je Modus | ✅ |
| PL-2 | „Nur auf diesem Gerät gespeichert“-Hinweis bei Später ansehen | ✅ |
| NAV-5 | Leere Feature-Ordner entfernt | ✅ |
| WATCH-3 | O-Zähler beschriftet („O · 3“, Screenreader-Label) | ✅ |

### Medium Improvements

| ID | Änderung | Status |
|---|---|---|
| HOME-1 | Shorts als horizontale Reihe, sticky Sortier-/Filter-Chips | ✅ |
| HOME-2 | Skeleton-Komponenten für Karten, Tiles, Regale, Up next | ✅ |
| HOME-3 | Geführter Leerzustand für neue Server | ✅ |
| WATCH-4 / A11Y-3 | Feste Höhen entfernen, Trefferflächen ≥ 48 dp, Textskalierungs-Tests | ✅ (`text_scale_test.dart`: Home, Suche, Bibliothek, Performer, Einstellungen, Login bei 1,0/1,5/2,0×; nur Englisch) |
| A11Y-2 | Bewertung als ein zugängliches Element | ✅ |
| CTRL-4 | Queue-Navigation in den Controls | ✅ (Sperrbildschirm nur „weiter“) |
| SEARCH-1/2 | Typeahead, Auswege bei leeren Treffern | ✅ (Filter-Button der Suche in der App-Bar) |
| SET-1 | Einstellungen in Kategorien | ✅ |
| ONB-1 | Zweistufiger Login | ✅ |
| STATE-1 | Globales Verbindungsbanner; Listen behalten bei Netzwerkfehlern ihren Inhalt | ✅ |
| DS-1 / DS-2 | Komponentenregeln und Tokens | ✅ (`design_tokens.dart`, `AppColors`, zentrale Komponenten-Themes) |

### Major Refactors

| ID | Änderung |
|---|---|
| NAV-1 + NAV-2 + NAV-3 | Neue IA: Home · Shorts · Suche · Bibliothek · Du; Server-Avatar statt Zahnrad; „Alle“ wird Teil von „Du“ (Migration gespeicherter Nav-Konfigurationen nötig) |
| WATCH-2 | Watch-Seite neu gegliedert (Aktionsleiste, Beschreibungs-Sheet) – muss die stabile Widget-Struktur von `PlayerPanel` wahren, nur der Detailbereich ändert sich |
| CH-2 | Kanalseiten mit Tabs |
| NAV-4 | Adaptive Navigation (Rail/Drawer) für Tablets |

### New Feature Ideas

- **SUB-1** Abo-Feed mit Avatarreihe und „neu“-Punkten.
- **PL-1** Zu Gruppe hinzufügen / neue Gruppe anlegen.
- **NOTIF-1** „Neu seit letztem Besuch“-Badge, lokale Benachrichtigung nach Server-Aufgaben.
- **CTRL-3** Touch-Sperre im Vollbild; **CTRL-2** Gesten-Coach-Marks.
- Sleep-Timer (Ende der Szene / nach N Minuten).
- „Zufällige Szene“-Button (Würfel) auf Home – passt zu einer privaten Bibliothek.
- Kapitel-Thumbnails in der Kapitel-Reihe (Marker-Screenshot statt Text-Kachel).
- Offline-Downloads (Epic 12) mit Download-Ansicht unter „Du“.
- Wiedergabe-Statistik als Diagramm (Story 16.3).

---

## 3. Wireframe-Beschreibungen

### 3.1 Home (neu)

```
┌───────────────────────────────────┐
│ [Logo] StashTube        [Cast] (S)│  (S) = Server-Avatar → Konto-Sheet
│ [Alle][Neu][Zufällig][Top][⚙Filter]│  sticky Chip-Leiste
├───────────────────────────────────┤
│ ⟲ Weiterschauen                  >│
│ [16:9 ▓▓▓░] [16:9 ▓░░] [16:9 …     │  horizontale Reihe
│ ▶ Shorts                         >│
│ [9:16][9:16][9:1…                  │  Reihe, ~240 dp hoch
│ ♥ Neu von Favoriten              >│
│ [16:9][16:9][…                     │
├───────────────────────────────────┤
│ ┌───────────────────────────────┐ │
│ │        Thumbnail 16:9    12:34│ │  Hauptfeed
│ └───────────────────────────────┘ │
│ (A) Titel zweizeilig …          ⋮ │
│     Studio · 3 Aufrufe · ★4       │
└───────────────────────────────────┘
 [Home] [Shorts] [Suche] [Bibliothek] [Du]
```

### 3.2 Watch-Seite (neu, Details unterhalb des Videos)

```
┌───────────────────────────────────┐
│            VIDEO 16:9             │
│ ━━━━━━━━●━━━━━━━━━━━━━━━━━━━━━━━━ │
├───────────────────────────────────┤
│ Titel der Szene, max. 2 Zeilen    │
│ 3 Aufrufe · 26.09.2012 · 480p  …mehr│ → Beschreibungs-Sheet
│ (S) Tears of Steel        [♡ Fav] │  Kanalzeile
│ [★ 4][💧 O 0][🕐 Später][🔖 Marker][⋯]│  Pill-Aktionsleiste (scrollbar)
│ (o)Celia (o)Barley                │  Performer
│ Kapitel: [▣0:05 First][▣0:40 Under]│
│ Als Nächstes von Tears of Steel   │
│ [Karte] [Karte] …                 │
└───────────────────────────────────┘
Beschreibungs-Sheet: Beschreibung · #Tags (+ Bearbeiten) · Datei-Info · Szene bearbeiten
```

### 3.3 „Du“-Seite

```
┌───────────────────────────────────┐
│ (S) Heimserver ▾        [Suche][⚙]│
│ Verlauf                         > │ Reihe
│ Später ansehen (12)             > │ Reihe
│ Gruppen                         > │ Reihe (Poster)
│ Marker                          > │ Reihe
│ ───────────                       │
│ ▸ Statistik                       │ ListTiles
│ ▸ Performer · Studios · Tags      │
│ ▸ Server-Aufgaben                 │
└───────────────────────────────────┘
```

### 3.4 Kanalseite

Collapsing Header (Banner, Avatar, Name, Szenenzahl, [♡ Favorit]) → sticky Tabs **Videos · Shorts · Bilder · Galerien · Info** → im Tab Videos die Sortier-Chips und Feed.

### 3.5 Login

Schritt 1: Logo, Feld „Server-URL“, [Verbinden], [Demo ausprobieren]. Schritt 2 (nur bei 401): `SegmentedButton` API-Key | Benutzer, passende Felder, Hilfelink, [Anmelden]. Danach Design-Auswahl (bestehend).

## 4. Navigationsfluss

```
Login ─▶ (Design wählen) ─▶ Shell
Shell: Home │ Shorts │ Suche │ Bibliothek │ Du
  Home ─▶ Karte ─▶ Player (expandiert) ─▶ Kanal / Tag / Performer (im aktuellen Tab, Player klappt ein)
  Suche ─▶ Typeahead ─▶ Performer/Tag/Studio-Seite │ Szenenergebnisse (Scope-Chips)
  Bibliothek ─▶ [Szenen | Bilder | Galerien] ─▶ Bildbetrachter (Root-Navigator)
  Du ─▶ Verlauf / Später / Gruppen / Marker / Statistik / Performer / Studios / Tags
  (S)-Avatar ─▶ Konto-Sheet ─▶ Server wechseln │ Einstellungen (Sheet) │ Server-Aufgaben
Player: Wischen ↓ = Miniplayer │ Drehen = Vollbild │ Queue ⏮⏭
```

Regeln bleiben: `openPage`/`openPerformer`… pushen in den aktuellen Tab; Einstellungen bleiben ein Sheet; Erneutes Tippen auf Tab = zurück/nach oben.

## 5. Komponentenhierarchie (Vorschlag)

```
widgets/
  layout/      AppScaffold (adaptiv: Bar/Rail/Drawer), SectionHeader, StickyChipBar
  media/       SceneCard, SceneGridTile, SceneListTile  ← gemeinsame SceneTileData + Semantik
               ShortTile, ShelfRow<T>, ChannelAvatar
  actions/     ActionPill, ActionBar, RatingControl (zugänglich), OverflowMenu (⋮, ein Sheet)
  states/      SkeletonBox, SceneCardSkeleton, EmptyView (+ action), ErrorView (+ details),
               ConnectionBanner
  player/      VideoErrorOverlay, QueueControls
features/
  you/         YouPage (neu, ersetzt AllViewsPage)
  library/     LibraryPage (nur Medien)
  channel/     ChannelScaffold (gemeinsam für Performer/Studio, Tabs)
  settings/    SettingsHome + Unterseiten je Kategorie
```

`SceneCard`/`SceneGridTile`/`SceneListTile` teilen sich heute Kanal- und Meta-Logik; eine gemeinsame `SceneTileData` (Titel, Kanal, Meta, Semantik-Label) hält das in einem Ort.

## 6. Design-System-Empfehlungen

- **Farbe:** weiter `ColorScheme.fromSeed` mit Akzent; zusätzliche `ThemeExtension<AppColors>` für `rating`, `videoScrim`, `badgeBackground`, `newDot` – je Modus mit Kontrastprüfung in `theme_contrast_test.dart`.
- **Typografie:** nur M3-`textTheme` (Titel Karte = `titleSmall`, Watch-Titel = `titleLarge`, Meta = `bodySmall`/`onSurfaceVariant`); keine `fontSize`-Literale außer über Video.
- **Abstände/Formen:** Raster 4 dp (`AppSpacing`), Radien 8 (Thumbnails), 12 (Karten/Sheets), voll (Pills/Chips); `chipTheme` und Button-Themes zentral.
- **Trefferflächen:** min. 48 dp (Android) / 44 pt (iOS); kein `VisualDensity.compact` für primäre Aktionen.
- **Bewegung:** M3-Dauern (short 150–200 ms, medium 300 ms), `emphasized`-Kurven; alles hinter `MediaQuery.disableAnimationsOf` (bereits Praxis).
- **Plattform:** Material als Basis; auf iOS Cupertino-Sheets (schon), `.adaptive`-Switches/Dialoge, Swipe-Back erhalten.
- **Komponentenregeln:** Filter = Chips, Aktionen = Pill-Buttons, Navigation = Tiles/Avatare; destruktiv immer mit Bestätigung und `error`-Farbe.
- **Zustände:** jede Liste hat Skeleton, Leer (mit Aktion), Fehler (mit Retry, Details), Offline (Banner).

---

## 7. Vorschlag für Phase 2

Reihenfolge, falls freigegeben: (1) Quick Wins, (2) STATE-1 + WATCH-1 vollständig, (3) A11Y-Paket + Tokens (DS-1/2), (4) HOME-1/2, (5) WATCH-2, (6) IA-Umbau NAV-1–3, (7) SET-1, ONB-1, Kanal-Tabs. Jeder Schritt mit Tests, ARB-Texten (de/en) und Backlog-Eintrag.

**Freigabe bitte per ID** (z. B. „Quick Wins + STATE-1 + HOME-1“).
