# Backlog – Stash Mobile

Ziel: Eine native Android-/iOS-App für einen selbst gehosteten [Stash](https://github.com/stashapp/stash)-Server, die sich wie YouTube anfühlt: Feed mit großen Vorschaubildern, Miniplayer, der beim Navigieren weiterläuft, „Kanäle“ (Performer und Studios), Suche, Verlauf und Bibliothek.

Die Daten kommen ausschließlich aus der Stash-GraphQL-API (`<server>/graphql`, Authentifizierung über den Header `ApiKey`).

**Legende:** ✅ umgesetzt (Refactor Oktober 2026) · 🟡 teilweise umgesetzt · ⬜ offen
**Priorität:** **MVP** = für eine erste brauchbare Version nötig · **Next** = direkt danach · **Later** = später

---

## Epic 1 – Fundament & Architektur

Eine wartbare Basis, damit Features unabhängig voneinander wachsen können.

| # | User Story | Akzeptanzkriterien | Prio | Status |
|---|---|---|---|---|
| 1.1 | Als Entwickler möchte ich eine Feature-orientierte Ordnerstruktur, damit ich Code schnell finde. | `lib/core`, `lib/data`, `lib/features/<feature>`, `lib/widgets`. Keine Modelle in UI-Dateien. | MVP | ✅ |
| 1.2 | Als Entwickler möchte ich eine Repository-Schicht für die Stash-API, damit die UI keine GraphQL-Strings und rohen Maps kennt. | `StashRepository` kapselt alle Queries. Die UI arbeitet nur mit typisierten Modellen. | MVP | ✅ |
| 1.3 | Als Entwickler möchte ich typisierte Modelle mit `fromJson`, damit Null-Werte vom Server die App nicht abstürzen lassen. | `Scene`, `Performer`, `Studio`, `Tag` mit Unit-Tests. Fehlende Felder führen zu sinnvollen Defaults. | MVP | ✅ |
| 1.4 | Als Entwickler möchte ich den globalen Zustand über Riverpod-Provider abbilden statt über Top-Level-Variablen. | Server-Config, GraphQL-Client, Player und Theme sind Provider. Kein globales `ValueNotifier`. | MVP | ✅ |
| 1.5 | Als Entwickler möchte ich eine generische Paginierung, damit jede Liste endlos scrollen kann. | `PagedNotifier` lädt Seite für Seite und zeigt beim Nachladen Lade- und Fehlerzustände an. | MVP | ✅ |
| 1.6 | Als Entwickler möchte ich, dass `flutter analyze` ohne Warnungen und `flutter test` grün läuft. | Lints sauber, der Template-Test ist ersetzt. | MVP | ✅ |
| 1.7 | Als Entwickler möchte ich eine CI-Pipeline (Analyze, Test, Build für Android und iOS). | GitHub Actions bei jedem Push und PR. | Next | ⬜ |
| 1.8 | Als Entwickler möchte ich GraphQL-Typen aus dem Stash-Schema generieren (z. B. `graphql_codegen`), damit Schemaänderungen beim Kompilieren auffallen. | Schema-Download-Skript, generierte Typen ersetzen die handgeschriebenen `fromJson`. | Later | ⬜ |

## Epic 2 – Server-Verbindung & Authentifizierung

| # | User Story | Akzeptanzkriterien | Prio | Status |
|---|---|---|---|---|
| 2.1 | Als Nutzer möchte ich die URL meines Stash-Servers eingeben, damit sich die App mit ihm verbindet. | URL wird validiert, die Verbindung über `systemStatus` geprüft. Eine Fehlermeldung zeigt die Ursache. | MVP | ✅ |
| 2.2 | Als Nutzer mit passwortgeschütztem Stash möchte ich einen API-Key hinterlegen. | API-Key-Feld (optional, verdeckt). Der Key wird als `ApiKey`-Header an GraphQL, Bilder und Streams gesendet. | MVP | ✅ |
| 2.3 | Als Nutzer möchte ich mich abmelden bzw. den Server wechseln. | Logout löscht URL und Key und führt zurück zum Login. Caches werden verworfen. | MVP | ✅ |
| 2.4 | Als Nutzer möchte ich, dass die App beim nächsten Start direkt verbunden ist. | Die Konfiguration wird persistiert. Der Start erfolgt ohne Login-Screen. | MVP | ✅ |
| 2.5 | Als Nutzer möchte ich den API-Key sicher gespeichert wissen. | Speicherung in Keychain/Keystore (`flutter_secure_storage`) statt SharedPreferences. | Next | ⬜ |
| 2.6 | Als Nutzer möchte ich mehrere Server-Profile speichern und schnell wechseln. | Profilliste in den Einstellungen. | Later | ⬜ |
| 2.7 | Als Nutzer möchte ich bei Login per Benutzername und Passwort (Session-Cookie) unterstützt werden. | `/login` mit Cookie-Handling als Alternative zum API-Key. | Later | ⬜ |

## Epic 3 – Startseite / Feed (YouTube-Home)

| # | User Story | Akzeptanzkriterien | Prio | Status |
|---|---|---|---|---|
| 3.1 | Als Nutzer möchte ich auf der Startseite einen endlosen Feed von Szenen mit großen 16:9-Vorschaubildern sehen. | Karten mit Thumbnail, Dauer-Badge, Auflösungs-Badge, Kanal-Avatar, Titel (2 Zeilen) und Metazeile. | MVP | ✅ |
| 3.2 | Als Nutzer möchte ich den Feed über Filter-Chips umschalten („Neu hinzugefügt“, „Neueste“, „Zufällig“, „Top bewertet“, „Meistgesehen“). | Chip-Leiste wie bei YouTube. Der Wechsel lädt den Feed neu. „Zufällig“ ist über alle Seiten stabil (Seed). | MVP | ✅ |
| 3.3 | Als Nutzer möchte ich per Pull-to-Refresh aktualisieren – auch wenn nur wenige Einträge da sind. | `AlwaysScrollableScrollPhysics`. Der bekannte Bug „Refresh geht nicht bei kurzem Inhalt“ ist behoben. | MVP | ✅ |
| 3.4 | Als Nutzer möchte ich beim Gedrückthalten bzw. Scrollen eine animierte Vorschau (Stash-`preview`) sehen. | Autoplay des Preview-MP4 (stumm) für die sichtbare Karte. | Next | ⬜ |
| 3.5 | Als Nutzer möchte ich auf der Startseite Abschnitte sehen („Weiterschauen“, „Neu von Favoriten“). | Horizontale Reihen oberhalb des Feeds. „Weiterschauen“: Szenen mit `resume_time > 0`, zuletzt gesehen zuerst, lädt nach dem ersten gespeicherten Fortschritt neu. „Neu von Favoriten“: `performer_favorite`. Leere Reihen werden ausgeblendet. | Next | ✅ |
| 3.6 | Als Nutzer möchte ich über das „⋮“-Menü einer Karte Aktionen ausführen (Zur Playlist, Zum Studio, Teilen). | Bottom Sheet mit Aktionen. | Later | 🟡 (zu Studio/Performer) |

## Epic 4 – Video-Player

| # | User Story | Akzeptanzkriterien | Prio | Status |
|---|---|---|---|---|
| 4.1 | Als Nutzer möchte ich durch Antippen einer Karte die Szene sofort abspielen. | Der Player öffnet sich ausgeklappt, der Stream startet automatisch (inkl. Auth-Header). | MVP | ✅ |
| 4.2 | Als Nutzer möchte ich den Player zu einem Miniplayer verkleinern und weiter in der App navigieren, ohne dass die Wiedergabe stoppt. | Wischen nach unten bzw. Pfeil verkleinert. Wiedergabe läuft weiter. Die Bottom-Navigation blendet sich passend ein und aus. | MVP | ✅ |
| 4.3 | Als Nutzer möchte ich im Miniplayer Play/Pause und Schließen bedienen und den Fortschritt sehen. | Buttons und Fortschrittsbalken an den echten Player gekoppelt. | MVP | ✅ |
| 4.4 | Als Nutzer möchte ich eine andere Szene wählen, während eine läuft. | Der Player wechselt die Quelle. (Bisher blieb das alte Video stehen.) | MVP | ✅ |
| 4.5 | Als Nutzer möchte ich unter dem Video Details sehen: Titel, Datum, Auflösung, Studio-„Kanal“, Performer, Tags, Beschreibung. | Ausklappbare Beschreibung. Tippen auf Studio oder Performer öffnet die Kanalseite. | MVP | ✅ |
| 4.6 | Als Nutzer möchte ich unter dem Video „Als Nächstes“-Vorschläge sehen. | Weitere Szenen desselben Studios bzw. desselben Performers, sonst zufällige. | MVP | ✅ |
| 4.7 | Als Nutzer möchte ich in den Vollbildmodus (Querformat) wechseln. | Vollbild über die Player-Controls. | MVP | ✅ (media_kit-Controls) |
| 4.8 | Als Nutzer möchte ich dort weiterschauen, wo ich aufgehört habe. | `resume_time` lesen und beim Start dorthin springen. Fortschritt über `sceneSaveActivity` speichern: alle 15 s Wiedergabe, bei Pause, Schließen, Szenenwechsel und wenn die App in den Hintergrund geht. Kurz vor dem Ende (≥ 95 %) wird die Position auf 0 zurückgesetzt. Nur tatsächlich geschaute Zeit zählt, Spulen nicht. | Next | ✅ |
| 4.9 | Als Nutzer möchte ich, dass Aufrufe gezählt werden. | `sceneAddPlay` einmal pro Wiedergabe, sobald 10 % der Szene geschaut wurden (höchstens 60 s). | Next | ✅ |
| 4.10 | Als Nutzer möchte ich die Qualität bzw. den Transcode-Stream wählen. | ⚙-Button im Player (auch im Vollbild) listet `sceneStreams`. Der Wechsel behält die Position. Die Wahl wird gespeichert und bei weiteren Szenen automatisch genutzt, falls verfügbar. Zurücksetzen in den Einstellungen. | Next | ✅ |
| 4.11 | Als Nutzer möchte ich per Doppeltipp ±10 s springen und Kapitel (Scene Markers) sehen. | Doppeltipp links/rechts im Video. Marker als Segment-Lücken auf einer Leiste unter dem Video und als antippbare Kapitel-Liste mit Hervorhebung des aktuellen Kapitels. (Marker im media_kit-Seekbar selbst sind nicht möglich.) | Later | ✅ |
| 4.12 | Als Nutzer möchte ich Bild-in-Bild und Hintergrundwiedergabe. | Android-PiP, iOS-AVPictureInPicture, Audio-Session. | Later | ⬜ |
| 4.13 | Als Nutzer möchte ich auf einen Chromecast oder AirPlay streamen. | Cast-Button im Player. | Later | ⬜ |
| 4.14 | Als Nutzer möchte ich beim Spulen ein Vorschaubild der Stelle sehen. | Eigener Fortschrittsbalken: Beim Ziehen/Tippen erscheint über dem Finger der passende Ausschnitt aus Stashs Sprite (WebVTT) plus Zielzeit; Sprung beim Loslassen. Ohne generierte Sprites nur die Zeit. | Next | ✅ |
| 4.15 | Als Nutzer möchte ich den großen Player per Wischen nach unten minimieren. | Wischen auf dem Video oder in den Details (ganz oben) folgt dem Finger und rastet ein; kein Pull-to-Refresh im Player. | MVP | ✅ |

## Epic 5 – Suche & Filter

| # | User Story | Akzeptanzkriterien | Prio | Status |
|---|---|---|---|---|
| 5.1 | Als Nutzer möchte ich über die Lupe in der App-Bar nach Szenen suchen. | Live-Suche mit Debounce (400 ms) und endlos scrollbaren Ergebnissen. | MVP | ✅ |
| 5.2 | Als Nutzer möchte ich in den Suchergebnissen auch passende Performer sehen. | Horizontale Performer-Reihe über den Szenen. | MVP | ✅ |
| 5.3 | Als Nutzer möchte ich meine letzten Suchanfragen sehen. | Lokaler Verlauf, löschbar. | Next | ⬜ |
| 5.4 | Als Nutzer möchte ich nach Tags, Bewertung, Dauer und Auflösung filtern. | Filter-Sheet, das auf `SceneFilterType` abgebildet wird. | Later | ⬜ |
| 5.5 | Als Nutzer möchte ich gespeicherte Stash-Filter (Saved Filters) nutzen. | `findSavedFilters` als Chips im Feed. | Later | ⬜ |

## Epic 6 – Performer („Kanäle“)

| # | User Story | Akzeptanzkriterien | Prio | Status |
|---|---|---|---|---|
| 6.1 | Als Nutzer möchte ich alle Performer als Raster sehen und endlos scrollen. | Porträtkarten mit Name, Flagge und Anzahl der Szenen. Paginiert. | MVP | ✅ |
| 6.2 | Als Nutzer möchte ich Performer sortieren bzw. filtern (Name, Anzahl Szenen, Favoriten, Zufall). | Chip-Leiste. | MVP | ✅ |
| 6.3 | Als Nutzer möchte ich eine Kanalseite für einen Performer sehen: Header mit Bild und Infos, darunter alle Szenen. | Header (Bild, Name, Land, Alter, Szenen) und paginierte Szenenliste. | MVP | ✅ |
| 6.4 | Als Nutzer möchte ich einen Performer als Favoriten markieren („Abonnieren“). | `performerUpdate(favorite)` mit optimistischem UI-Update. Button „Favorite/Favorited“ auf der Kanalseite, Herz auf den Performer-Kacheln. Bei Fehler Rücksetzen und Snackbar. Favoriten-Listen und die Reihe „New from favorites“ laden danach neu. | Next | ✅ |
| 6.5 | Als Nutzer möchte ich einen „Abos“-Feed mit neuen Szenen meiner Favoriten. | Szenenfeed mit Filter `performer_favorite: true`. | Next | 🟡 (Reihe „New from favorites“ auf der Startseite ✅, eigener Tab offen) |

## Epic 7 – Studios („Kanäle“)

| # | User Story | Akzeptanzkriterien | Prio | Status |
|---|---|---|---|---|
| 7.1 | Als Nutzer möchte ich alle Studios als Kanalliste sehen. | Logo, Name und Anzahl der Szenen. Paginiert. | MVP | ✅ |
| 7.2 | Als Nutzer möchte ich eine Studio-Kanalseite mit allen Szenen. | Header und paginierte Szenen. | MVP | ✅ |
| 7.3 | Als Nutzer möchte ich Unter- und Elternstudios sehen. | Hierarchie aus `parent_studio`/`child_studios`. | Later | ⬜ |

## Epic 8 – Tags & Entdecken

| # | User Story | Akzeptanzkriterien | Prio | Status |
|---|---|---|---|---|
| 8.1 | Als Nutzer möchte ich auf einen Tag tippen und alle Szenen mit diesem Tag sehen. | Tag-Seite mit paginierten Szenen. | Next | ⬜ (Tags werden im Player angezeigt) |
| 8.2 | Als Nutzer möchte ich eine „Entdecken“-Seite mit beliebten Tags. | Raster aus `findTags`, sortiert nach Anzahl der Szenen. | Later | ⬜ |

## Epic 9 – Bibliothek

| # | User Story | Akzeptanzkriterien | Prio | Status |
|---|---|---|---|---|
| 9.1 | Als Nutzer möchte ich meinen Wiedergabeverlauf sehen. | Sortierung `last_played_at`. | Next | ⬜ |
| 9.2 | Als Nutzer möchte ich „Weiterschauen“ mit Fortschrittsbalken auf dem Thumbnail. | Szenen mit `resume_time > 0`. | Next | ✅ |
| 9.5 | Als Nutzer möchte ich alle Szenen meiner Bibliothek als kompaktes Raster durchsehen. | Tab „Library“ → „Scenes“: Raster mit Gesamtzahl, Sortier-Chips, Endlos-Scroll, langer Druck öffnet das Szenen-Menü. | Next | ✅ |
| 9.3 | Als Nutzer möchte ich Groups/Movies wie Playlists durchsehen und abspielen. | Gruppenseite. Autoplay der nächsten Szene. | Later | ⬜ |
| 9.4 | Als Nutzer möchte ich eine Warteschlange („Später ansehen“). | Lokale Queue, die der Player abarbeitet. | Later | ⬜ |

## Epic 10 – Interaktion mit Szenen

| # | User Story | Akzeptanzkriterien | Prio | Status |
|---|---|---|---|---|
| 10.1 | Als Nutzer möchte ich eine Szene im Player bewerten (1–5 Sterne). | `sceneUpdate(rating100)`. | Next | ⬜ (Anzeige ✅) |
| 10.2 | Als Nutzer möchte ich den O-Counter erhöhen. | `sceneAddO`. | Later | ⬜ |
| 10.3 | Als Nutzer möchte ich einen Scene Marker an der aktuellen Position setzen. | `sceneMarkerCreate`. | Later | ⬜ |

## Epic 11 – Sicherheit & Privatsphäre

| # | User Story | Akzeptanzkriterien | Prio | Status |
|---|---|---|---|---|
| 11.1 | Als Nutzer möchte ich die App mit PIN oder Biometrie sperren. | `local_auth` und `flutter_screen_lock` (bereits Abhängigkeiten). Sperre beim Start und nach Rückkehr aus dem Hintergrund. | Next | ⬜ |
| 11.2 | Als Nutzer möchte ich, dass im App-Switcher kein Inhalt sichtbar ist. | Android `FLAG_SECURE`, iOS-Blur-Overlay. | Next | ⬜ |
| 11.3 | Als Nutzer möchte ich die App-Icons bzw. den Namen tarnen können. | Alternative Icons. | Later | ⬜ |

## Epic 12 – Offline & Downloads

| # | User Story | Akzeptanzkriterien | Prio | Status |
|---|---|---|---|---|
| 12.1 | Als Nutzer möchte ich Szenen für die Offline-Wiedergabe herunterladen. | Download-Manager mit Fortschritt. Eigene Bibliotheks-Sektion. | Later | ⬜ |
| 12.2 | Als Nutzer möchte ich gecachte Thumbnails und Listen auch ohne Netz sehen. | Persistenter Cache (Hive/Drift). | Later | ⬜ |

## Epic 13 – Einstellungen, Design & Lokalisierung

| # | User Story | Akzeptanzkriterien | Prio | Status |
|---|---|---|---|---|
| 13.1 | Als Nutzer möchte ich Hell, Dunkel oder System wählen. | Wird gespeichert. YouTube-artiges Farbschema (Material 3, roter Akzent). | MVP | ✅ |
| 13.2 | Als Nutzer möchte ich Server-Infos (URL, Stash-Version) sehen. | Abschnitt in den Einstellungen. | MVP | ✅ |
| 13.6 | Als Nutzer möchte ich die Primärfarbe der App wählen. | 9 Farben in den Einstellungen (Standard: Rot), werden gespeichert. Textfarbe auf Buttons passt sich hellen Farben an. | Next | ✅ |
| 13.3 | Als Nutzer möchte ich die App auf Deutsch und Englisch nutzen. | `flutter_localizations` und ARB-Dateien. | Next | ⬜ |
| 13.4 | Als Nutzer möchte ich ein App-Icon und einen Splashscreen. | `flutter_launcher_icons`, `flutter_native_splash`. | Next | ⬜ |
| 13.5 | Als Nutzer möchte ich Tablet- und Querformat-Layouts. | Mehrspaltiges Raster ab 600 dp. | Later | ⬜ |

## Epic 14 – Plattform & Release

| # | User Story | Akzeptanzkriterien | Prio | Status |
|---|---|---|---|---|
| 14.1 | Als Nutzer im Heimnetz möchte ich Server über `http://` erreichen. | Android `usesCleartextTraffic`, iOS-ATS-Ausnahme und Local-Network-Hinweis. | MVP | ✅ |
| 14.2 | Als Entwickler möchte ich Abhängigkeiten aktualisieren (Riverpod 3, graphql 5.2, media_kit 1.2). | Upgrade in eigenem PR, danach Tests grün. | Next | 🟡 (graphql 5.2, media_kit 1.2 ✅; Riverpod 3 offen) |
| 14.4 | Als Entwickler möchte ich mit aktuellem JDK für Android bauen. | Gradle 9.3.1, AGP 9.1.0, Kotlin 2.4.0, Kotlin-DSL nach aktuellem Flutter-Template. | MVP | ✅ |
| 14.3 | Als Entwickler möchte ich signierte Release-Builds (APK/AAB, TestFlight). | Signing-Konfiguration, Fastlane o. Ä. | Later | ⬜ |

## Epic 15 – Bilder & Galerien

| # | User Story | Akzeptanzkriterien | Prio | Status |
|---|---|---|---|---|
| 15.1 | Als Nutzer möchte ich alle Bilder als Raster durchsehen. | Tab „Library“ → „Images“: Thumbnail-Raster mit Gesamtzahl, Sortierung, Endlos-Scroll. | Next | ✅ |
| 15.2 | Als Nutzer möchte ich Bilder im Vollbild ansehen. | Wischen zwischen Bildern, Pinch-Zoom, Tippen blendet Infos (Titel, Studio, Performer, Datum, Position) ein/aus, lädt beim Blättern nach. | Next | ✅ |
| 15.3 | Als Nutzer möchte ich Galerien durchsehen. | Library → „Galleries“: Cover-Raster mit Bildanzahl, Sortierung, Endlos-Scroll. Galerieseite mit Details, Studio/Performer-Chips und allen Bildern in Dateireihenfolge; Vollbild-Viewer zum Durchblättern. | Next | ✅ |
| 15.4 | Als Nutzer möchte ich Bilder nach Performer/Studio/Tag filtern. | Filter wie bei Szenen; Bilder auf den Kanalseiten. | Later | ⬜ |

## Epic 16 – Statistik

| # | User Story | Akzeptanzkriterien | Prio | Status |
|---|---|---|---|---|
| 16.1 | Als Nutzer möchte ich Statistiken zu meiner Bibliothek sehen. | Tab „Library“ → „Stats“: Szenen (Anzahl, Größe, Gesamtdauer), Bilder, Galerien, Performer, Studios, Tags, Speicher, Durchschnitt pro Szene. | Next | ✅ |
| 16.2 | Als Nutzer möchte ich meine Seh-Statistik sehen. | Aufrufe, Sehzeit, gesehene Szenen, O-Count; wird bei älteren Stash-Versionen ohne diese Felder ausgeblendet. | Next | ✅ |
| 16.3 | Als Nutzer möchte ich Verläufe sehen (z. B. Sehzeit pro Woche). | Diagramm aus dem Wiedergabeverlauf. | Later | ⬜ |
