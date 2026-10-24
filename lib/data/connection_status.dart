import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/server_config.dart';

/// Whether the active server answered the last GraphQL call (STATE-1).
enum ServerReachability {
  /// Nothing reported yet for this server.
  unknown,
  reachable,

  /// The last call failed with a network error ([StashApiException.isNetworkError]).
  unreachable,
}

/// The connection status of the active server, reported by
/// `StashRepository._run` through the callback `stashRepositoryProvider`
/// passes in: a network error makes it [ServerReachability.unreachable], any
/// successful call [ServerReachability.reachable]. Server and auth errors
/// don't change it. Watches [activeServerIdProvider], so switching servers
/// starts over at [ServerReachability.unknown].
class ConnectionStatusNotifier extends Notifier<ServerReachability> {
  @override
  ServerReachability build() {
    ref.watch(activeServerIdProvider);
    return ServerReachability.unknown;
  }

  /// Called after every GraphQL call: true when it succeeded, false when the
  /// server could not be reached.
  void report({required bool reachable}) {
    final next = reachable ? ServerReachability.reachable : ServerReachability.unreachable;
    if (state != next) state = next;
  }
}

final connectionStatusProvider =
    NotifierProvider<ConnectionStatusNotifier, ServerReachability>(ConnectionStatusNotifier.new);
