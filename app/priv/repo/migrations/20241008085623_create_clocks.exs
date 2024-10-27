defmodule App.Repo.Migrations.CreateClocks do
  use Ecto.Migration

  def change do
    create table(:clocks) do
      add :status, :boolean, default: false, null: false
      add :time, :naive_datetime, null: false
      add :user, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create unique_index(:clocks, [:user])
  end
end
