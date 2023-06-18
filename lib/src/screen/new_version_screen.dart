import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';

/// card for show update app
class NewVersionScreen extends StatelessWidget {
  /// constructor
  const NewVersionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UpgradeCard(
        upgrader: Upgrader(
          showReleaseNotes: false,
          showIgnore: false,
          showLater: false,
          durationUntilAlertAgain: const Duration(milliseconds: 100),
        ),
      ),
    );
  }
}
