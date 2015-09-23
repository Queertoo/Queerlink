defmodule Queerlink.Controllers.Main do
  use Sugar.Controller

  def index(conn, []) do
    render(conn, 'index')
  end

  def shorten(conn, url: url) do
    short_url = Queerlink.Shortener.put_url(url)
    json(conn, short_url)
  end
end

