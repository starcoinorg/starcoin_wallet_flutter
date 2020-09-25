import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stcerwallet/context/wallet/wallet_provider.dart';
import 'package:stcerwallet/pages/market_page.dart';
import 'package:stcerwallet/pages/profile_page.dart';
import 'package:stcerwallet/pages/routes/routes.dart';
import 'package:stcerwallet/pages/wallet/wallet_main_page.dart';
import 'package:stcerwallet/pages/wallet_page.dart';
import 'package:stcerwallet/service/configuration_service.dart';
import 'package:stcerwallet/view/navigation_icon_view.dart';

import 'intro_page.dart';

class MainPage extends StatefulWidget {
  static const String routeName = Routes.main + "/index";

  @override
  State createState() {
    return new _MainPageState();
  }
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin{
  int _currentIndex = 0;
  BottomNavigationBarType _type = BottomNavigationBarType.fixed;
  List<NavigationIconView> _navigationViews;
  PageController pageController;

  @override
  void initState() {
    super.initState();

    _navigationViews = <NavigationIconView>[
      new NavigationIconView(
        icon: const Icon(Icons.trending_up),
        title: 'Market',
        vsync: this,
      ),
      new NavigationIconView(
        icon: const Icon(Icons.account_balance_wallet),
        title: 'Wallet',
        vsync: this,
      ),
      new NavigationIconView(
        icon: const Icon(Icons.person),
        title: 'Profile',
        vsync: this,
      )
    ];

    pageController = new PageController(initialPage: this._currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBar botNavBar = new BottomNavigationBar(
      items: _navigationViews
          .map((NavigationIconView navigationView) => navigationView.item)
          .toList(),
      currentIndex: _currentIndex,
      type: _type,
      onTap: (int index) {
        pageController.jumpToPage(index);
      },
    );


    var configurationService = Provider.of<ConfigurationService>(context);
    if (configurationService.didSetupWallet())
      return WalletProvider(builder: (context, store) {
        return new Scaffold(
          body: new PageView(
            children: <Widget>[
              new MarketPage(),
              new WalletPage(),
              new ProfilePage()
            ],
            controller: pageController,
            onPageChanged: onPageChanged,
          ),
          bottomNavigationBar: botNavBar,
        );

        //return WalletMainPage("Your wallet");
      });

    return IntroPage();

  }

  void onPageChanged(int index) {
    setState(() {
      this._currentIndex = index;
    });
  }

  // 释放此对象使用的资源
  @override
  void dispose() {
    // 调用父类的内容
    super.dispose();
    // 循环调用存储NavigationIconView类的列表中的项
    for (NavigationIconView view in _navigationViews)
      // 调用此方法后，对象不再可用
      view.controller.dispose();
  }
}
