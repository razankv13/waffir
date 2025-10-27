import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'package:waffir/core/constants/app_constants.dart';
import 'package:waffir/core/utils/logger.dart';
import 'package:waffir/core/storage/models/app_settings.dart';

/// Service for managing Hive local storage with encryption
class HiveService {

  HiveService._internal();
  static HiveService? _instance;
  static const String _encryptionKeyStorageKey = 'hive_encryption_key';
  
  static const _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  static HiveService get instance {
    _instance ??= HiveService._internal();
    return _instance!;
  }

  /// Initialize Hive with encryption
  Future<void> initialize() async {
    try {
      AppLogger.info('🗃️ Initializing Hive storage service');

      // Get application documents directory
      final appDocumentDir = await getApplicationDocumentsDirectory();
      final hiveDirectory = Directory('${appDocumentDir.path}/hive');
      
      // Create hive directory if it doesn't exist
      if (!await hiveDirectory.exists()) {
        await hiveDirectory.create(recursive: true);
      }

      // Initialize Hive with custom directory
      Hive.init(hiveDirectory.path);

      // Register type adapters
      _registerAdapters();

      // Generate or retrieve encryption key
      final encryptionKey = await _getOrGenerateEncryptionKey();

      // Open encrypted boxes
      await _openEncryptedBoxes(encryptionKey);

      // Open non-encrypted boxes
      await _openRegularBoxes();

      AppLogger.info('✅ Hive storage service initialized successfully');
    } catch (e, stackTrace) {
      AppLogger.error(
        '❌ Failed to initialize Hive storage service',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Register Hive type adapters
  void _registerAdapters() {
    try {
      // Register AppSettings adapter if not already registered
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(AppSettingsAdapter());
        AppLogger.debug('Registered AppSettingsAdapter');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to register Hive adapters',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Generate or retrieve encryption key for sensitive data
  Future<Uint8List> _getOrGenerateEncryptionKey() async {
    try {
      // Try to get existing key from secure storage
      final existingKey = await _secureStorage.read(key: _encryptionKeyStorageKey);
      
      if (existingKey != null) {
        AppLogger.debug('Retrieved existing Hive encryption key');
        return base64Decode(existingKey);
      }

      // Generate new encryption key
      AppLogger.info('Generating new Hive encryption key');
      final key = Uint8List.fromList(Hive.generateSecureKey());
      
      // Store the key securely
      await _secureStorage.write(
        key: _encryptionKeyStorageKey,
        value: base64Encode(key),
      );

      AppLogger.debug('New Hive encryption key generated and stored');
      return key;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to get or generate Hive encryption key',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Open encrypted boxes for sensitive data
  Future<void> _openEncryptedBoxes(Uint8List encryptionKey) async {
    try {
      final cipher = HiveAesCipher(encryptionKey);

      // Open secure box for sensitive data (tokens, credentials, etc.)
      if (!Hive.isBoxOpen(AppConstants.secureBoxName)) {
        await Hive.openBox(
          AppConstants.secureBoxName,
          encryptionCipher: cipher,
        );
        AppLogger.debug('Opened encrypted secure box');
      }

      // Open user box with encryption for user data
      if (!Hive.isBoxOpen(AppConstants.userBoxName)) {
        await Hive.openBox(
          AppConstants.userBoxName,
          encryptionCipher: cipher,
        );
        AppLogger.debug('Opened encrypted user box');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to open encrypted boxes',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Open regular boxes for non-sensitive data
  Future<void> _openRegularBoxes() async {
    try {
      // Open settings box for app preferences
      if (!Hive.isBoxOpen(AppConstants.settingsBoxName)) {
        await Hive.openBox(AppConstants.settingsBoxName);
        AppLogger.debug('Opened settings box');
      }

      // Open cache box for temporary data
      if (!Hive.isBoxOpen(AppConstants.cacheBoxName)) {
        await Hive.openBox(AppConstants.cacheBoxName);
        AppLogger.debug('Opened cache box');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to open regular boxes',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Get a box by name
  Box<T> getBox<T>(String boxName) {
    if (!Hive.isBoxOpen(boxName)) {
      throw Exception('Box $boxName is not open. Call initialize() first.');
    }
    return Hive.box<T>(boxName);
  }

  /// Get the secure box for sensitive data
  Box get secureBox => getBox(AppConstants.secureBoxName);

  /// Get the user box for user data
  Box get userBox => getBox(AppConstants.userBoxName);

  /// Get the settings box for app preferences
  Box get settingsBox => getBox(AppConstants.settingsBoxName);

  /// Get the cache box for temporary data
  Box get cacheBox => getBox(AppConstants.cacheBoxName);

  /// Store data in secure box
  Future<void> storeSecure(String key, dynamic value) async {
    try {
      await secureBox.put(key, value);
      AppLogger.debug('Stored secure data for key: $key');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to store secure data for key: $key',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Retrieve data from secure box
  T? getSecure<T>(String key) {
    try {
      final value = secureBox.get(key) as T?;
      if (value != null) {
        AppLogger.debug('Retrieved secure data for key: $key');
      }
      return value;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to retrieve secure data for key: $key',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  /// Delete data from secure box
  Future<void> deleteSecure(String key) async {
    try {
      await secureBox.delete(key);
      AppLogger.debug('Deleted secure data for key: $key');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to delete secure data for key: $key',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Store user data
  Future<void> storeUser(String key, dynamic value) async {
    try {
      await userBox.put(key, value);
      AppLogger.debug('Stored user data for key: $key');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to store user data for key: $key',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Retrieve user data
  T? getUser<T>(String key) {
    try {
      final value = userBox.get(key) as T?;
      if (value != null) {
        AppLogger.debug('Retrieved user data for key: $key');
      }
      return value;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to retrieve user data for key: $key',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  /// Delete user data
  Future<void> deleteUser(String key) async {
    try {
      await userBox.delete(key);
      AppLogger.debug('Deleted user data for key: $key');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to delete user data for key: $key',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Store setting
  Future<void> storeSetting(String key, dynamic value) async {
    try {
      await settingsBox.put(key, value);
      AppLogger.debug('Stored setting for key: $key');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to store setting for key: $key',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Retrieve setting
  T? getSetting<T>(String key, {T? defaultValue}) {
    try {
      final value = settingsBox.get(key, defaultValue: defaultValue) as T?;
      if (value != null) {
        AppLogger.debug('Retrieved setting for key: $key');
      }
      return value;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to retrieve setting for key: $key',
        error: e,
        stackTrace: stackTrace,
      );
      return defaultValue;
    }
  }

  /// Delete setting
  Future<void> deleteSetting(String key) async {
    try {
      await settingsBox.delete(key);
      AppLogger.debug('Deleted setting for key: $key');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to delete setting for key: $key',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Store cache data with optional expiry
  Future<void> storeCache(
    String key,
    dynamic value, {
    Duration? expiry,
  }) async {
    try {
      final cacheData = {
        'value': value,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'expiry': expiry?.inMilliseconds,
      };
      
      await cacheBox.put(key, cacheData);
      AppLogger.debug('Stored cache data for key: $key');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to store cache data for key: $key',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Retrieve cache data (checks expiry)
  T? getCache<T>(String key) {
    try {
      final cacheData = cacheBox.get(key) as Map<String, dynamic>?;
      
      if (cacheData == null) {
        return null;
      }

      final timestamp = cacheData['timestamp'] as int?;
      final expiryMs = cacheData['expiry'] as int?;
      
      // Check if cache has expired
      if (timestamp != null && expiryMs != null) {
        final expiryTime = timestamp + expiryMs;
        final currentTime = DateTime.now().millisecondsSinceEpoch;
        
        if (currentTime > expiryTime) {
          AppLogger.debug('Cache expired for key: $key, removing');
          cacheBox.delete(key);
          return null;
        }
      }

      final value = cacheData['value'] as T?;
      if (value != null) {
        AppLogger.debug('Retrieved cache data for key: $key');
      }
      return value;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to retrieve cache data for key: $key',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  /// Delete cache data
  Future<void> deleteCache(String key) async {
    try {
      await cacheBox.delete(key);
      AppLogger.debug('Deleted cache data for key: $key');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to delete cache data for key: $key',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Clear all cache data
  Future<void> clearCache() async {
    try {
      await cacheBox.clear();
      AppLogger.info('Cleared all cache data');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to clear cache data',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Clear expired cache entries
  Future<void> clearExpiredCache() async {
    try {
      final keysToDelete = <String>[];
      final currentTime = DateTime.now().millisecondsSinceEpoch;

      for (final key in cacheBox.keys) {
        final cacheData = cacheBox.get(key) as Map<String, dynamic>?;
        
        if (cacheData != null) {
          final timestamp = cacheData['timestamp'] as int?;
          final expiryMs = cacheData['expiry'] as int?;
          
          if (timestamp != null && expiryMs != null) {
            final expiryTime = timestamp + expiryMs;
            if (currentTime > expiryTime) {
              keysToDelete.add(key.toString());
            }
          }
        }
      }

      for (final key in keysToDelete) {
        await cacheBox.delete(key);
      }

      AppLogger.info('Cleared ${keysToDelete.length} expired cache entries');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to clear expired cache',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Get storage statistics
  Map<String, dynamic> getStorageStats() {
    try {
      return {
        'boxes': {
          'secure': {
            'isOpen': Hive.isBoxOpen(AppConstants.secureBoxName),
            'length': Hive.isBoxOpen(AppConstants.secureBoxName) 
                ? secureBox.length 
                : 0,
          },
          'user': {
            'isOpen': Hive.isBoxOpen(AppConstants.userBoxName),
            'length': Hive.isBoxOpen(AppConstants.userBoxName) 
                ? userBox.length 
                : 0,
          },
          'settings': {
            'isOpen': Hive.isBoxOpen(AppConstants.settingsBoxName),
            'length': Hive.isBoxOpen(AppConstants.settingsBoxName) 
                ? settingsBox.length 
                : 0,
          },
          'cache': {
            'isOpen': Hive.isBoxOpen(AppConstants.cacheBoxName),
            'length': Hive.isBoxOpen(AppConstants.cacheBoxName) 
                ? cacheBox.length 
                : 0,
          },
        },
      };
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to get storage statistics',
        error: e,
        stackTrace: stackTrace,
      );
      return {'error': 'Failed to get statistics'};
    }
  }

  /// Close all boxes and cleanup
  Future<void> close() async {
    try {
      AppLogger.info('Closing Hive storage service');
      await Hive.close();
      AppLogger.info('✅ Hive storage service closed successfully');
    } catch (e, stackTrace) {
      AppLogger.error(
        '❌ Failed to close Hive storage service',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Delete all data and reset encryption key (use with caution)
  Future<void> resetStorage() async {
    try {
      AppLogger.warning('Resetting Hive storage - all data will be lost');

      // Close all boxes
      await Hive.close();

      // Delete all box files
      final appDocumentDir = await getApplicationDocumentsDirectory();
      final hiveDirectory = Directory('${appDocumentDir.path}/hive');
      
      if (await hiveDirectory.exists()) {
        await hiveDirectory.delete(recursive: true);
      }

      // Delete encryption key
      await _secureStorage.delete(key: _encryptionKeyStorageKey);

      AppLogger.warning('✅ Hive storage reset completed');
    } catch (e, stackTrace) {
      AppLogger.error(
        '❌ Failed to reset Hive storage',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}