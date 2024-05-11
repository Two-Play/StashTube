import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:miniplayer/miniplayer.dart';

import '../View/widgets/video_card_widget.dart';
import '../util/storage.dart';

class VideoState {
  static final StateProvider<Video?> _selectedVideoProvider = StateProvider<Video?>((ref) => null);
  static final _miniPlayerControllerProvider = StateProvider.autoDispose<MiniplayerController>(
        (ref) => MiniplayerController(),
  );

  static StateProvider<Video?> get selectedVideoProvider => _selectedVideoProvider;
  static AutoDisposeStateProvider<MiniplayerController> get miniPlayerControllerProvider => _miniPlayerControllerProvider;
}



class GraphQLState {
  static late String _graphqlUri;
  static late ValueNotifier<GraphQLClient> _client;
  static final GraphQLState _singleton = GraphQLState._internal();

  static ValueNotifier<GraphQLClient> get client => _client;

  GraphQLState._internal() {
    initClientWithKeyStore();
  }

  factory GraphQLState() {
    return _singleton;
  }

  static Future<void> initClientWithKeyStore() async {
    _graphqlUri = (await Storage.readKey("url"))!;
    _client = _initClientState();
  }

  static ValueNotifier<GraphQLClient> _initClientState() {
    final HttpLink httpLink = HttpLink(
      '$_graphqlUri/graphql',
    );

    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        link: httpLink,
        // The default store is the InMemoryStore, which does NOT persist to disk
        cache: GraphQLCache(store: HiveStore()),
      ),
    );
    return client;
  }

  static ValueNotifier<GraphQLClient> setNewClientUrl(String url) {
    _graphqlUri = url;
    return _client = GraphQLState._initClientState();
  }

  static Future<void> reconnect() async {
    await initClientWithKeyStore();
  }
}