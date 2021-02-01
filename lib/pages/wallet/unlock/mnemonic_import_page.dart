import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stcerwallet/context/setup/wallet_setup_handler.dart';
import 'package:stcerwallet/model/identity.dart';
import 'package:stcerwallet/service/configuration_service.dart';
import 'package:stcerwallet/style/styles.dart';
import 'package:stcerwallet/view/edu_tips_widget.dart';
import 'package:stcerwallet/view/password_inputfield.dart';

class _ImportFormData {
  String name = '';

  String password = '';

  String rePassword = '';

  String mnemonic = '';

  bool hasBeenEdited() {
    return name != '' && password != '' && rePassword != '';
  }

  @override
  String toString() {
    return '_ImportFormData{name: $name, password: $password, rePassword: $rePassword}';
  }
}

class MnemonicImportPage extends StatelessWidget {
  _ImportFormData formData = new _ImportFormData();

  final WalletSetupHandler store;

  MnemonicImportPage(this.store);

  @override
  Widget build(BuildContext context) {
    final configurationService = Provider.of<ConfigurationService>(context);

    return new SafeArea(
        child: new Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _bodyTips(context),
        Divider(
          height: Dimens.line,
        ),
        _bodyMnemonic(context),
        _bodyIdentityName(context),
        _bodyPassword(context),
        _bodyRePassword(context),
        new Container(
          height: 45.0,
          margin: EdgeInsets.only(
              top: Dimens.divider, left: Dimens.padding, right: Dimens.padding),
          width: double.infinity,
          child: new RaisedButton(
            onPressed: () async {
              String password = formData.password;
              String name = formData.name;

              await configurationService.setIdentity(Identity(name, password));

              await store.importFromMnemonic(formData.mnemonic);
              Navigator.of(context).popUntil(ModalRoute.withName('/'));
            },
            child: new Text('Start Importing'),
          ),
        ),
        new Expanded(child: new Container()),
        new EduTipsWidget(title: 'What is Mnemonic Phrase')
      ],
    ));
  }

  _bodyTips(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return new Container(
      color: Color(0xFFFAFBFD),
      padding: EdgeInsets.symmetric(horizontal: Dimens.padding, vertical: 20.0),
      child: new Text(
        'You may reset the wallet password after importing with Mnemonic Phrase',
        style: new TextStyle(fontSize: 14.0, color: theme.primaryColor),
      ),
    );
  }

  _bodyIdentityName(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return new Container(
      margin: EdgeInsets.symmetric(horizontal: Dimens.padding, vertical: 0.0),
      child: new Theme(
        data: theme.copyWith(primaryColor: theme.dividerColor),
        child: new TextFormField(
          decoration: new InputDecoration(hintText: 'Identity Name'),
          onSaved: (value) {
            this.formData.name = value;
          },
        ),
      ),
    );
  }

  _bodyMnemonic(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return new Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
      margin: EdgeInsets.symmetric(
          horizontal: Dimens.padding, vertical: Dimens.divider),
      height: 80.0,
      decoration: new BoxDecoration(
          border: new Border.all(color: theme.dividerColor, width: 0.38),
          borderRadius: BorderRadius.all(Radius.circular(4.0))),
      child: new TextFormField(
        decoration: new InputDecoration(
            hintText: 'Please separate each Mnemonic Phrase with a space',
            border: InputBorder.none),
        maxLines: 6,
        onSaved: (value) {
          this.formData.mnemonic = value;
        },
      ),
    );
  }

  _bodyPassword(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return new Container(
      margin: EdgeInsets.symmetric(horizontal: Dimens.padding, vertical: 0.0),
      child: new Theme(
        data: theme.copyWith(primaryColor: theme.dividerColor),
        child: new PasswordField(
          labelText: 'Wallet Password',
          //onFieldSubmitted: (String value) {},
          onSaved: (value) {
            this.formData.password = value;
          },
        ),
      ),
    );
  }

  _bodyRePassword(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return new Container(
      margin: EdgeInsets.symmetric(horizontal: Dimens.padding, vertical: 0.0),
      child: new Theme(
        data: theme.copyWith(primaryColor: theme.dividerColor),
        child: new PasswordField(
          labelText: 'Repeat Password',
          onFieldSubmitted: (String value) {},
          onSaved: (value) {
            this.formData.rePassword = value;
          },
        ),
      ),
    );
  }
}
