# Backlog – Stashy

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
| 1.7 | Als Entwickler möchte ich eine CI-Pipeline (Analyze, Test, Build für Android und iOS). | GitHub Actions bei jedem Push und PR (`.github/workflows/ci.yml`): generierter Code (l10n, GraphQL), `dart analyze`, `flutter test`, Debug-APK (als Artefakt) und unsignierter iOS-Build. | Next | ✅ |
| 1.8 | Als Entwickler möchte ich GraphQL-Typen aus dem Stash-Schema generieren (z. B. `graphql_codegen`), damit Schemaänderungen beim Kompilieren auffallen. | Schema-Download-Skript, generierte Typen ersetzen die handgeschriebenen `fromJson`. Umgesetzt: `tool/update_stash_schema.sh` (Stash v0.31.1), Dokumente in `lib/core/api/documents/*.graphql`, `graphql_codegen` + `build_runner`; ungültige Felder brechen den Build ab. Modelle entstehen aus den generierten Typen, Filter und Änderungen werden gegen die Input-Typen des Schemas geprüft; gespeicherte Filter lassen unpassende Kriterien weg. | Later | ✅ |

## Epic 2 – Server-Verbindung & Authentifizierung

| # | User Story | Akzeptanzkriterien | Prio | Status |
|---|---|---|---|---|
| 2.1 | Als Nutzer möchte ich die URL meines Stash-Servers eingeben, damit sich die App mit ihm verbindet. | URL wird validiert, die Verbindung über `systemStatus` geprüft. Eine Fehlermeldung zeigt die Ursache. | MVP | ✅ |
| 2.2 | Als Nutzer mit passwortgeschütztem Stash möchte ich einen API-Key hinterlegen. | API-Key-Feld (optional, verdeckt). Der Key wird als `ApiKey`-Header an GraphQL, Bilder und Streams gesendet. | MVP | ✅ |
| 2.3 | Als Nutzer möchte ich mich abmelden bzw. den Server wechseln. | Logout löscht URL und Key und führt zurück zum Login. Caches werden verworfen. | MVP | ✅ (jetzt „Remove this server“) |
| 2.4 | Als Nutzer möchte ich, dass die App beim nächsten Start direkt verbunden ist. | Die Konfiguration wird persistiert. Der Start erfolgt ohne Login-Screen. | MVP | ✅ |
| 2.5 | Als Nutzer möchte ich den API-Key sicher gespeichert wissen. | Speicherung in Keychain/Keystore (`flutter_secure_storage`) statt SharedPreferences; gilt auch für Passwörter (2.7). Bestehende Keys werden beim ersten Start übernommen und aus den SharedPreferences entfernt, beim Entfernen eines Servers gelöscht. Android-Auto-Backup ist aus (Keystore-Daten wären nach einer Wiederherstellung unlesbar). | Next | ✅ |
| 2.6 | Als Nutzer möchte ich mehrere Server-Profile speichern und schnell wechseln. | Server mit optionalem Namen speichern; Einstellungen → „Switch server“ (wechseln, umbenennen, entfernen, hinzufügen); Login zeigt gespeicherte Server. Bestehende Anmeldung wird automatisch übernommen. Watch later und Suchverlauf sind pro Server getrennt; beim Wechsel wird der Player geschlossen und serverbezogener Cache verworfen. | Later | ✅ |
| 2.7 | Als Nutzer möchte ich URL, API-Key und Namen eines Servers nachträglich ändern. | Einstellungen (Server-Eintrag oder API-Key), Statistik-Tab oder Server-Wechsler → „Bearbeiten“: vorausgefülltes Formular, Verbindung wird geprüft. Die Daten des Servers (Später ansehen, Einstellungen) bleiben erhalten. | Next | ✅ |
| 2.7 | Als Nutzer möchte ich bei Login per Benutzername und Passwort (Session-Cookie) unterstützt werden. | `/login` mit Cookie-Handling als Alternative zum API-Key. Login-/Bearbeiten-Seite: Benutzername und Passwort (sicher gespeichert, 2.5), beim Verbinden geprüft („Benutzername oder Passwort ist falsch“). Das Session-Cookie geht an GraphQL, Bilder und Streams; abgelaufene Sessions werden still erneuert (vor Ablauf und nach 401, Anfrage wird wiederholt). Ein API-Key hat Vorrang. Casting braucht weiterhin den API-Key (TV-Geräte können kein Cookie senden). | Later | ✅ |

## Epic 3 – Startseite / Feed (YouTube-Home)

