defmodule Queerlink.Controllers.Main do
use Sugar.Controller
@host Application.get_env(:queerlink, :host)
@port Application.get_env(:sugar, Queerlink.Router) |> Keyword.fetch!(:http) |> Keyword.fetch!(:port)
require Logger

  def index(conn, []) do
    raw conn |> resp(200, "Hello world")
  end

  def url_redirect(conn, [uid: uid]) do
    case Queerlink.Shortener.get_url(uid) do
      {:ok, url} ->
        conn |> redirect(url)
      {:error, :not_found} ->
        conn |> static("not_found.html")
    end
  end
  def shorten(conn, [format: "json"]) do
    %{"url" => url} = conn.params
    data = Queerlink.Shortener.put_url(url) |> s_parse
    json(conn, data)
  end

  def expand(conn, [format: "json", uid: uid]) do
    data = Queerlink.Shortener.get_url(uid) |> e_parse
    json(conn, data)
  end

  defp s_parse({:ok, link}) when is_map(link) do
    uid = link.uid
    case Mix.env do
      :prod -> %{:status => "ok", :data => "#{@host}/#{uid}"}
      _    -> %{:status => "ok", :data => "#{@host}:#{@port}/#{uid}"}
    end
  end

  defp e_parse({:ok, url}), do: %{:status => "ok", :data => url}
  defp e_parse({:error, :not_found}), do: %{:status => "error", :data => "URL not found"}
end
