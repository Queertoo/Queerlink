defmodule Queerlink.Shortener do
@moduledoc false
use GenServer
alias Queerlink.Link
alias Queerlink.Repo
import Ecto.Query
require Logger

  def start_link, do: GenServer.start_link(__MODULE__, __MODULE__, name: __MODULE__)

  def get_url(uid) when is_integer(uid), do: get_url(Integer.to_string(uid))
  def get_url(uid) when is_binary(uid), do: GenServer.call(__MODULE__, {:get_url, uid})
  def put_url(url), do: GenServer.call(__MODULE__, {:put_url, url})


  # GenServer API
  def init(_args) do
    Logger.info(IO.ANSI.green <> "Shortener Initialiased" <> IO.ANSI.reset)
    {:ok, :ok}
  end

  def handle_call({:get_url, uid}, _from, state) do
    reply = lookup(uid) |> parse
    {:reply, reply, state}
  end

  def handle_call({:put_url, url}, _from, state) do
    Logger.debug("Got #{url} to shorten")
    uid = insert(url)
    {:reply, {:ok, uid}, state}
  end


  # Backend API
  def insert(url) do
    url |> check_duplicate |> insert_to_db(url)
  end

  @spec lookup(Integer) :: %Queerlink.Link{} | []
  def lookup(uid) do
    query = from l in Link, where: l.uid == ^uid, select: l
    Repo.all(query)
  end

  @spec check_duplicate(String.t) :: [String.t] | []
  defp check_duplicate(url) do
    query = from l in Link, where: l.url == ^url, select: l
    Repo.all(query)
  end

  defp insert_to_db([uid], _url), do: uid
  defp insert_to_db([], url) do
    uid = gen_uid()
    case Repo.insert(%Link{uid: uid, url: url}) do
      {:ok, link} ->
        {:ok, link.uid}
      _  ->
        Logger.error("Could not save the URL in the database :(")
        {:error, :not_saved}
    end
  end

  defp parse([]), do: {:error, :not_found}
  defp parse([link]) do
    {:ok, link.url}
  end

  def gen_uid do
    ((:os.timestamp |> :calendar.now_to_universal_time
      |> :calendar.datetime_to_gregorian_seconds) - 719528*24*3600) + salt
      |> Integer.to_string(36)
      |> String.downcase
  end

  def salt do
    <<a:: 32, rest:: binary>> = :crypto.rand_bytes(12)
    a
  end
end