| # | User Story | Akzeptanzkriterien | Prio | Status |
|---|---|---|---|---|
| 3.1 | Als Nutzer möchte ich auf der Startseite einen endlosen Feed von Szenen mit großen 16:9-Vorschaubildern sehen. | Karten mit Thumbnail, Dauer-Badge, Auflösungs-Badge, Kanal-Avatar, Titel (2 Zeilen) und Metazeile. Die Kopfzeile verschwindet beim Herunterscrollen und kommt beim Hochscrollen wieder; sie liegt über der Liste, damit ihre Knöpfe immer reagieren. | MVP | ✅ |
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
| 4.7 | Als Nutzer möchte ich in den Vollbildmodus (Querformat) wechseln. | Vollbild über die Player-Controls. Hochkant-Videos bleiben im Hochformat, breite Videos drehen ins Querformat. | MVP | ✅ (media_kit-Controls) |
| 4.8 | Als Nutzer möchte ich dort weiterschauen, wo ich aufgehört habe. | `resume_time` lesen und beim Start dorthin springen. Fortschritt über `sceneSaveActivity` speichern: alle 15 s Wiedergabe, bei Pause, Schließen, Szenenwechsel und wenn die App in den Hintergrund geht. Kurz vor dem Ende (≥ 95 %) wird die Position auf 0 zurückgesetzt. Nur tatsächlich geschaute Zeit zählt, Spulen nicht. | Next | ✅ |
| 4.9 | Als Nutzer möchte ich, dass Aufrufe gezählt werden. | `sceneAddPlay` einmal pro Wiedergabe, sobald 10 % der Szene geschaut wurden (höchstens 60 s). | Next | ✅ |
| 4.10 | Als Nutzer möchte ich die Qualität bzw. den Transcode-Stream wählen. | HD-Button im Player (auch im Vollbild) listet `sceneStreams`. Der Wechsel behält die Position. Die Wahl wird gespeichert und bei weiteren Szenen genutzt: dieselbe Variante, sonst dasselbe Format in der gewählten oder nächstniedrigeren Auflösung; ist das Video selbst nicht größer, läuft die Originaldatei. Standard-Auflösung auch in den Einstellungen wählbar (Original, 1080p, 720p, 480p, 240p). | Next | ✅ |
| 4.11 | Als Nutzer möchte ich per Doppeltipp ±10 s springen und Kapitel (Scene Markers) sehen. | Doppeltipp links/rechts im Video. Marker als Lücken und Punkte im Spulbalken (Spulen in der Nähe rastet auf dem Marker ein) und als antippbare Kapitel-Liste mit Hervorhebung des aktuellen Kapitels. (Marker im media_kit-Seekbar selbst sind nicht möglich.) | Later | ✅ |
| 4.12 | Als Nutzer möchte ich Bild-in-Bild und Hintergrundwiedergabe. | Android-PiP, iOS-AVPictureInPicture, Audio-Session. Umgesetzt: PiP-Knopf im Player. Android: das App-Fenster zeigt nur das Video, automatisch beim Verlassen der App, wenn ein Video läuft (Einstellung, Android 8+). iOS: ein nativer AVPlayer übernimmt den Stream (MP4/MOV-Original, sonst HLS) im System-PiP, danach spielt die App an dessen Stelle weiter. Einstellung „Hintergrundwiedergabe“: Ton läuft weiter (Video-Decoding pausiert), sonst pausiert der Player. Einstellung „Auf dem Sperrbildschirm anzeigen“ (Standard aus, wegen Diskretion): Titel, Vorschaubild und Steuerung (Play/Pause, ±10 s, Spulen, nächste Szene der Warteschlange) auf dem iOS-Sperrbildschirm und in der Android-Medienbenachrichtigung über `audio_service`; hält Androids Hintergrundwiedergabe per Vordergrund-Dienst am Leben. Ausschalten entfernt beides sofort. Offen: Auto-PiP auf iOS. | Later | 🟡 (PiP, Hintergrund, Sperrbildschirm ✅) |
| 4.13 | Als Nutzer möchte ich auf einen Chromecast oder AirPlay streamen. | Chromecast: Cast-Button im Player und auf der Startseite, Geräteauswahl, laufende Szene wird an der aktuellen Stelle übergeben, neue Szenen laufen direkt auf dem TV, Fernbedienung (Play/Pause, ±10 s, Zeitleiste mit Vorschaubildern und Kapiteln) im Player und Miniplayer, nach dem Trennen geht es lokal an der TV-Position weiter. Stream: Original (MP4/WebM), sonst HLS; API-Key per `?apikey=`. AirPlay-Video ist mit dem mpv-basierten Player nicht möglich – unter iOS bleibt die Bildschirmsynchronisierung. | Later | 🟡 (Chromecast ✅, AirPlay ⬜) |
| 4.14 | Als Nutzer möchte ich beim Spulen ein Vorschaubild der Stelle sehen. | Eigener Fortschrittsbalken: Beim Ziehen/Tippen erscheint über dem Finger der passende Ausschnitt aus Stashs Sprite (WebVTT) plus Zielzeit; Sprung beim Loslassen. Ohne generierte Sprites nur die Zeit. Vorschaubilder laden erst, wenn die Steuerung eingeblendet oder der Balken berührt wird; das Sprite wird dann vorgeladen. Szenendetails und Vorschaubilder bleiben 5 Min. im Cache. | Next | ✅ |
| 4.15 | Als Nutzer möchte ich den großen Player per Wischen nach unten minimieren. | Wischen auf dem Video oder in den Details (ganz oben) folgt dem Finger und rastet ein; kein Pull-to-Refresh im Player. | MVP | ✅ |
| 4.16 | Als Nutzer möchte ich die Dateiinfos eines Videos sehen. | Aufklappbare Karte unter den Videodetails: Zusammenfassung (Auflösung, Codec, Größe, Bitrate), aufgeklappt Pfad, Format, Auflösung, Dauer, Codecs, Bildrate, Bitrate, Änderungsdatum; Pfad kopierbar. Mehrere Dateien werden einzeln aufgeführt. | Next | ✅ |
| 4.17 | Als Nutzer möchte ich kurze Hochkant-Videos wie bei TikTok/Shorts durchwischen. | Vollbild-Feed, vertikal wischen, Video läuft in Schleife, Tippen pausiert, Fortschrittsleiste zum Spulen (im Vollbild blendet sie nach 3 s aus; Antippen des Videos oder der Stelle holt sie zurück, beim Spulen bleibt sie). Zufällige Reihenfolge, standardmäßig nur Hochkant-Videos bis 3 Min. Einstellungen (pro Server): bevorzugte Tags (kommen etwa 3 von 4 Mal vor) oder „Nur diese Tags“, maximale Länge (1/3/10 Min., beliebig), „Nur Hochkant“. Aktionen rechts: Performer, Sterne-Bewertung (Auswahl klappt seitlich auf), O-Zähler mit Rückgängig, Später ansehen, ganzes Video, ⋮-Menü. Studio, Performer und Tags unten antippbar; Wiedergaben und Dauer. Gedrückt halten (ab 0,25 s) = 2× Tempo, Vollbild-Knopf blendet Oberfläche, Navigations- und Systemleisten aus, Ton aus/an, Ladeanzeige, Spulbalken des Players mit Vorschaubildern, Kapitel und Marker-Punkten; schnellere Wechsel zwischen Shorts. Ein Video startet erst, wenn es geladen ist. Nachbarvideos werden vorgeladen; in den Shorts ist der Miniplayer ausgeblendet und der Hauptplayer pausiert („Ganzes Video“ öffnet ihn, Zuklappen kehrt zu den Shorts zurück). Eigener Tab „Shorts“ (in der Navigationsleiste einblendbar) und Knopf auf der Startseite. Zählt eine Wiedergabe nach der Hälfte (max. 15 s). | Next | ✅ |
| 4.18 | Als Nutzer möchte ich das Wiedergabetempo ändern. | Tempo-Knopf in der Player-Steuerung (0,5× bis 2×), bleibt für weitere Szenen. Video gedrückt halten (ab 0,25 s, nicht im Pausezustand der Shorts) spielt mit doppeltem Tempo, Loslassen stellt das vorherige Tempo wieder her. | Next | ✅ |
| 4.19 | Als Nutzer möchte ich ein Querformat-Video durch Drehen des Handys im Vollbild sehen. | Aufgeklappter Player + Querformat-Video: Drehen ins Querformat öffnet das Vollbild, zurückdrehen beendet es. Der Vollbild-Knopf sperrt die Ausrichtung weiter passend zum Video. iOS dreht ohne Animation, damit das Video nicht kurz verzerrt. | Next | ✅ |
| 4.20 | Als Nutzer möchte ich Hochkant-Videos im Player größer sehen. | Die Videofläche folgt dem Seitenverhältnis: Hochkant-Videos bis 60 % der Bildschirmhöhe, breitere Videos bleiben 16:9. Beim Scrollen der Details schrumpft die Zusatzhöhe mit dem Finger auf 16:9. | Next | ✅ |
| 4.21 | Als Nutzer möchte ich per AirPlay auf ein Apple TV streamen. | Cast-Auswahl → „AirPlay“ öffnet den System-Picker (iOS). Mit aktiver AirPlay-Route spielt ein nativer AVPlayer das Video auf dem TV (MP4/MOV direkt, sonst HLS; API-Key als `?apikey=`); die App pausiert lokal und steuert den TV wie bei Chromecast, beim Zurückwechseln aufs iPhone geht es lokal an der TV-Position weiter. Im Simulator nicht testbar. | Next | 🟡 Ungetestet auf Gerät |
| 4.22 | Als Nutzer möchte ich ins Video hineinzoomen. | Mit zwei Fingern zoomen (1–4×) und verschieben, der Punkt unter den Fingern bleibt stehen; auch im Vollbild. Der Zoom bleibt, bis man herauszoomt oder eine andere Szene startet. Gerendert von mpv (`video-zoom`/`video-pan`), die Steuerung bleibt normal groß. | Next | ✅ |
| 4.23 | Als Nutzer möchte ich Shorts auf der Startseite sehen. | 2×2-Raster aus vier Shorts unter „Weiterschauen“. Jede Kachel hat ihre eigene, unabhängig gemischte Warteschlange: Tippen öffnet die Shorts bei diesem Short und spielt danach diese Warteschlange weiter. Keine Kachel zeigt denselben Short wie eine andere. Die Überschrift öffnet den Shorts-Tab (oder den Feed über der Startseite). | Next | ✅ |

