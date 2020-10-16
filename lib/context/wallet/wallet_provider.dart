import 'package:stcerwallet/model/wallet.dart';
import 'package:stcerwallet/service/address_service.dart';
import 'package:stcerwallet/service/configuration_service.dart';
import 'package:stcerwallet/service/contract_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:provider/provider.dart';
import 'package:stcerwallet/service/watch_event_service.dart';

import '../hook_provider.dart';
import 'wallet_state.dart';
import 'wallet_handler.dart';

class WalletProvider extends ContextProviderWidget<WalletHandler> {
  WalletProvider({Widget child, HookWidgetBuilder<WalletHandler> builder})
      : super(child: child, builder: builder);

  @override
  Widget build(BuildContext context) {
    final store =
        useReducer<Wallet, WalletAction>(reducer, initialState: Wallet());

    final addressService = Provider.of<AddressService>(context);
    final contractService = Provider.of<ContractService>(context);
    final configurationService = Provider.of<ConfigurationService>(context);
    final watchEventService = Provider.of<WatchEventService>(context);

    final handler = useMemoized(
      () => WalletHandler(
        store,
        addressService,
        contractService,
        configurationService,
        watchEventService,
      ),
      [addressService, store],
    );

    return provide(context, handler);
  }
}

WalletHandler useWallet(BuildContext context) {
  var handler = Provider.of<WalletHandler>(context);

  return handler;
}
