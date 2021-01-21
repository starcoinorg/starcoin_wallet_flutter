import 'package:starcoin_wallet/starcoin/starcoin.dart';
import 'package:stcerwallet/components/form/paper_form.dart';
import 'package:stcerwallet/components/form/paper_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:starcoin_wallet/wallet/account.dart';
import 'package:stcerwallet/util/wallet_util.dart';

class TransferForm extends HookWidget {
  TransferForm({
    @required this.address,
    @required this.publicKey,
    @required this.onSubmit,
    @required this.tokens,
  });

  final String address;
  final String publicKey;
  final List<TokenBalance> tokens;
  final void Function(String address, String publicKey, String amount) onSubmit;

  @override
  Widget build(BuildContext context) {
    final toController = useTextEditingController(text: address);
    final toPublickeyController = useTextEditingController();
    final amountController = useTextEditingController();
    //final transferStore = useWalletTransfer(context);
    int choosedToken = 0;

    useEffect(() {
      if (address != null) toController.value = TextEditingValue(text: address);
      return null;
    }, [address]);

    final tokenDropdownList = this.tokens.asMap().entries.map((entry) {
      int idx = entry.key;

      return DropdownMenuItem(
        value: idx,
        child: Text(WalletUtil.formatTokenStructTag(
            entry.value.token.type_params[0] as TypeTagStructItem)),
      );
    }).toList();

    return Center(
      child: Container(
        margin: EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: PaperForm(
            padding: 30,
            actionButtons: <Widget>[
              RaisedButton(
                child: const Text('Transfer now'),
                onPressed: () {
                  this.onSubmit(
                    toController.value.text,
                    toPublickeyController.value.text,
                    amountController.value.text,
                  );
                },
              )
            ],
            children: <Widget>[
              //PaperValidationSummary(null),
              DropdownButton(
                value: choosedToken,
                onChanged: (int newVal) {
                  useEffect(() {
                    choosedToken = newVal;
                  });
                },
                items: tokenDropdownList,
              ),
              PaperInput(
                controller: toController,
                labelText: 'To Address',
                hintText: 'Type the destination address',
              ),
              PaperInput(
                controller: toPublickeyController,
                labelText: 'To Public Key',
                hintText: 'Type the destination address',
              ),
              PaperInput(
                controller: amountController,
                labelText: 'Amount',
                hintText: 'And amount',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