## Epic 5 – Suche & Filter

| # | User Story | Akzeptanzkriterien | Prio | Status |
|---|---|---|---|---|
| 5.1 | Als Nutzer möchte ich über die Lupe in der App-Bar nach Szenen suchen. | Live-Suche mit Debounce (400 ms) und endlos scrollbaren Ergebnissen. | MVP | ✅ |
| 5.2 | Als Nutzer möchte ich in den Suchergebnissen auch passende Performer sehen. | Horizontale Performer-Reihe über den Szenen. | MVP | ✅ |
| 5.3 | Als Nutzer möchte ich meine letzten Suchanfragen sehen. | Leere Suche zeigt „Recent searches“ (max. 20 gespeichert, ohne Duplikate); Eintrag antippen sucht erneut, einzeln oder komplett löschbar. Gespeichert wird beim Absenden oder nach 2 s Ergebnisanzeige. | Next | ✅ |
| 5.4 | Als Nutzer möchte ich nach Tags, Bewertung, Dauer und Auflösung filtern. | Filter-Button (mit Zähler) vor den Sortier-Chips auf der Startseite und im Library-Raster; Sheet mit Tags (alle müssen passen, Suche), Mindestbewertung, Dauer, Mindestqualität; abgebildet auf `SceneFilterType`. | Later | ✅ |
| 5.5 | Als Nutzer möchte ich gespeicherte Stash-Filter (Saved Filters) nutzen. | Chip-Reihe auf der Startseite aus `findSavedFilters`; übernimmt Kriterien, Suche und Sortierung; erneutes Tippen schaltet ab. Das Web-UI-Kriterienformat wird bestmöglich konvertiert, nicht unterstützte Kriterien werden per Hinweis genannt. Benötigt Stash v0.25+. | Later | ✅ |
| 5.6 | Als Nutzer möchte ich mit einem Suchfeld Szenen, Bilder, Galerien, Performer und Studios durchsuchen und Szenen-Ergebnisse filtern. | Chips unter dem Suchfeld wechseln die Kategorie, der Suchbegriff bleibt. Szenen-Ergebnisse mit Filter-Button, Sortier-Chips und Anzahl; Filter und Sortierung bleiben beim Ändern des Begriffs. Performer-Reihe mit „Alle anzeigen“. Die Lupe in der Bibliothek öffnet die Suche im aktuellen Bereich (Bilder, Galerien, sonst Szenen), auf Performer-/Studio-Seiten in deren Kategorie. Der Bilder-Tab hat kein eigenes Suchfeld mehr (Galerieseiten behalten ihres). | Next | ✅ |

