import 'package:stacked/stacked.dart';

class PantryCatalogViewModel extends BaseViewModel{

  List<PantryCategory> categories = [
    PantryCategory('MEATS', 'assets/images/v2/app_logo.png'),
    PantryCategory('PRODUCE', 'assets/images/v2/app_logo.png'),
    PantryCategory('DRY PASTA', 'assets/images/v2/app_logo.png'),
    PantryCategory('DAIRY', 'assets/images/v2/app_logo.png'),
  ];
}

class PantryCategory{
  final String label;
  final String coverImage;

  PantryCategory(this.label, this.coverImage);
}