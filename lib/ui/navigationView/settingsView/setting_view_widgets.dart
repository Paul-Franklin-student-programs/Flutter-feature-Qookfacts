import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qookit/ui/navigationView/settingsView/settings_view_model.dart';
import 'package:stacked/stacked.dart';

class SubSection extends ViewModelWidget<SettingsViewModel> {
  @override
  Widget build(context, model) {
    return Column(
      children: [
        Column(
          children: model.subsections
              .map((e) => e == 'ACCOUNT'
                  ? Column(
                      children: [
                        ListTile(
                          title: Text(
                            e,
                            style: TextStyle(fontFamily: 'lato_bold'),
                          ),
                        ),
                        Column(
                          children: model.accountTiles
                              .map((e) => ListTile(
                                    tileColor: Colors.white,
                                    leading: SvgPicture.asset(e.iconAsset),
                                    trailing: Icon(Icons.arrow_forward_ios),
                                    title: Text(
                                      e.label,
                                      style: TextStyle(fontFamily: 'lato_bold'),
                                    ),
                                  ))
                              .toList(),
                        )
                      ],
                    )
                  : Container())
              .toList(),
        ),
        Column(
          children: model.subsections
              .map((e) => e == 'SYSTEM'
                  ? Column(
                      children: [
                        ListTile(
                          title: Text(
                            e,
                            style: TextStyle(fontFamily: 'lato_bold'),
                          ),
                        ),
                        Column(
                            children: model.systemTiles
                                .map((e) => ListTile(
                                      tileColor: Colors.white,
                                      leading: SvgPicture.asset(e.iconAsset),
                                      title: Text(
                                        e.label,
                                        style:
                                            TextStyle(fontFamily: 'lato_bold'),
                                      ),
                                      trailing: Icon(Icons.arrow_forward_ios),
                                    ))
                                .toList())
                      ],
                    )
                  : Container())
              .toList(),
        ),
        Column(
          children: model.subsections
              .map((e) => e == 'ABOUT US'
                  ? Column(
                      children: [
                        ListTile(
                          title: Text(
                            e,
                            style: TextStyle(fontFamily: 'lato_bold'),
                          ),
                        ),
                        Column(
                            children: model.aboutUsTiles
                                .map((e) => ListTile(
                                    tileColor: Colors.white,
                                    leading: SvgPicture.asset(e.iconAsset),
                                    title: Text(
                                      e.label,
                                      style: TextStyle(fontFamily: 'lato_bold'),
                                    ),
                                    trailing: Icon(Icons.arrow_forward_ios)))
                                .toList())
                      ],
                    )
                  : Container())
              .toList(),
        ),
      ],
    );
  }
}
