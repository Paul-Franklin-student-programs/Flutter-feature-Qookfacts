import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qookit/ui/navigationView/pantryView/pantry_view_model.dart';
import 'package:qookit/ui/navigationView/pantryView/pantry_view_widgets.dart';
import 'package:stacked/stacked.dart';

import '../../../models/checkditem.dart';
import '../../../models/itemlist.dart';
import '../../../services/services.dart';

class PantryView extends StatefulWidget {
  @override
  State<PantryView> createState() => _PantryViewState();
}

class _PantryViewState extends State<PantryView> {
  @override
  CheckDitem respons;
  Box box;

  void initState() {

    // TODO: implement initState
    super.initState();

    ditemlist();
  }

  ditemlist() async {
    respons = await usersService.detectedItem();
    // print(
    //     "--------------------------------------respons--------------------------------");

    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox('ApiItem');
         box.clear();
    for(int i=0; i<respons.items.length; i++)
      {
    //     var  respo = Person(name: respons.items[i].name,url: respons.items[i].name);
    //
    //     // await  box.add(respons.items[i]);
    //


       await  box.add(ItemList(name: respons.items[i].name,url: respons.items[i].imageUrl));
      }
        // await box.put('CompareItem', respons);
    // for (int i = 0; i < respons.items.length; i++) {
    //   print(respons.items[i].name);
    //   print(respons.items[i].imageUrl);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PantryViewModel>.reactive(
      viewModelBuilder: () => PantryViewModel(),
      builder: (context, model, child) {
        return SafeArea(
            child: DefaultTabController(
          length: 3,
          child: Scaffold(body: FlexiblePantry()),
        ));
      },
    );
  }
}
