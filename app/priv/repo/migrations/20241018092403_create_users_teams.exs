defmodule App.Repo.Migrations.CreateUsersTeams do
  use Ecto.Migration

  def change do
    create table(:users_teams) do
      add :user_id, references(:users, on_delete: :nothing)
      add :team_id, references(:teams, on_delete: :nothing)

      timestamps()
    end

    create index(:users_teams, [:user_id])
    create index(:users_teams, [:team_id])
    
    create unique_index(:users_teams, [:user_id, :team_id])
  end
end
