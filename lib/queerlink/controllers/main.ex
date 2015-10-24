defmodule Queerlink.Controllers.Main do
use Sugar.Controller
@host Application.get_env(:queerlink, :host, "localhost")

  def index(conn, []) do
    raw conn |> resp(200, "Hello world")
  end

  def api_shorten(conn, url) do
    data = Queerlink.Shortener.put_url(url) |> parse
    json(conn, data)
  end

  defp parse({:ok, id}), do: %{:status => "ok", :data => @host <> "/#{id}"}
  defp parse({:error, :not_found}), do: %{:status => "error", :data => "URL not found"}
end