## Epic 6 – Performer („Kanäle“)

| # | User Story | Akzeptanzkriterien | Prio | Status |
|---|---|---|---|---|
| 6.1 | Als Nutzer möchte ich alle Performer als Raster sehen und endlos scrollen. | Porträtkarten mit Name, Flagge und Anzahl der Szenen. Paginiert. | MVP | ✅ |
| 6.2 | Als Nutzer möchte ich Performer sortieren bzw. filtern (Name, Anzahl Szenen, Favoriten, Zufall). | Chip-Leiste. | MVP | ✅ |
| 6.3 | Als Nutzer möchte ich eine Kanalseite für einen Performer sehen: Header mit Bild und Infos, darunter alle Szenen. | Header (Bild, Name, Land, Alter, Szenen) und paginierte Szenenliste. | MVP | ✅ |
| 6.4 | Als Nutzer möchte ich einen Performer als Favoriten markieren („Abonnieren“). | `performerUpdate(favorite)` mit optimistischem UI-Update. Button „Favorite/Favorited“ auf der Kanalseite, Herz auf den Performer-Kacheln. Bei Fehler Rücksetzen und Snackbar. Favoriten-Listen und die Reihe „New from favorites“ laden danach neu. | Next | ✅ |
| 6.5 | Als Nutzer möchte ich einen „Abos“-Feed mit neuen Szenen meiner Favoriten. | Szenenfeed mit Filter `performer_favorite: true`. | Next | 🟡 (Reihe „New from favorites“ auf der Startseite ✅, eigener Tab offen) |
| 6.6 | Als Nutzer möchte ich die Kurzvideos eines Performers im Shorts-Format sehen. | Button „N Shorts“ auf der Kanalseite (nur wenn es welche gibt, nach den Shorts-Einstellungen Länge/Hochformat), öffnet den Shorts-Player mit den gemischten Videos des Performers und seinem Namen in der Kopfzeile. Bevorzugte Tags gelten dort nicht. | Next | ✅ |

## Epic 7 – Studios („Kanäle“)

| # | User Story | Akzeptanzkriterien | Prio | Status |
|---|---|---|---|---|
| 7.1 | Als Nutzer möchte ich alle Studios als Kanalliste sehen. | Logo, Name und Anzahl der Szenen. Paginiert. | MVP | ✅ |
| 7.2 | Als Nutzer möchte ich eine Studio-Kanalseite mit allen Szenen. | Header und paginierte Szenen. | MVP | ✅ |
| 7.3 | Als Nutzer möchte ich Unter- und Elternstudios sehen. | Studioseite: „Part of …“-Chip zum Elternstudio, Reihe der Unterstudios mit Szenenzahl, Schalter „Include sub-studios“ (Standard an, wenn Unterstudios existieren; Filter `depth: -1`). Studio-Liste zeigt das Elternstudio. | Later | ✅ |

