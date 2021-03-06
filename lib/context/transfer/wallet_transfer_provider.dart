import 'package:stcerwallet/context/transfer/wallet_transfer_handler.dart';
import 'package:stcerwallet/context/transfer/wallet_transfer_state.dart';
import 'package:stcerwallet/model/wallet_transfer.dart';
import 'package:stcerwallet/service/configuration_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:provider/provider.dart';

import '../hook_provider.dart';

class WalletTransferProvider
    extends ContextProviderWidget<WalletTransferHandler> {
  WalletTransferProvider(
      {Widget child, HookWidgetBuilder<WalletTransferHandler> builder})
      : super(child: child, builder: builder);

  @override
  Widget build(BuildContext context) {
    final store = useReducer<WalletTransfer, WalletTransferAction>(reducer,
        initialState: WalletTransfer());

    final configurationService = Provider.of<ConfigurationService>(context);

    final handler = useMemoized(
      () => WalletTransferHandler(store, configurationService),
      [ store],
    );

    return provide(context, handler);
  }
}

WalletTransferHandler useWalletTransfer(BuildContext context) {
  var handler = Provider.of<WalletTransferHandler>(context);

  return handler;
}
