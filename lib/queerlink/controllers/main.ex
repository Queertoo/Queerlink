defmodule Queerlink.Controllers.Main do
use Sugar.Controller
@host Application.get_env(:queerlink, :host, "localhost")
require Logger

  def index(conn, []) do
    raw conn |> resp(200, "Hello world")
  end

  def url_redirect(conn, [id: id]) do
    case Queerlink.Shortener.get_url(id) do
      {:ok, url} ->
        conn |> redirect(url)
      {:error, :not_found} ->
        conn |> render('not_found')
    end
  end
  def shorten(conn, [format: "json"]) do
    %{"url" => url} = conn.params
    data = Queerlink.Shortener.put_url(url) |> parse
    json(conn, data)
  end

  def expand(conn, [format: "json", id: id]) do
    data = Queerlink.Shortener.get_url(id) |> parse
    json(conn, data)
  end

  defp parse({:ok, id}), do: %{:status => "ok", :data => @host <> "/#{id}"}
  defp parse({:error, :not_found}), do: %{:status => "error", :data => "URL not found"}
end
