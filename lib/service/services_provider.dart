import 'package:starcoin_wallet/wallet/json_rpc.dart';
import 'package:starcoin_wallet/wallet/pubsub.dart';
import 'package:stcerwallet/app_config.dart';
import 'package:stcerwallet/service/address_service.dart';
import 'package:stcerwallet/service/configuration_service.dart';
import 'package:stcerwallet/service/contract_service.dart';
import 'package:stcerwallet/service/network_manager.dart';
import 'package:stcerwallet/service/watch_event_service.dart';
import 'package:stcerwallet/service/deep_link_service.dart';
import 'package:stcerwallet/util/contract_parser.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class Services {
  final ContractService contractService;
  final AddressService addressService;
  final ConfigurationService configurationService;
  final WatchEventService watchEventService;
  final DeepLinkBloc deepLinkBloc;

  Services(this.contractService, this.addressService, this.configurationService,
      this.watchEventService, this.deepLinkBloc);
}

Future<List<SingleChildCloneableWidget>> createProviders(
    AppConfigParams params,ConfigurationService configurationService) async {
  final client = Web3Client(params.web3HttpUrl, Client(), socketConnector: () {
    return IOWebSocketChannel.connect(params.web3RdpUrl).cast<String>();
  });

  final addressService = AddressService(configurationService);
  final contract = await ContractParser.fromAssets(
      'TargaryenCoin.json', params.contractAddress);

  final contractService = ContractService(client, contract);

  final starcoinUrl=NetworkManager.getCurrentNetworkUrl();
  final socket = IOWebSocketChannel.connect(Uri.parse(starcoinUrl.wsUrl));
  final rpc = JsonRPC(starcoinUrl.httpUrl, Client());
  final pubSubClient = PubSubClient(socket.cast<String>(), rpc);

  final watchEventService = WatchEventService(pubSubClient);

  final bloc = DeepLinkBloc();

  return [
    Provider.value(value: addressService),
    Provider.value(value: contractService),
    Provider.value(value: configurationService),
    Provider.value(value: watchEventService),
    Provider.value(value: bloc),
  ];
}
