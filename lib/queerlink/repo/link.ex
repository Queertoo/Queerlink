defmodule Queerlink.Link do
  use Ecto.Model

  schema "links" do
    field :uid, :string
    field :url, :string
    timestamps
  end
end
