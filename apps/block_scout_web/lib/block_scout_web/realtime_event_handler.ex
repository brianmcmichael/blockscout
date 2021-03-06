defmodule BlockScoutWeb.RealtimeEventHandler do
  @moduledoc """
  Subscribing process for broadcast events from realtime.
  """

  use GenServer

  alias BlockScoutWeb.Notifier
  alias Explorer.Chain.Events.Subscriber

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init([]) do
    Subscriber.to(:address_coin_balances, :realtime)
    Subscriber.to(:addresses, :realtime)
    Subscriber.to(:block_rewards, :realtime)
    Subscriber.to(:blocks, :realtime)
    Subscriber.to(:internal_transactions, :realtime)
    Subscriber.to(:token_transfers, :realtime)
    Subscriber.to(:transactions, :realtime)
    # Does not come from the indexer
    Subscriber.to(:exchange_rate)
    {:ok, []}
  end

  @impl true
  def handle_info(event, state) do
    Notifier.handle_event(event)
    {:noreply, state}
  end
end
