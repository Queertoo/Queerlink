defmodule QueerlinkWeb.PageController do
  use QueerlinkWeb, :controller

  alias Queerlink.Link
  alias Queerlink.Shortener

  def index(conn, _params) do
    changeset = Link.changeset(%Link{})
    render conn, "index.html", changeset: changeset
  end

  def create(conn, %{"link" => %{"url" => url}}) do
    case Shortener.insert(url) do
      {:ok, changeset} ->
        render(conn, "index.html", changeset: changeset)
      {:error, changeset} ->
        render(conn, "index.html", changeset: changeset)
    end
  end
end