## Epic 8 – Tags & Entdecken

| # | User Story | Akzeptanzkriterien | Prio | Status |
|---|---|---|---|---|
| 8.1 | Als Nutzer möchte ich auf einen Tag tippen und alle Szenen mit diesem Tag sehen. | Tags im Player sind antippbare Chips; Tag-Seite mit Kopfbereich (Bild, Szenenzahl, Beschreibung) und paginierten, sortierbaren Szenen. | Next | ✅ |
| 8.2 | Als Nutzer möchte ich eine „Entdecken“-Seite mit beliebten Tags. | Leere Suche zeigt „Popular tags“ (meistgenutzt zuerst); „See all“ öffnet ein endloses Tag-Raster mit Sortierung (Szenen, A–Z, neu). Nur Tags mit Szenen. | Later | ✅ |
| 8.3 | Als Nutzer möchte ich Tags erstellen und die Tags einer Szene im Player bearbeiten. | „Edit tags“/„Add tags“ im Player: Tags entfernen, aus der Suche hinzufügen oder neu anlegen (`tagCreate`), speichern per `sceneUpdate(tag_ids)` mit sofortiger Anzeige. Tag-Übersicht mit „New tag“. | Next | ✅ |

## Epic 9 – Bibliothek

| # | User Story | Akzeptanzkriterien | Prio | Status |
|---|---|---|---|---|
| 9.1 | Als Nutzer möchte ich meinen Wiedergabeverlauf sehen. | Library → „History“: gespielte Szenen (`play_count > 0`), zuletzt gesehen zuerst (`last_played_at`). | Next | ✅ |
| 9.2 | Als Nutzer möchte ich „Weiterschauen“ mit Fortschrittsbalken auf dem Thumbnail. | Szenen mit `resume_time > 0`. | Next | ✅ |
| 9.5 | Als Nutzer möchte ich alle Szenen meiner Bibliothek als kompaktes Raster durchsehen. | Tab „Library“ → „Scenes“: Raster mit Gesamtzahl, Sortier-Chips, Endlos-Scroll, langer Druck öffnet das Szenen-Menü. | Next | ✅ |
| 9.3 | Als Nutzer möchte ich Groups/Movies wie Playlists durchsehen und abspielen. | Library → „Groups“ (Poster-Raster); Gruppenseite mit Details und Szenen in Gruppenreihenfolge; „Play all“ spielt als Warteschlange mit Autoplay. Benötigt Stash v0.27+ (Groups). | Later | ✅ |
| 9.4 | Als Nutzer möchte ich eine Warteschlange („Später ansehen“). | „Later“ im Player und „Save to Watch later“ im ⋮-Menü (lokal gespeichert); Library → „Watch later“ mit „Play all“, Wischen zum Entfernen. Warteschlange unter dem Video mit aktueller Position, nächste Szene startet automatisch am Ende. | Later | ✅ |

## Epic 10 – Interaktion mit Szenen

| # | User Story | Akzeptanzkriterien | Prio | Status |
|---|---|---|---|---|
| 10.1 | Als Nutzer möchte ich eine Szene im Player bewerten (1–5 Sterne). | Sterne unter dem Titel; Tippen setzt `rating100` (Sterne × 20) per `sceneUpdate`, erneutes Tippen auf den aktuellen Wert entfernt die Bewertung; sofort sichtbar, bei Fehler zurückgesetzt. | Next | ✅ |
| 10.2 | Als Nutzer möchte ich den O-Counter erhöhen. | Zähler-Button im Player (`sceneAddO`), Snackbar mit „Undo“ (`sceneDeleteO`). | Later | ✅ |
| 10.3 | Als Nutzer möchte ich einen Scene Marker an der aktuellen Position setzen. | „Marker“-Button öffnet ein Sheet mit Position, optionalem Titel und Pflicht-Tag (Suche); `sceneMarkerCreate`, danach erscheint das Kapitel sofort. | Later | ✅ |
| 10.6 | Als Nutzer möchte ich alle Marker (markierte Stellen) auf einer Seite sehen. | Bibliotheksbereich „Marker“ (auch als eigener Tab wählbar, standardmäßig ausgeblendet): Raster aller Scene Marker aus `findSceneMarkers` mit Bild der Stelle, Zeitstempel, Titel, Szene und Tag; Sortierung neu, zufällig, A–Z. Tippen spielt die Szene ab der markierten Stelle. Die Kacheln zeigen Stashs kurze Marker-Vorschau in Dauerschleife (animiertes WebP, sonst das Standbild); über die Einstellung „Marker-Vorschauen abspielen“ abschaltbar, bei „Bewegung reduzieren“ aus. | Next | ✅ |

## Epic 11 – Sicherheit & Privatsphäre

