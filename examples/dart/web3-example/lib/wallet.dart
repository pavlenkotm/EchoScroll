// Dart Web3 Wallet for Flutter
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

class Web3Wallet {
  late Web3Client client;
  final String rpcUrl;

  Web3Wallet(this.rpcUrl) {
    client = Web3Client(rpcUrl, Client());
  }

  Future<EtherAmount> getBalance(String address) async {
    final ethAddress = EthereumAddress.fromHex(address);
    return await client.getBalance(ethAddress);
  }

  Future<int> getBlockNumber() async {
    return await client.getBlockNumber();
  }

  Future<EtherAmount> getGasPrice() async {
    return await client.getGasPrice();
  }

  Future<String> sendTransaction({
    required String privateKey,
    required String toAddress,
    required double amountEther,
  }) async {
    final credentials = EthPrivateKey.fromHex(privateKey);
    final to = EthereumAddress.fromHex(toAddress);
    final amount = EtherAmount.fromUnitAndValue(
      EtherUnit.ether,
      amountEther,
    );

    final txHash = await client.sendTransaction(
      credentials,
      Transaction(
        to: to,
        value: amount,
      ),
      chainId: 1,
    );

    return txHash;
  }

  void dispose() {
    client.dispose();
  }
}

void main() async {
  final wallet = Web3Wallet('https://eth-mainnet.g.alchemy.com/v2/YOUR-API-KEY');

  final vitalik = '0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045';

  final balance = await wallet.getBalance(vitalik);
  final blockNumber = await wallet.getBlockNumber();
  final gasPrice = await wallet.getGasPrice();

  print('Balance: ${balance.getValueInUnit(EtherUnit.ether)} ETH');
  print('Block: $blockNumber');
  print('Gas: ${gasPrice.getValueInUnit(EtherUnit.gwei)} Gwei');

  wallet.dispose();
}
