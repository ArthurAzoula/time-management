defmodule App.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :name, :string
      add :manager_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:teams, [:manager_id])

    create table(:users_teams, primary_key: false) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :team_id, references(:teams, on_delete: :delete_all)
    end

    create index(:users_teams, [:user_id])
    create index(:users_teams, [:team_id])
  end
end
