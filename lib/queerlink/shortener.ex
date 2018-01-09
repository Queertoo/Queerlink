defmodule Queerlink.Shortener do

  alias Queerlink.Repo
  alias Queerlink.Link

  require Logger

  @type hash :: String.t
  @type url  :: String.t

  @spec insert(url()) :: {:ok, hash()} | {:error, atom()}
  def insert(url) when is_binary(url) do
    Logger.debug "Got URL " <> url
    with  {:ok, new_url} <- Norma.normalize_if_valid(url),
          {:ok, :uniq}   <- check_duplicate(new_url), 
          result <- Link.changeset(%Link{}, %{source: new_url, hash: gen_uid()}) do
            Repo.insert result

            Logger.info(inspect result)
            {:ok, result}
    else
      {:error, :duplicate, link} ->
        result = Link.changeset(%Link{}, %{source: link.source, hash: link.hash})
        Logger.info(inspect result)
        {:ok, result}
      {:error, msg} ->
        result = Link.changeset(%Link{}, %{source: url, hash: gen_uid()})
        Logger.info(inspect msg)
        {:error, result}
    end
  end

  @spec lookup(hash()) :: {:ok, url()} | {:error, :notfound}
  def lookup(hash) do
    case Repo.get_by(Link, hash: hash) do
      nil  -> {:error, :notfound}
      link -> {:ok, link.source}
    end
  end

  @spec check_duplicate(url()) :: {:ok, :uniq} | {:error, :duplicate}
  defp check_duplicate(url) do
    case Repo.get_by(Link, source: url) do
      nil            -> {:ok, :uniq}
      %Link{}=link   -> {:error, :duplicate, link}
    end
  end

  def gen_uid do
    ((:os.timestamp |> :calendar.now_to_universal_time
      |> :calendar.datetime_to_gregorian_seconds) - 719528*24*3600) + salt()
      |> Integer.to_string(36)
      |> String.downcase
  end

  defp salt do
    <<a:: 32, _rest:: binary>> = :crypto.strong_rand_bytes(12)
    a
  end
end
