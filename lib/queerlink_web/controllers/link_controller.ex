defmodule QueerlinkWeb.LinkController do
  use QueerlinkWeb, :controller
  import QueerlinkWeb.Router.Helpers, only: [link_url: 3]

  def shorten(conn, %{"url" => ""}) do
    conn
    |> put_status(400)
    |> json(%{status: "error", message: "Invalid URL"})
  end

  def shorten(conn, %{"url" => url}) do
    case Queerlink.insert(url) do
      {:ok, hash} ->
        conn
        |> put_status(201)
        |> json(%{status: "success", longUrl: url, shortUrl: link_url(QueerlinkWeb.Endpoint, :expand, hash)})
      {:error, :invalid} ->
        conn
        |> put_status(400)
        |> json(%{status: "error", message: "Invalid URL"})
    end
  end

  def expand(conn, %{"hash" => hash}) do
    case Queerlink.lookup(hash) do
      {:error, :notfound} ->
        conn
        |> put_status(404)
        |> json(%{status: "error",})
      {:ok, url}          -> redirect(conn, external: url)
    end
  end
end
