defmodule QueerlinkWeb.PageController do
  use QueerlinkWeb, :controller
  plug :scrub_params, "link" when action in [:create]

  alias Queerlink.Link
  alias Queerlink.Shortener

  def index(conn, _params) do
    changeset = Link.changeset(%Link{})
    render(conn, "index.html", [changeset: changeset, new: true])
  end

  def create(conn, %{"link" => %{"url" => nil}}) do
    changeset = Link.changeset(%Link{}, %{})
    render(conn, "index.html", [changeset: changeset, new: false])
  end

  def create(conn, %{"link" => %{"url" => url}}) do
    case Shortener.insert(url) do
      {:ok, changeset} ->
        render(conn, "index.html", [changeset: changeset, new: false])
      {:error, changeset} ->
        render(conn, "index.html", [changeset: changeset, new: false])
    end
  end
end
