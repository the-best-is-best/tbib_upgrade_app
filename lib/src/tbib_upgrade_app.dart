import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tbib_upgrade_app/src/constants/cache_key.dart';
import 'package:upgrader/upgrader.dart';

/// class for check update app
class TBIBCheckForUpdate {
  static late GlobalKey<NavigatorState> _navigatorKey;

  static late Duration _checkNewVersionEveryTime;

  /// init check update
  static void init(
    GlobalKey<NavigatorState> navigatorKey, {
    Duration checkNewVersionEveryTime = const Duration(hours: 6),
  }) {
    _checkNewVersionEveryTime = checkNewVersionEveryTime;
    _navigatorKey = navigatorKey;
  }

  /// check for update
  static Future<bool> checkForUpdate(Upgrader upgrader) async {
    final prefs = await SharedPreferences.getInstance();
    var needUpdate = false;
    // ignore: use_if_null_to_convert_nulls_to_bools
    if (prefs.getBool(CacheKey.checkNeedUpdate) == true) {
      needUpdate = await _showAlert(upgrader: upgrader);
    } else {
      // print(DateTime.now().isAfter(
      //     DateTime.parse(prefs.getString(CacheKey.checkForUpdateDate))));
      if (prefs.getString(CacheKey.checkForUpdateDate) != null) {
        if (DateTime.now().isAfter(
          DateTime.parse(prefs.getString(CacheKey.checkForUpdateDate)!),
        )) {
          await prefs.setString(
            CacheKey.checkForUpdateDate,
            DateTime.now().toString(),
          );
          needUpdate = await _showAlert(upgrader: upgrader);
        }
      } else {
        await prefs.setString(
          CacheKey.checkForUpdateDate,
          DateTime.now().add(_checkNewVersionEveryTime).toString(),
        );
        needUpdate = await _showAlert(upgrader: upgrader);
      }
    }
    return needUpdate;
  }

  static Future<bool> _showAlert({
    required Upgrader upgrader,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await upgrader.initialize();
    final needUpdate = upgrader.shouldDisplayUpgrade();
    upgrader.checkVersion(
      context: _navigatorKey.currentContext!,
    );
    if (needUpdate == true) {
      await prefs.setBool(CacheKey.checkNeedUpdate, true);
    } else {
      await prefs.setBool(CacheKey.checkNeedUpdate, false);
    }
    return needUpdate;
  }

  /// force check update
  static Future<bool> forceCheckUpdate(Upgrader upgrader) async {
    final needUpdate = await _showAlert(upgrader: upgrader);
    return needUpdate;
  }
}
