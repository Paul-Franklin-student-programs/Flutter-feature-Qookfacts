

import 'package:hive_flutter/hive_flutter.dart';


import 'package:hive/hive.dart';

part 'itemlist.g.dart';

// ,adapterName: 'UserAdapter'
@HiveType(typeId: 77 )
class ItemList extends HiveObject {
  ItemList({
     required this.name,
     required this.url,
  });

  @HiveField(0)
  String name;

  @HiveField(1)
  String url;

}




