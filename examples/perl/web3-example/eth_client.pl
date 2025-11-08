#!/usr/bin/env perl
# Perl Ethereum Client
# Classic scripting for Web3

use strict;
use warnings;
use LWP::UserAgent;
use JSON;

package EthClient;

sub new {
    my ($class, $rpc_url) = @_;
    $rpc_url //= 'https://eth-mainnet.g.alchemy.com/v2/YOUR-API-KEY';

    my $self = {
        rpc_url => $rpc_url,
        ua => LWP::UserAgent->new(),
    };

    return bless $self, $class;
}

sub rpc_call {
    my ($self, $method, $params) = @_;
    $params //= [];

    my $data = encode_json({
        jsonrpc => '2.0',
        method => $method,
        params => $params,
        id => 1,
    });

    my $response = $self->{ua}->post(
        $self->{rpc_url},
        'Content-Type' => 'application/json',
        Content => $data,
    );

    if ($response->is_success) {
        my $result = decode_json($response->content);
        return $result->{result};
    } else {
        die "HTTP error: " . $response->status_line;
    }
}

sub get_block_number {
    my ($self) = @_;
    my $hex = $self->rpc_call('eth_blockNumber');
    return hex($hex);
}

sub get_balance {
    my ($self, $address) = @_;
    return $self->rpc_call('eth_getBalance', [$address, 'latest']);
}

sub get_gas_price {
    my ($self) = @_;
    return $self->rpc_call('eth_gasPrice');
}

package main;

my $client = EthClient->new();
my $vitalik = '0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045';

print "Block Number: " . $client->get_block_number() . "\n";
print "Balance: " . $client->get_balance($vitalik) . "\n";
print "Gas Price: " . $client->get_gas_price() . "\n";

1;
