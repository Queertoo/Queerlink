defmodule Queerlink.Repo.Migrations.UniqueLinks do
  use Ecto.Migration

  def change do
    create index(:links, :source, unique: true)
    create index(:links, :hash, unique: true)
  end
end
