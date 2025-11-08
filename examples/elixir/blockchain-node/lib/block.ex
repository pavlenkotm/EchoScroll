defmodule Blockchain.Block do
  @moduledoc """
  Elixir Blockchain Node - Block Module
  Demonstrates functional programming for blockchain with OTP
  """

  alias __MODULE__

  defstruct [
    :index,
    :timestamp,
    :data,
    :previous_hash,
    :hash,
    :nonce
  ]

  @difficulty 4

  @doc """
  Create genesis block
  """
  def genesis do
    %Block{
      index: 0,
      timestamp: DateTime.utc_now() |> DateTime.to_unix(),
      data: "Genesis Block",
      previous_hash: "0",
      hash: nil,
      nonce: 0
    }
    |> mine_block()
  end

  @doc """
  Create new block
  """
  def new(index, data, previous_hash) do
    %Block{
      index: index,
      timestamp: DateTime.utc_now() |> DateTime.to_unix(),
      data: data,
      previous_hash: previous_hash,
      hash: nil,
      nonce: 0
    }
    |> mine_block()
  end

  @doc """
  Calculate block hash using SHA-256
  """
  def calculate_hash(%Block{} = block) do
    "#{block.index}#{block.timestamp}#{inspect(block.data)}#{block.previous_hash}#{block.nonce}"
    |> hash_string()
  end

  @doc """
  Mine block with proof-of-work
  """
  def mine_block(%Block{} = block) do
    target = String.duplicate("0", @difficulty)

    Stream.iterate(0, &(&1 + 1))
    |> Enum.reduce_while(block, fn nonce, acc ->
      candidate = %{acc | nonce: nonce}
      hash = calculate_hash(candidate)

      if String.starts_with?(hash, target) do
        {:halt, %{candidate | hash: hash}}
      else
        {:cont, acc}
      end
    end)
  end

  @doc """
  Validate block hash
  """
  def valid?(%Block{} = block) do
    expected_hash = calculate_hash(block)
    block.hash == expected_hash and String.starts_with?(block.hash, String.duplicate("0", @difficulty))
  end

  @doc """
  Validate chain linkage
  """
  def valid_link?(%Block{} = current, %Block{} = previous) do
    current.index == previous.index + 1 and
    current.previous_hash == previous.hash
  end

  # Private functions

  defp hash_string(string) do
    :crypto.hash(:sha256, string)
    |> Base.encode16(case: :lower)
  end
end

defmodule Blockchain.Chain do
  @moduledoc """
  Blockchain chain management
  """

  alias Blockchain.Block

  use GenServer

  # Client API

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def get_chain do
    GenServer.call(__MODULE__, :get_chain)
  end

  def add_block(data) do
    GenServer.call(__MODULE__, {:add_block, data})
  end

  def validate_chain do
    GenServer.call(__MODULE__, :validate)
  end

  # Server callbacks

  @impl true
  def init(_) do
    genesis = Block.genesis()
    {:ok, [genesis]}
  end

  @impl true
  def handle_call(:get_chain, _from, chain) do
    {:reply, chain, chain}
  end

  @impl true
  def handle_call({:add_block, data}, _from, [latest | _] = chain) do
    new_block = Block.new(
      latest.index + 1,
      data,
      latest.hash
    )

    new_chain = [new_block | chain]
    {:reply, new_block, new_chain}
  end

  @impl true
  def handle_call(:validate, _from, chain) do
    valid = validate_chain_impl(Enum.reverse(chain))
    {:reply, valid, chain}
  end

  # Private

  defp validate_chain_impl([_genesis | rest]) do
    rest
    |> Enum.zip(Enum.drop(rest, -1))
    |> Enum.all?(fn {current, previous} ->
      Block.valid?(current) and Block.valid_link?(current, previous)
    end)
  end
end