| # | User Story | Akzeptanzkriterien | Prio | Status |
|---|---|---|---|---|
| 11.1 | Als Nutzer möchte ich die App mit PIN oder Biometrie sperren. | Einstellungen → „Privacy & security“: App-Sperre mit 4-stelliger PIN (nur gesalzener SHA-256-Hash gespeichert), optional Face ID/Fingerabdruck, Sperre beim Start und nach Rückkehr aus dem Hintergrund (sofort / 1 / 5 / 15 min; „sofort“ sperrt schon beim Verlassen, damit weder App-Umschalter noch Rückkehr Inhalt zeigen), PIN ändern, Abschalten nur mit PIN. PIN-Abfragen in den Einstellungen decken wie die Sperre den ganzen Bildschirm ab. Biometrie wird erst im Vordergrund abgefragt (iOS bricht sie sonst ab) und beim Einschalten einmal geprüft. Mit aktiver Sperre wird die App auch im inaktiven Zustand abgedeckt, und „Im App-Umschalter verbergen“ ist fest an. iOS deckt die App beim Sperren des iPhones nativ ab (liest die Einstellung selbst, da eine Nachricht beim Start verloren gehen konnte), damit beim Entsperren kein Inhalt vor der PIN-Abfrage aufblitzt. | Next | ✅ |
| 11.2 | Als Nutzer möchte ich, dass im App-Switcher kein Inhalt sichtbar ist. | Schalter „Hide in app switcher“: Abdeckung, sobald die App inaktiv ist (iOS-Snapshot); Android zusätzlich `FLAG_SECURE` (blockiert auch Screenshots). | Next | ✅ |
| 11.3 | Als Nutzer möchte ich die App-Icons bzw. den Namen tarnen können. | Einstellungen → „App icon“: Stash, Notes, Calculator. Android: Icon und Name über `activity-alias`; iOS: alternatives Icon (`setAlternateIconName`, Name bleibt, System zeigt eine Bestätigung). | Later | ✅ |

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
| 13.6 | Als Nutzer möchte ich die Primärfarbe der App wählen. | Farben in den Einstellungen (Standard: Stash), werden gespeichert. Textfarbe auf Buttons passt sich hellen Farben an. | Next | ✅ |
| 13.11 | Als Nutzer möchte ich das Stash-Logo und ein Stash-Farbschema. | Stash-Logo (offene Kiste, aus dem Stash-Projekt, als Pfad gezeichnet) auf Startseite und Login. Farbe „Stash (Blau/Braun)“: Blau #137CBD als Hauptfarbe, Braun #A08069 als Zweitfarbe (Tab-Markierung), im Dunkelmodus der blaugraue Stash-Hintergrund. Das Stash-Farbschema ist der Standard und steht in der Auswahl an erster Stelle. | Next | ✅ |
| 13.7 | Als Nutzer möchte ich die Navigationsleiste in den Einstellungen frei konfigurieren. | Tabs ein-/ausblenden (2–5, Einstellungen immer sichtbar) und per Drag sortieren. Zusätzlich wählbar: jeder Bibliotheksbereich (Szenen, Verlauf, Später ansehen, Gruppen, Bilder, Galerien, Statistik), Tags und Suche. Der erste Tab ist der Start-Tab. Wird gespeichert, „Zurücksetzen“ stellt den Standard her. | Next | ✅ |
| 13.8 | Als Nutzer möchte ich festlegen, was die Videokarten zeigen. | Einstellungen → „Videokarten“: Kanal = Studio oder Performer (jeweils mit dem anderen als Ersatz), Wiedergaben (auch „Keine Wiedergaben“) und Sterne ein-/ausblendbar. Gilt für Feed-Karten, Listen, Raster und Regale; gespeichert für alle Server. | Next | ✅ |
| 13.9 | Als Nutzer möchte ich die Einstellungen über die Kopfzeile öffnen und im letzten Tab Statistik und Server-Infos sehen. | Zahnrad in den Kopfzeilen der Tab-Seiten (Start, Performer, Studios, Bibliothek, Tags, Shorts). Die Einstellungen öffnen sich als Sheet über der ganzen App (auch unter Android): schließen mit X oder nach unten wischen; Unterseiten öffnen sich im Sheet. Der Tab „Statistik“ (Server: Name, URL, Stash-Version, API-Key; dazu die Statistik) ist immer sichtbar und standardmäßig der letzte. Gespeicherte Leisten bekommen ihn anstelle des alten Einstellungen-Tabs. | Next | ✅ |
| 13.10 | Als Nutzer möchte ich alle Ansichten über die Navigationsleiste erreichen. | Fester letzter Tab „Alle“ (nicht ausblendbar): Raster der Ansichten, die nicht in der Leiste sind, plus Einstellungen; die gewählte Ansicht öffnet sich im Tab „Alle“. Standard: Start, Performer, Bibliothek, Statistik, Alle; gespeicherte volle Leisten blenden ihren letzten ausblendbaren Tab aus. | Next | ✅ |
| 13.11 | Als Nutzer möchte ich zwischen Endlos-Scrollen und Seiten wählen. | Einstellungen → „Lange Listen“: Endlos scrollen (Standard) oder Seiten. Im Seiten-Modus zeigen Szenen, Bilder, Galerien, Gruppen, Performer, Studios und Tags je eine Seite mit Leiste (erste, vorherige, „Seite 3 von 12“, nächste, letzte; Antippen der Seitenzahl springt zu einer eingegebenen Seite); der Bild-Viewer blättert innerhalb der Seite. Gilt für alle Server, ein Wechsel lädt die Listen neu. Shorts und Regale bleiben endlos. | Next | ✅ |
| 13.3 | Als Nutzer möchte ich die App auf Deutsch und Englisch nutzen. | `flutter_localizations` und ARB-Dateien (`lib/l10n`). Folgt der Gerätesprache, in den Einstellungen umstellbar. Fehlermeldungen der App ebenfalls übersetzt. | Next | ✅ |
| 13.4 | Als Nutzer möchte ich ein App-Icon und einen Splashscreen. | App-Icon (Kartenstapel mit Play-Button) aus `tool/generate_app_icon.py`: iOS-Set, Android adaptiv mit monochromer Ebene. Splashscreen aus demselben Skript: das Motiv auf dem dunklen Icon-Hintergrund (#111111), Android bis 11 über `launch_background.xml`, ab 12 über den System-Splash (`values-v31`), iOS über `LaunchScreen.storyboard`; in hellem und dunklem Modus gleich. | Next | ✅ |
| 13.5 | Als Nutzer möchte ich Tablet- und Querformat-Layouts. | Mehrspaltiges Raster ab 600 dp. Umgesetzt: Szenen-Feeds (Karten und Zeilen), Suche, Verlauf, Gruppen, Später ansehen und Studios werden ab 600 dp mehrspaltig (`SliverColumns`); Raster passten sich schon an. Offen: Navigation Rail und zweispaltiger Player auf Tablets. | Later | ✅ |
| 13.12 | Als Nutzer möchte ich lebendige Animationen. | Favorit hinzufügen: Konfetti aus dem Button, Herz springt auf, Button wechselt animiert Farbe, Text und Breite (auch das Herz auf Performer-Kacheln). Play/Pause morpht ineinander und federt (Player, Miniplayer, Cast). Bei „Bewegung reduzieren“ ohne Animation. | Next | ✅ |
| 13.13 | Als Nutzer möchte ich nach dem ersten Login das Design wählen. | Einmaliger Dialog „Wähle dein Design“ nach dem Hinzufügen des ersten Servers: Hell/System/Dunkel und Akzentfarbe, sofort sichtbar; bleibt bis zum Anzeigen gespeichert (auch über einen Neustart). Bestehende Nutzer und weitere Server sehen ihn nicht. Dieselben Bedienelemente wie in den Einstellungen (`appearance_picker.dart`). | Next | ✅ |
| 13.14 | Als Nutzer möchte ich spürbares haptisches Feedback und dessen Stärke wählen. | Einstellung „Haptisches Feedback“: Aus, Wenig (nur die spürbaren Rückmeldungen: Favorit, O-Zähler, Langdruck-Menü, Aktualisieren, Entsperren, falsche PIN), Normal (zusätzlich Tabs, Sortier- und Filter-Chips, Schalter, Play/Pause, Wischen in den Shorts, Später ansehen, Theme/Farbe). | Next | ✅ |
| 13.15 | Als Nutzer möchte ich durch erneutes Tippen auf den aktiven Tab nach oben scrollen. | Aus einer Unterseite geht es zurück zur Startseite des Tabs, dort scrollen die Listen sanft nach oben (wie YouTube). | Next | ✅ |
| 13.16 | Als Nutzer möchte ich in Listen eine bewegte Vorschau sehen. | Ruht das Scrollen eine Weile (Standard 1,5 s, einstellbar 0,5–3 s), spielt das oberste vollständig sichtbare Video seine WebP-Vorschau (Stash `paths.webp`) über dem Standbild in Dauerschleife, wie YouTube; Scrollen stoppt sie. Gilt für alle Szenenlisten (Start, Bibliothek, Suche, Verlauf, Kanäle, Gruppen). Einstellung „Vorschauen in Listen abspielen“, bei „Bewegung reduzieren“ aus. | Next | ✅ |

## Epic 14 – Plattform & Release

| # | User Story | Akzeptanzkriterien | Prio | Status |
|---|---|---|---|---|
| 14.1 | Als Nutzer im Heimnetz möchte ich Server über `http://` erreichen. | Android `usesCleartextTraffic`, iOS-ATS-Ausnahme und Local-Network-Hinweis. | MVP | ✅ |
| 14.2 | Als Entwickler möchte ich Abhängigkeiten aktualisieren (Riverpod 3, graphql 5.2, media_kit 1.2). | Riverpod 3.4 (Family-Notifier mit Konstruktor-Argument, Retry-Policy nur für Netzwerkfehler), riverpod_lint 3 über `dart analyze`, ungenutzte Codegen-Pakete entfernt; Tests grün. | Next | ✅ |
| 14.4 | Als Entwickler möchte ich mit aktuellem JDK für Android bauen. | Gradle 9.3.1, AGP 9.1.0, Kotlin 2.4.0, Kotlin-DSL nach aktuellem Flutter-Template. | MVP | ✅ |
| 14.3 | Als Entwickler möchte ich signierte Release-Builds (APK/AAB, TestFlight). | Signing-Konfiguration, Fastlane o. Ä. Umgesetzt (Android): App-ID `io.github.two_play.stashappmobile` (iOS `io.github.two-play.stashappmobile`), Upload-Keystore über `android/key.properties`, Tag `vX.Y.Z` (passend zu `pubspec.yaml`) baut per GitHub Actions signierte APKs pro ABI, Universal-APK und AAB als GitHub-Release mit SHA256SUMS. Offen: iOS (TestFlight braucht einen Apple-Developer-Account). | Later | 🟡 (Android ✅) |

## Epic 17 – Metadaten bearbeiten

| # | User Story | Akzeptanzkriterien | Prio | Status |
|---|---|---|---|---|
| 17.1 | Als Nutzer möchte ich Szenen bearbeiten. | Titel, Beschreibung, Datum, Studio (Suche), Performer (Mehrfachauswahl), „Organized“; aus dem Player („Edit“) und dem ⋮-Menü. Nur geänderte Felder werden gesendet; der Player zeigt die Änderung sofort. | Next | ✅ |
| 17.2 | Als Nutzer möchte ich Performer, Studios, Tags und Galerien bearbeiten. | ✎ in der App-Bar der jeweiligen Seite: Performer (Name, Disambiguation, Geschlecht, Geburtsdatum, Land, Details), Studio (Name, Elternstudio, Details), Tag (Name, Beschreibung), Galerie (Titel, Datum, Details). | Next | ✅ |
| 17.3 | Als Nutzer möchte ich Bilder (Cover/Porträts) und URLs bearbeiten. | Bildfeld in den Formularen (Szenen-Cover, Performer-Bild, Studio-Logo, Tag-Bild): Foto aus der Mediathek (auf max. 2048 px verkleinert) oder Bild-URL; Upload als data-URI. URL-Listen für Szenen, Performer und Galerien (nur wenn der Server sie unterstützt), Website-Feld für Studios. | Later | ✅ |

## Epic 15 – Bilder & Galerien

| # | User Story | Akzeptanzkriterien | Prio | Status |
|---|---|---|---|---|
| 15.1 | Als Nutzer möchte ich alle Bilder als Raster durchsehen. | Tab „Library“ → „Images“: Thumbnail-Raster mit Gesamtzahl, Sortierung, Endlos-Scroll. | Next | ✅ |
| 15.2 | Als Nutzer möchte ich Bilder im Vollbild ansehen. | Wischen zwischen Bildern, Pinch-Zoom und Doppeltipp-Zoom (an der getippten Stelle, erneut tippen zoomt heraus), Tippen blendet Infos (Titel, Studio, Datum, Position) ein/aus. Performer als antippbare Chips mit Avatar, die die Performer-Seite öffnen; fehlen Studio oder Performer, steht „Unbekanntes Studio“ bzw. „Unbekannter Performer“ da. Lädt beim Blättern nach. | Next | ✅ |
| 15.3 | Als Nutzer möchte ich Galerien durchsehen. | Library → „Galleries“: Cover-Raster mit Bildanzahl, Sortierung, Endlos-Scroll. Galerieseite mit Details, Studio/Performer-Chips (auch „Unbekannt“) und allen Bildern in Dateireihenfolge; Vollbild-Viewer zum Durchblättern. | Next | ✅ |
| 15.4 | Als Nutzer möchte ich Bilder nach Performer/Studio/Tag filtern. | Filter wie bei Szenen; Bilder auf den Kanalseiten. Umgesetzt: Suche (über die Suchseite, 5.6; auf Galerieseiten im Raster) und Filter-Knopf (Tags, Mindestbewertung, Qualität) über dem Bilder-Raster und auf Galerieseiten. Offen: Performer-/Studio-Filter, Bilder auf den Kanalseiten. | Later | 🟡 (Suche, Tags/Bewertung/Qualität ✅) |

## Epic 16 – Statistik

| # | User Story | Akzeptanzkriterien | Prio | Status |
|---|---|---|---|---|
| 16.1 | Als Nutzer möchte ich Statistiken zu meiner Bibliothek sehen. | Tab „Library“ → „Stats“: Szenen (Anzahl, Größe, Gesamtdauer), Bilder, Galerien, Performer, Studios, Tags, Speicher, Durchschnitt pro Szene. | Next | ✅ |
| 16.2 | Als Nutzer möchte ich meine Seh-Statistik sehen. | Aufrufe, Sehzeit, gesehene Szenen, O-Count; wird bei älteren Stash-Versionen ohne diese Felder ausgeblendet. | Next | ✅ |
| 16.3 | Als Nutzer möchte ich Verläufe sehen (z. B. Sehzeit pro Woche). | Diagramm aus dem Wiedergabeverlauf. | Later | ⬜ |
