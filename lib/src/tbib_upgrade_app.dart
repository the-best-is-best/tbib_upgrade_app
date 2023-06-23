import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tbib_upgrade_app/src/constants/cache_key.dart';
import 'package:tbib_upgrade_app/src/screen/new_version_screen.dart';
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
  static Future<bool> checkForUpdate() async {
    final prefs = await SharedPreferences.getInstance();
    // ignore: use_if_null_to_convert_nulls_to_bools
    var needUpdate = false;
    if (prefs.getBool(CacheKey.checkNeedUpdate) == true) {
      needUpdate = await _showAlert();
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
          needUpdate = await _showAlert();
        }
      } else {
        await prefs.setString(
          CacheKey.checkForUpdateDate,
          DateTime.now().add(_checkNewVersionEveryTime).toString(),
        );
        needUpdate = await _showAlert();
      }
    }
    return needUpdate;
  }

  static Future<bool> _showAlert() async {
    final prefs = await SharedPreferences.getInstance();

    final upgrader = Upgrader(
      showReleaseNotes: false,
      showIgnore: false,
      showLater: false,
      canDismissDialog: true,
      dialogStyle: Platform.isIOS
          ? UpgradeDialogStyle.cupertino
          : UpgradeDialogStyle.material,
      durationUntilAlertAgain: const Duration(milliseconds: 6),
      onUpdate: () {
// go to new version screen and remove all screen before
        Navigator.of(_navigatorKey.currentContext!).pushAndRemoveUntil(
          MaterialPageRoute<void>(
            builder: (context) => const NewVersionScreen(),
          ),
          (route) => true,
        );
        return true;
      },
    );

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
  static Future<bool> forceCheckUpdate() async {
    final needUpdate = await _showAlert();
    return needUpdate;
  }
}
