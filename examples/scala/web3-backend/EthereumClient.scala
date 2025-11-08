// Scala Ethereum Client
// Functional Web3 backend using Scala and Web3j

import org.web3j.protocol.Web3j
import org.web3j.protocol.http.HttpService
import org.web3j.protocol.core.DefaultBlockParameterName
import org.web3j.crypto.{Credentials, RawTransaction, TransactionEncoder}
import org.web3j.utils.Convert
import org.web3j.utils.Numeric

import scala.concurrent.{Future, ExecutionContext}
import scala.util.{Try, Success, Failure}

case class Balance(wei: BigInt, ether: BigDecimal)
case class Transaction(hash: String, from: String, to: String, value: BigInt)

class EthereumClient(rpcUrl: String)(implicit ec: ExecutionContext) {

  private val web3j: Web3j = Web3j.build(new HttpService(rpcUrl))

  def getBalance(address: String): Future[Balance] = Future {
    val balanceWei = web3j
      .ethGetBalance(address, DefaultBlockParameterName.LATEST)
      .send()
      .getBalance

    val balanceEther = Convert.fromWei(balanceWei.toString, Convert.Unit.ETHER)

    Balance(balanceWei, balanceEther)
  }

  def getBlockNumber: Future[BigInt] = Future {
    web3j.ethBlockNumber().send().getBlockNumber
  }

  def getGasPrice: Future[BigInt] = Future {
    web3j.ethGasPrice().send().getGasPrice
  }

  def getTransaction(txHash: String): Future[Option[Transaction]] = Future {
    Option(web3j.ethGetTransactionByHash(txHash).send().getTransaction).map { tx =>
      Transaction(
        hash = tx.getHash,
        from = tx.getFrom,
        to = tx.getTo,
        value = tx.getValue
      )
    }
  }

  def sendTransaction(
    from: String,
    to: String,
    amount: BigDecimal,
    privateKey: String
  ): Future[String] = Future {
    val credentials = Credentials.create(privateKey)

    val nonce = web3j
      .ethGetTransactionCount(from, DefaultBlockParameterName.LATEST)
      .send()
      .getTransactionCount

    val amountWei = Convert.toWei(amount, Convert.Unit.ETHER).toBigInteger

    val rawTransaction = RawTransaction.createEtherTransaction(
      nonce,
      web3j.ethGasPrice().send().getGasPrice,
      BigInt(21000).bigInteger,
      to,
      amountWei
    )

    val signedMessage = TransactionEncoder.signMessage(rawTransaction, credentials)
    val hexValue = Numeric.toHexString(signedMessage)

    web3j.ethSendRawTransaction(hexValue).send().getTransactionHash
  }

  def close(): Unit = web3j.shutdown()
}

object EthereumClient {
  def apply(rpcUrl: String)(implicit ec: ExecutionContext): EthereumClient =
    new EthereumClient(rpcUrl)
}

// Example usage
object Main extends App {
  import scala.concurrent.ExecutionContext.Implicits.global
  import scala.concurrent.Await
  import scala.concurrent.duration._

  val client = EthereumClient("https://eth-mainnet.g.alchemy.com/v2/YOUR-API-KEY")

  val vitalik = "0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045"

  val result = for {
    balance <- client.getBalance(vitalik)
    blockNumber <- client.getBlockNumber
    gasPrice <- client.getGasPrice
  } yield {
    println(s"Address: $vitalik")
    println(s"Balance: ${balance.ether} ETH")
    println(s"Block: $blockNumber")
    println(s"Gas Price: ${Convert.fromWei(gasPrice.toString, Convert.Unit.GWEI)} Gwei")
  }

  Await.result(result, 30.seconds)
  client.close()
}
