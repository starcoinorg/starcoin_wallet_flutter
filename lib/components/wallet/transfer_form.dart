import 'package:stcerwallet/components/form/paper_form.dart';
import 'package:stcerwallet/components/form/paper_input.dart';
import 'package:stcerwallet/components/form/paper_validation_summary.dart';
//import 'package:stcerwallet/context/transfer/wallet_transfer_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TransferForm extends HookWidget {
  TransferForm({
    @required this.address,
    @required this.publicKey,
    @required this.onSubmit,
  });

  final String address;
  final String publicKey;
  final void Function(String address,String publicKey ,String amount) onSubmit;

  @override
  Widget build(BuildContext context) {
    final toController = useTextEditingController(text: address);
    final toPublickeyController = useTextEditingController();
    final amountController = useTextEditingController();
    //final transferStore = useWalletTransfer(context);

    useEffect(() {
      if (address != null) toController.value = TextEditingValue(text: address);
      return null;
    }, [address]);

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
