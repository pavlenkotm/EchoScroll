(* OCaml Ethereum Client *)
(* Functional programming for Web3 *)

open Lwt
open Cohttp
open Cohttp_lwt_unix
open Yojson.Basic

type eth_client = {
  rpc_url : string;
}

let create_client rpc_url = { rpc_url }

let rpc_call client method_name params =
  let open Yojson.Basic.Util in
  let body = `Assoc [
    ("jsonrpc", `String "2.0");
    ("method", `String method_name);
    ("params", `List params);
    ("id", `Int 1)
  ] in

  let body_str = Yojson.Basic.to_string body in
  let uri = Uri.of_string client.rpc_url in

  let%lwt resp, body = Client.post ~body:(`String body_str) uri in
  let%lwt body_str = Cohttp_lwt.Body.to_string body in

  let json = Yojson.Basic.from_string body_str in
  let result = json |> member "result" in
  Lwt.return result

let get_block_number client =
  let%lwt result = rpc_call client "eth_blockNumber" [] in
  let hex = Yojson.Basic.Util.to_string result in
  let block = int_of_string ("0x" ^ String.sub hex 1 (String.length hex - 2)) in
  Lwt.return block

let get_balance client address =
  let%lwt result = rpc_call client "eth_getBalance" [
    `String address;
    `String "latest"
  ] in
  Lwt.return (Yojson.Basic.Util.to_string result)

let () =
  let client = create_client "https://eth-mainnet.g.alchemy.com/v2/YOUR-API-KEY" in
  let vitalik = "0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045" in

  Lwt_main.run (
    let%lwt block = get_block_number client in
    let%lwt balance = get_balance client vitalik in

    Printf.printf "Block: %d\n" block;
    Printf.printf "Balance: %s\n" balance;

    Lwt.return_unit
  )
