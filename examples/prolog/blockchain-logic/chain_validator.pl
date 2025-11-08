% Prolog Blockchain Validator
% Logic programming for blockchain analysis

:- module(chain_validator, [
    valid_block/1,
    valid_chain/1,
    validate_transaction/1
]).

% Block structure
% block(Index, Timestamp, Data, PreviousHash, Hash, Nonce)

% Genesis block
genesis_block(block(0, 1231006505, 'Genesis Block', '0', 'genesis_hash', 0)).

% Validate single block
valid_block(block(Index, Timestamp, Data, PrevHash, Hash, Nonce)) :-
    Index >= 0,
    Timestamp > 0,
    atom(Data),
    atom(PrevHash),
    atom(Hash),
    Nonce >= 0,
    valid_hash(block(Index, Timestamp, Data, PrevHash, Hash, Nonce)).

% Validate hash meets difficulty
valid_hash(Block) :-
    calculate_hash(Block, Hash),
    Block = block(_, _, _, _, Hash, _),
    atom_concat('0000', _, Hash).  % Simplified proof-of-work

% Calculate block hash (simplified)
calculate_hash(block(Index, Timestamp, Data, PrevHash, _, Nonce), Hash) :-
    format(atom(Combined), '~w~w~w~w~w', [Index, Timestamp, Data, PrevHash, Nonce]),
    atom_string(Combined, Str),
    sha_hash(Str, HashBytes, [algorithm(sha256)]),
    hash_atom(HashBytes, Hash).

% Validate chain
valid_chain([_]).
valid_chain([Block1, Block2 | Rest]) :-
    valid_block(Block1),
    valid_block(Block2),
    blocks_linked(Block1, Block2),
    valid_chain([Block2 | Rest]).

% Check if blocks are properly linked
blocks_linked(block(Index1, _, _, _, Hash1, _), block(Index2, _, _, Hash1, _, _)) :-
    Index2 =:= Index1 + 1.

% Transaction validation
transaction(From, To, Amount, Signature).

validate_transaction(transaction(From, To, Amount, Signature)) :-
    atom(From),
    atom(To),
    Amount > 0,
    verify_signature(From, To, Amount, Signature).

% Verify signature (simplified)
verify_signature(From, To, Amount, Signature) :-
    format(atom(Message), '~w~w~w', [From, To, Amount]),
    % In real implementation, use proper cryptographic verification
    atom_length(Signature, Len),
    Len > 64.

% Query balance
balance(Address, Blocks, Balance) :-
    findall(Amount,
        (member(Block, Blocks),
         Block = block(_, _, transaction(_, Address, Amount, _), _, _, _)),
        Credits),
    findall(Amount,
        (member(Block, Blocks),
         Block = block(_, _, transaction(Address, _, Amount, _), _, _, _)),
        Debits),
    sum_list(Credits, TotalCredits),
    sum_list(Debits, TotalDebits),
    Balance is TotalCredits - TotalDebits.

% Find all transactions for address
transactions_for(Address, Blocks, Transactions) :-
    findall(Tx,
        (member(Block, Blocks),
         Block = block(_, _, Tx, _, _, _),
         Tx = transaction(From, To, _, _),
         (From = Address ; To = Address)),
        Transactions).

% Example usage
:- begin_tests(blockchain).

test(genesis_valid) :-
    genesis_block(Block),
    valid_block(Block).

test(chain_validation) :-
    genesis_block(B0),
    B1 = block(1, 1231007000, 'Block 1', 'genesis_hash', '0000abcd', 12345),
    valid_chain([B0, B1]).

:- end_tests(blockchain).
