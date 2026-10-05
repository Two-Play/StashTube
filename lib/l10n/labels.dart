import '../data/models/list_queries.dart';
import '../data/models/scene_filter.dart';
import 'gen/app_localizations.dart';

// Display names of the data models' choices. The models themselves stay
// free of UI texts.

extension SceneSortLabel on SceneSort {
  String label(AppLocalizations l) => switch (this) {
        SceneSort.recentlyAdded => l.sortRecentlyAdded,
        SceneSort.newest => l.sortNewest,
        SceneSort.random => l.sortShuffle,
        SceneSort.topRated => l.sortTopRated,
        SceneSort.mostPlayed => l.sortMostPlayed,
        SceneSort.lastPlayed => l.sortRecentlyWatched,
        SceneSort.title => l.sortAlphabetical,
        SceneSort.groupOrder => l.sortGroupOrder,
      };
}

extension PerformerSortLabel on PerformerSort {
  String label(AppLocalizations l) => switch (this) {
        PerformerSort.name => l.sortName,
        PerformerSort.mostScenes => l.sortMostScenes,
        PerformerSort.favorites => l.sortFavorites,
        PerformerSort.random => l.sortShuffle,
      };
}

extension ImageSortLabel on ImageSort {
  String label(AppLocalizations l) => switch (this) {
        ImageSort.recentlyAdded => l.sortRecentlyAdded,
        ImageSort.newest => l.sortNewest,
        ImageSort.random => l.sortShuffle,
        ImageSort.topRated => l.sortTopRated,
        ImageSort.title => l.sortAlphabetical,
        ImageSort.path => l.sortFileName,
      };
}

extension GallerySortLabel on GallerySort {
  String label(AppLocalizations l) => switch (this) {
        GallerySort.recentlyAdded => l.sortRecentlyAdded,
        GallerySort.newest => l.sortNewest,
        GallerySort.random => l.sortShuffle,
        GallerySort.mostImages => l.sortMostImages,
        GallerySort.title => l.sortAlphabetical,
      };
}

extension TagSortLabel on TagSort {
  String label(AppLocalizations l) => switch (this) {
        TagSort.mostScenes => l.sortMostScenes,
        TagSort.name => l.sortAlphabetical,
        TagSort.recentlyAdded => l.sortRecentlyAdded,
      };
}

extension DurationFilterLabel on DurationFilter {
  String label(AppLocalizations l) => switch (this) {
        DurationFilter.any => l.durationAny,
        DurationFilter.short => l.durationShort,
        DurationFilter.medium => l.durationMedium,
        DurationFilter.long => l.durationLong,
      };
}

extension ResolutionFilterLabel on ResolutionFilter {
  String label(AppLocalizations l) => switch (this) {
        ResolutionFilter.any => l.resolutionAny,
        ResolutionFilter.hd => '720p+',
        ResolutionFilter.fullHd => '1080p+',
        ResolutionFilter.uhd => '4K+',
      };
}
