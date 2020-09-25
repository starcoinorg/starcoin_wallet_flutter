import 'package:stcerwallet/components/wallet/import_wallet_form.dart';
import 'package:stcerwallet/context/setup/wallet_setup_provider.dart';
import 'package:stcerwallet/model/wallet_setup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stcerwallet/pages/routes/routes.dart';

class WalletImportPage extends HookWidget {

  static const String routeName = Routes.wallet + '/import';

  WalletImportPage(this.title);

  final String title;

  Widget build(BuildContext context) {
    var store = useWalletSetup(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ImportWalletForm(
        errors: store.state.errors.toList(),
        onImport: !store.state.loading
            ? (type, value) async {
                switch (type) {
                  case WalletImportType.mnemonic:
                    if (!await store.importFromMnemonic(value)) return;
                    break;
                  case WalletImportType.privateKey:
                    if (!await store.importFromPrivateKey(value)) return;
                    break;
                  default:
                    break;
                }

                Navigator.of(context).popAndPushNamed("/");
              }
            : null,
      ),
    );
  }
}
