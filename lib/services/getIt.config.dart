// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'auth/auth_service.dart' as _i3;
import 'elastic/elastic_service.dart' as _i4;
import 'elastic/endpoints/ingredients_service.dart' as _i6;
import 'elastic/endpoints/recipes_service.dart' as _i9;
import 'elastic/endpoints/users_service.dart' as _i14;
import 'ml/ml_service.dart' as _i7;
import 'navigation/navigation_service.dart' as _i8;
import 'settings/settings_service.dart' as _i10;
import 'system/hive_service.dart' as _i5;
import 'system/system_service.dart' as _i11;
import 'theme/theme_service.dart' as _i12;
import 'user/user_service.dart' as _i13; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String environment, _i2.EnvironmentFilter environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  gh.singleton<_i3.AuthService>(_i3.AuthService());
  gh.factory<_i4.ElasticService>(() => _i4.ElasticService());
  gh.singleton<_i5.HiveService>(_i5.HiveService());
  gh.singleton<_i6.IngredientsService>(_i6.IngredientsService());
  gh.singleton<_i7.MlService>(_i7.MlService());
  gh.singleton<_i8.NavigationService>(_i8.NavigationService());
  gh.singleton<_i9.RecipesService>(_i9.RecipesService());
  gh.factory<_i10.SettingsService>(() => _i10.SettingsService());
  gh.factory<_i11.SystemService>(() => _i11.SystemService());
  gh.factory<_i12.ThemeService>(() => _i12.ThemeService());
  gh.singleton<_i13.UserService>(_i13.UserService());
  gh.singleton<_i14.UsersService>(_i14.UsersService());
  return get;
}
