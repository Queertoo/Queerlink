defmodule Queerlink.Shortener do
@moduledoc false
use GenServer
require Logger
@tab :shortened_urls

  def start_link, do: GenServer.start_link(__MODULE__, __MODULE__, name: __MODULE__)

  def get_url(id) when is_integer(id), do: get_url(Integer.to_string(id))
  def get_url(id) when is_binary(id), do: GenServer.call(__MODULE__, {:get_url, id})
  def put_url(url), do: GenServer.call(__MODULE__, {:put_url, url})

  # GenServer API

  def init(_args) do
    Logger.debug("Shortener Initialiased")
    :ets.new(@tab, [:named_table])
    {:ok, %St{next: 0}}
  end

  def handle_call({:get_url, id}, _from, state) do
    reply = case :ets.lookup(@tab, id) do
      [] -> {:error, :not_found}
      [{_id, url}] -> {:ok, url}
    end
    {:reply, reply, state}
  end

  def handle_call({:put_url, url}, _from, state) do
    Logger.debug("Got #{url} to shorten")
    %St{next: n} = state
    id = b36_encode(n)
    :ets.insert(@tab, {id, url})
    {:reply, {:ok, id}, %St{next: n+1}}
  end

  # Backend API
  def b36_encode(n) do
    Integer.to_string(n, 36)
  end
end
