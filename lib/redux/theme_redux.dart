import 'package:stcerwallet/config/actions.dart';
import 'package:stcerwallet/style/themes.dart';
import 'package:redux/redux.dart';

final rThemeDataReducer = combineReducers<LTheme>([
  TypedReducer<LTheme, Action>(_toggle),
]);

LTheme _toggle(LTheme theme, action) {
  return theme.isDark() ? kLightTheme : kDarkTheme;
}
