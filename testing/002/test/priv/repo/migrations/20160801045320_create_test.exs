defmodule Test.Repo.Migrations.CreateTest do
  use Ecto.Migration

  def change do
    create table(:test) do
      add :code, :integer, null: false
      add :str, :string, null: false, default: ""

      timestamps()
    end

    create index(:test, [:code], unique: true, concurrently: false)

  end
end
