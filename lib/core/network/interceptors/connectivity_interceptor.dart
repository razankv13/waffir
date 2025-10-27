import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:waffir/core/utils/logger.dart';

/// Exception thrown when there's no internet connection
class NoInternetException extends DioException {
  NoInternetException(RequestOptions requestOptions)
      : super(
          requestOptions: requestOptions,
          error: 'No internet connection',
          type: DioExceptionType.connectionError,
        );

  @override
  String toString() => 'NoInternetException: No internet connection available';
}

/// Interceptor for checking internet connectivity before making requests
class ConnectivityInterceptor extends Interceptor {
  final Connectivity _connectivity = Connectivity();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      
      if (await _isConnected(connectivityResult)) {
        handler.next(options);
      } else {
        AppLogger.warning('No internet connection for request: ${options.path}');
        handler.reject(NoInternetException(options));
      }
    } catch (e) {
      AppLogger.error(
        'Error checking connectivity for ${options.path}',
        error: e,
      );
      // If connectivity check fails, allow request to proceed
      // The actual network call will handle the failure appropriately
      handler.next(options);
    }
  }

  /// Check if device is connected to internet
  Future<bool> _isConnected(List<ConnectivityResult> connectivityResults) async {
    if (connectivityResults.contains(ConnectivityResult.none)) {
      return false;
    }

    // Check if we have any connection type that's not 'none'
    final hasConnection = connectivityResults.any((result) => 
      result == ConnectivityResult.wifi ||
      result == ConnectivityResult.mobile ||
      result == ConnectivityResult.ethernet ||
      result == ConnectivityResult.vpn ||
      result == ConnectivityResult.bluetooth ||
      result == ConnectivityResult.other
    );

    return hasConnection;
  }

  /// Static method to check connectivity without interceptor
  static Future<bool> isConnected() async {
    try {
      final connectivity = Connectivity();
      final connectivityResult = await connectivity.checkConnectivity();
      
      if (connectivityResult.contains(ConnectivityResult.none)) {
        return false;
      }

      // Check if we have any connection type that's not 'none'
      final hasConnection = connectivityResult.any((result) => 
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile ||
        result == ConnectivityResult.ethernet ||
        result == ConnectivityResult.vpn ||
        result == ConnectivityResult.bluetooth ||
        result == ConnectivityResult.other
      );

      return hasConnection;
    } catch (e) {
      AppLogger.error('Error checking static connectivity', error: e);
      // If check fails, assume connected to avoid blocking user
      return true;
    }
  }

  /// Get current connectivity status as string
  static Future<String> getConnectivityStatus() async {
    try {
      final connectivity = Connectivity();
      final connectivityResults = await connectivity.checkConnectivity();
      
      if (connectivityResults.contains(ConnectivityResult.none)) {
        return 'No Connection';
      }
      
      final connectionTypes = <String>[];
      for (final result in connectivityResults) {
        switch (result) {
          case ConnectivityResult.wifi:
            connectionTypes.add('WiFi');
            break;
          case ConnectivityResult.mobile:
            connectionTypes.add('Mobile Data');
            break;
          case ConnectivityResult.ethernet:
            connectionTypes.add('Ethernet');
            break;
          case ConnectivityResult.vpn:
            connectionTypes.add('VPN');
            break;
          case ConnectivityResult.bluetooth:
            connectionTypes.add('Bluetooth');
            break;
          case ConnectivityResult.other:
            connectionTypes.add('Other');
            break;
          case ConnectivityResult.none:
            // Already handled above
            break;
        }
      }
      
      return connectionTypes.isNotEmpty 
          ? connectionTypes.join(', ')
          : 'Unknown Connection';
    } catch (e) {
      AppLogger.error('Error getting connectivity status', error: e);
      return 'Unknown';
    }
  }

  /// Stream of connectivity changes
  static Stream<List<ConnectivityResult>> get connectivityStream {
    return Connectivity().onConnectivityChanged;
  }
}