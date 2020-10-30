import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stcerwallet/config/states.dart';
import 'package:stcerwallet/service/navigator_observer.dart';
import 'package:stcerwallet/service/services_provider.dart';
import 'package:stcerwallet/style/themes.dart';
import 'package:stcerwallet/pages/main_page.dart';
import 'package:stcerwallet/pages/routes/page.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final providers = await createProviders(AppConfig().params["ropsten"]);

  Store<AppState> store = new Store(appReducer,
      initialState: new AppState(theme: kLightTheme, loadingVisible: false));
  runApp(new App(store: store, providers: providers));
}

class App extends StatelessWidget {
  final Store<AppState> store;
  final List<SingleChildCloneableWidget> providers;

  App({this.store, this.providers});

  @override
  Widget build(BuildContext context) {
    return new MultiProvider(
        providers: providers,
        child: StoreProvider(
            store: store,
            child: new StoreBuilder<AppState>(builder: (context, store) {
              bool needLoadingVisible = store.state.loadingVisible;
              return Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Opacity(
                    opacity: needLoadingVisible ? 1.0 : 0.0,
                    child: _buildGlobalLoading(context),
                  ),
                  new MaterialApp(
                    theme: store.state.theme.themeData,
                    routes: _buildRoutes(),
                    home: new MainPage(),
                    navigatorObservers: [CustomNavigatorObserver.getInstance()],
                  ),
                ],
              );
            })));
  }

  Map<String, WidgetBuilder> _buildRoutes() {
    return new Map<String, WidgetBuilder>.fromIterable(
      kAllPages,
      key: (dynamic page) => '${page.routeName}',
      value: (dynamic page) => page.buildRoute,
    );
  }

  _buildGlobalLoading(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        const ModalBarrier(
          color: Colors.grey,
        ),
        Container(
          width: 102.0,
          height: 102.0,
          padding: EdgeInsets.all(24.0),
          decoration: BoxDecoration(
              color: theme.backgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(12.0))),
          child: new CircularProgressIndicator(),
        )
      ],
    );
  }
}
