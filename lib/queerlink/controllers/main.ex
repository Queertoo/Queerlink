defmodule Queerlink.Controllers.Main do
use Sugar.Controller
@host Application.get_env(:queerlink, :host)
require Logger

  def index(conn, []) do
    raw conn |> resp(200, "Hello world")
  end

  def url_redirect(conn, [id: id]) do
    case Queerlink.Shortener.get_url(id) do
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

  def expand(conn, [format: "json", id: id]) do
    data = Queerlink.Shortener.get_url(id) |> e_parse
    json(conn, data)
  end

  defp s_parse({:ok, id}), do: %{:status => "ok", :data => @host <> "/#{id}"}
  defp s_parse({:error, :not_found}), do: %{:status => "error", :data => "URL not found"}

  defp e_parse({:ok, url}), do: %{:status => "ok", :data => url}
  defp e_parse({:error, :not_found}), do: %{:status => "error", :data => "URL not found"}
end
