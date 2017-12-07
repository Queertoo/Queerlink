defmodule Queerlink.Repo.Migrations.Links do
  use Ecto.Migration

  def change do
    create table(:links) do
      add :source, :string, null: false
      add :hash,   :string, null: false

      timestamps()
    end
  end
end
