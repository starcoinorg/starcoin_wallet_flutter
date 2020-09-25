import 'package:stcerwallet/app_config.dart';
import 'package:stcerwallet/service/address_service.dart';
import 'package:stcerwallet/service/configuration_service.dart';
import 'package:stcerwallet/service/contract_service.dart';
import 'package:stcerwallet/util/contract_parser.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class Services {
  final ContractService contractService;
  final AddressService addressService;
  final ConfigurationService configurationService;

  Services(this.contractService,this.addressService,this.configurationService);
}

Future<Services> createServices(
    AppConfigParams params) async {
  final client = Web3Client(params.web3HttpUrl, Client(), socketConnector: () {
    return IOWebSocketChannel.connect(params.web3RdpUrl).cast<String>();
  });

  final sharedPrefs = await SharedPreferences.getInstance();

  final configurationService = ConfigurationService(sharedPrefs);
  final addressService = AddressService(configurationService);
  final contract = await ContractParser.fromAssets(
      'TargaryenCoin.json', params.contractAddress);

  final contractService = ContractService(client, contract);

  return Services(contractService, addressService, configurationService);
}

Future<List<SingleChildCloneableWidget>> createProviders(
    AppConfigParams params) async {
  final client = Web3Client(params.web3HttpUrl, Client(), socketConnector: () {
    return IOWebSocketChannel.connect(params.web3RdpUrl).cast<String>();
  });

  final sharedPrefs = await SharedPreferences.getInstance();

  final configurationService = ConfigurationService(sharedPrefs);
  final addressService = AddressService(configurationService);
  final contract = await ContractParser.fromAssets(
      'TargaryenCoin.json', params.contractAddress);

  final contractService = ContractService(client, contract);

  return [
    Provider.value(value: addressService),
    Provider.value(value: contractService),
    Provider.value(value: configurationService),
  ];
}
