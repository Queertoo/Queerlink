defmodule QueerlinkWeb.LinkControllerTest do
  use QueerlinkWeb.ConnCase


  test "Shorten and lookup https://elixir-lang.org" do
    conn = 
      build_conn()
      # |> put_req_header("accept", "application/json")
      |> put_req_header("content-type", "application/json")
      |> post("/s", [url: "https://elixir-lang.org"])

    assert conn.status == 201
  end
end
