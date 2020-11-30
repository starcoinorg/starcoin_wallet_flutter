import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stcerwallet/context/setup/wallet_setup_provider.dart';
import 'package:stcerwallet/context/transfer/wallet_transfer_provider.dart';
import 'package:stcerwallet/pages/profile/about_page.dart';
import 'package:stcerwallet/pages/profile/network_settings_page.dart';
import 'package:stcerwallet/pages/profile_page.dart';
import 'package:stcerwallet/pages/transactions/transaction_detail.dart';
import 'package:stcerwallet/pages/wallet/init/identity_init_page.dart';
import 'package:stcerwallet/pages/wallet/qrcode_reader_page.dart';
import 'package:stcerwallet/pages/wallet/wallet_import_page.dart';
import 'package:stcerwallet/pages/wallet/wallet_manage_page.dart';
import 'package:stcerwallet/pages/wallet/wallet_transfer_page.dart';
import 'package:stcerwallet/pages/wallet_page.dart';
import 'package:stcerwallet/pages/wallet/wallet_create_page.dart';
import 'dart:io';

class Page {
  final String title;

  final IconData leadingIcon;

  final VoidCallback leadingEvent;

  final String routeName;

  final WidgetBuilder buildRoute;

  Page(
      {this.title,
      this.leadingIcon,
      this.leadingEvent,
      @required this.routeName,
      @required this.buildRoute});

  @override
  String toString() {
    return 'Page{routeName: $routeName, buildRoute: $buildRoute}';
  }
}

final List<Page> kAllPages = _buildPages();

List<Page> _buildPages() {
  final List<Page> pages = <Page>[
    new Page(
        routeName: WalletPage.routeName,
        buildRoute: (BuildContext context) => new WalletPage()),
    new Page(
        routeName: ProfilePage.routeName,
        buildRoute: (BuildContext context) => new ProfilePage()),
    new Page(
        routeName: WalletManagePage.routeName,
        buildRoute: (BuildContext context) => new WalletManagePage()),
    new Page(
        routeName: WalletImportPage.routeName,
        buildRoute: (BuildContext context) => WalletSetupProvider(
              builder: (context, store) {
                return WalletImportPage("Import wallet");
              },
            )),
    new Page(
        routeName: IdentityInitPage.routeName,
        buildRoute: (BuildContext context) => new IdentityInitPage()),
    new Page(
        routeName: AboutPage.routeName,
        buildRoute: (BuildContext context) => new AboutPage()),
    new Page(
        routeName: WalletCreatePage.routeName,
        buildRoute: (BuildContext context) =>
            WalletSetupProvider(builder: (context, store) {
              useEffect(() {
                store.generateMnemonic();
                return null;
              }, []);

              return WalletCreatePage("Create Wallet");
            })),
    new Page(
        routeName: WalletTransferPage.routeName,
        buildRoute: (BuildContext context) =>
            WalletTransferProvider(builder: (context, store) {
              return WalletTransferPage(title: "Send Tokens");
            })),
    new Page(
        routeName: TransactionDetailPage.routeName,
        buildRoute: (BuildContext context) => new TransactionDetailPage(title: "Transaction Detail",)),
    new Page(
        routeName: NetworkPage.routeName,
        buildRoute: (BuildContext context) => new NetworkPage()),
  ];
  if (Platform.isIOS || Platform.isAndroid) {
    pages.add(new Page(
        routeName: QRCodeReaderPage.routeName,
        buildRoute: (BuildContext context) => new QRCodeReaderPage(
              title: "Scan QRCode",
              onScanned: ModalRoute.of(context).settings.arguments,
            )));
  }
  return pages;
}
