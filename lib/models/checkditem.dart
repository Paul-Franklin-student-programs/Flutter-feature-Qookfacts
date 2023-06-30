class CheckDitem {
  List<Items> items = [];
  int itemCount = 0;

  CheckDitem({required this.items,required this.itemCount});

  static CheckDitem empty() => CheckDitem(items: [], itemCount: 0);

  CheckDitem.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items.add(Items.fromJson(v));
      });
    }
    itemCount = json['itemCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['items'] = items.map((v) => v.toJson()).toList();
    data['itemCount'] = itemCount;
    return data;
  }
}

class Items {
  String name = '';
  String imageUrl = '';

  Items({required this.name, required this.imageUrl});

  Items.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['imageUrl'] = imageUrl;
    return data;
  }
}
