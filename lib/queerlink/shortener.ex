defmodule Queerlink.Shortener do

  alias Queerlink.Repo
  alias Queerlink.Link

  @type hash :: String.t
  @type url  :: String.t

  @spec insert(url()) :: {:ok, hash()} | {:error, atom()}
  def insert(url) do
    with {:ok, :valid} <- check_url(url),
         {:ok, :uniq}  <- check_duplicate(url) do
           hash = gen_uid()
           %Link{}
           |> Link.changeset(%{source: url, hash: hash})
           |> Repo.insert

          {:ok, hash}
    else
      {:error, :duplicate, hash} ->
        {:ok, hash}
      error -> error
    end
  end

  @spec lookup(hash()) :: {:ok, url()} | {:error, :notfound}
  def lookup(hash) do
    case Repo.get_by(Link, hash: hash) do
      nil  -> {:error, :notfound}
      link -> {:ok, link.source}
    end
  end

  @spec check_url(url()) :: {:ok, :valid} | {:error, :invalid}
  defp check_url(url) do
    case url |> URI.parse |> validate_host do
      :ok -> {:ok, :valid}
      error    -> error
    end
  end

  @spec check_duplicate(url()) :: {:ok, :uniq} | {:error, :duplicate}
  defp check_duplicate(url) do
    case Repo.get_by(Link, source: url) do
      nil            -> {:ok, :uniq}
      %Link{}=link   -> {:error, :duplicate, link.hash}
    end
  end

  def gen_uid do
    ((:os.timestamp |> :calendar.now_to_universal_time
      |> :calendar.datetime_to_gregorian_seconds) - 719528*24*3600) + salt()
      |> Integer.to_string(36)
      |> String.downcase
  end

  defp salt do
    <<a:: 32, rest:: binary>> = :crypto.strong_rand_bytes(12)
    a
  end

  defp validate_host(uri) do
    case uri.host do
      "127.0" <> _foo ->
        {:error, :invalid}
      "localhost" ->
        {:error, :invalid}
      "::1" ->
        {:error, :invalid}
      nil ->
        validate_scheme(uri)
      _ -> :ok
    end
  end

  defp validate_scheme(uri) do
    case uri.scheme do
      "magnet" ->
        URI.to_string(uri)
      _ ->
        {:error, :invalid}
    end
  end
end
