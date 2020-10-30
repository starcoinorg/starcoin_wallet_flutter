import 'package:stcerwallet/components/form/paper_form.dart';
import 'package:stcerwallet/components/form/paper_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TransactionPayloadForm extends HookWidget {
  TransactionPayloadForm({
    @required this.transactionPayloadHex,
    @required this.onSubmit,
  });

  final String transactionPayloadHex;
  final void Function(String transactionPayloadHex) onSubmit;

  @override
  Widget build(BuildContext context) {
    final toController = useTextEditingController(text: transactionPayloadHex);
    //final transferStore = useWalletTransfer(context);

    return Center(
      child: Container(
        margin: EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: PaperForm(
            padding: 30,
            actionButtons: <Widget>[
              RaisedButton(
                child: const Text('Send now'),
                onPressed: () {
                  this.onSubmit(
                    toController.value.text,
                  );
                },
              )
            ],
            children: <Widget>[
              //PaperValidationSummary(null),
              PaperInput(
                controller: toController,
                labelText: 'Transaction Payload',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
