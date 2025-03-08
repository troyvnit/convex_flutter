import 'package:convex_flutter/convex_flutter.dart';

class ConvexClient {
  static ConvexClient? _instance;
  late final MobileConvexClient _client;

  static ConvexClient get instance => _instance!;

  static Future<ConvexClient> init({
    required String deploymentUrl,
    required String clientId,
  }) async {
    if (_instance == null) {
      await RustLib.init();
      final client = await MobileConvexClient.newInstance(
        deploymentUrl: deploymentUrl,
        clientId: clientId,
      );
      _instance = ConvexClient._internal(client);
    }
    return _instance!;
  }

  ConvexClient._internal(this._client);

  /// Executes a Convex query.
  Future<String> query(String name, Map<String, String> args) async {
    return await _client.query(name: name, args: args);
  }

  /// Subscribes to real-time updates from a Convex query.
  /// Returns a subscription handle that can be used to cancel the subscription.
  Future<ArcSubscriptionHandle> subscribe({
    required String name,
    required Map<String, String> args,
    required void Function(String) onUpdate,
    required void Function(String, String?) onError,
  }) async {
    return await _client.subscribe(
      name: name,
      args: args,
      onUpdate: (value) => onUpdate(value),
      onError: (message, value) => onError(message, value),
    );
  }

  /// Executes a Convex mutation.
  Future<String> mutation({
    required String name,
    required Map<String, String> args,
  }) async {
    return await _client.mutation(name: name, args: args);
  }

  /// Executes a Convex action.
  Future<String> action({
    required String name,
    required Map<String, String> args,
  }) async {
    return await _client.action(name: name, args: args);
  }

  /// Sets the authentication token for the client.
  Future<void> setAuth({required String? token}) async {
    return await _client.setAuth(token: token);
  }

  /// Cancels an active subscription using the provided subscription handle.
  void cancelSubscription(ArcSubscriptionHandle handle) {
    handle.dispose();
  }
}
