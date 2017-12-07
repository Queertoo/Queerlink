defmodule Queerlink.Link do
  use Ecto.Schema
  import Ecto.Changeset
  alias Queerlink.Link


  schema "links" do
    field :source, :string
    field :hash,   :string
    timestamps()
  end

  def changeset(%Link{}=link, attrs\\%{}) do
    link
    |> cast(attrs, [:source, :hash])
    |> validate_required([:source, :hash])
  end

end
