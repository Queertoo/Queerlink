defmodule Queerlink.Repo.Migrations.DataModel do
  use Ecto.Migration

  def change do
    create table(:links) do
      add :uid, :string
      add :url, :string
      timestamps
    end
  end
end
