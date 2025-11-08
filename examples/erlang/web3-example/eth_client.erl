-module(eth_client).
-export([start/0, get_block_number/1, get_balance/2]).

%% Erlang Ethereum Client
%% Concurrent, fault-tolerant Web3

start() ->
    application:start(inets),
    application:start(ssl),
    RpcUrl = "https://eth-mainnet.g.alchemy.com/v2/YOUR-API-KEY",
    Vitalik = "0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045",

    BlockNumber = get_block_number(RpcUrl),
    Balance = get_balance(RpcUrl, Vitalik),

    io:format("Block Number: ~p~n", [BlockNumber]),
    io:format("Balance: ~p~n", [Balance]),

    ok.

rpc_call(RpcUrl, Method, Params) ->
    Body = jsx:encode(#{
        <<"jsonrpc">> => <<"2.0">>,
        <<"method">> => list_to_binary(Method),
        <<"params">> => Params,
        <<"id">> => 1
    }),

    {ok, {{_Version, 200, _ReasonPhrase}, _Headers, ResponseBody}} =
        httpc:request(post,
                     {RpcUrl,
                      [{"Content-Type", "application/json"}],
                      "application/json",
                      Body},
                     [],
                     []),

    Response = jsx:decode(list_to_binary(ResponseBody)),
    maps:get(<<"result">>, Response).

get_block_number(RpcUrl) ->
    HexResult = rpc_call(RpcUrl, "eth_blockNumber", []),
    binary_to_integer(binary:part(HexResult, 2, byte_size(HexResult) - 2), 16).

get_balance(RpcUrl, Address) ->
    rpc_call(RpcUrl, "eth_getBalance", [list_to_binary(Address), <<"latest">>]).
