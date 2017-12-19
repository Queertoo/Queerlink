defmodule Queerlink.Link do
  use Ecto.Schema
  import Ecto.Changeset
  alias Queerlink.Link

  # @schemes ["http", "https", "ftp", "sftp", "ftps"]

  schema "links" do
    field :source, :string
    field :hash,   :string
    timestamps()
  end

  def changeset(%Link{}=link, attrs\\%{}) do
    link
    |> cast(attrs, [:source, :hash])
    |> validate_required([:source, :hash])
    |> validate_format(:source, ~r/(http|https|):\/\/.+/)
  end
end
