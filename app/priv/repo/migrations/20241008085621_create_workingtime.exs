defmodule App.Repo.Migrations.CreateWorkingtime do
  use Ecto.Migration

  def change do
    create table(:workingtime) do
      add :start, :naive_datetime, null: false
      add :end, :naive_datetime, null: false
      add :user, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:workingtime, [:user])
  end
end
