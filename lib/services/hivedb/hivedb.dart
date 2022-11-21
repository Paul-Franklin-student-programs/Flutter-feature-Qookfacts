// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:path_provider/path_provider.dart';
//
// class StoreData extends ChangeNotifier {
//   Box box;
//   List conwordinlist =[];
//
//   void openBox()async{
//     var dir= await getApplicationDocumentsDirectory();
//     Hive.init(dir.path);
//     box = await Hive.openBox("testbox");
//     notifyListeners();
//   }
//
//   void AddData(data){
//     box.add(data);
//    notifyListeners();
//
//   }
//
//   dynamic getData(index){
//     return conwordinlist[index];
//   }
//
// }
