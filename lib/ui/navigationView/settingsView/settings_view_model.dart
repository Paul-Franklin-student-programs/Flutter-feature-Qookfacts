import 'package:stacked/stacked.dart';

class SettingsViewModel extends BaseViewModel {
  List<String> subsections = ['ACCOUNT', 'SYSTEM', 'ABOUT US'];

  List<SettingsTile> accountTiles = [
    SettingsTile('MY STORES', 'assets/images/v2/app_logo.svg'),
    SettingsTile('PAYMENT', 'assets/images/v2/app_logo.svg'),
  ];

  List<SettingsTile> systemTiles = [
    SettingsTile('MEASUREMENT SYSTEM', 'assets/images/v2/app_logo.svg'),
    SettingsTile('NOTIFICATIONS', 'assets/images/v2/app_logo.svg'),
  ];

  List<SettingsTile> aboutUsTiles = [
    SettingsTile('FEEDBACK', 'assets/images/v2/app_logo.svg'),
    SettingsTile('RATE US', 'assets/images/v2/app_logo.svg'),
  ];
}

class SettingsTile {
  final String label;
  final String iconAsset;

  SettingsTile(this.label, this.iconAsset);
}
