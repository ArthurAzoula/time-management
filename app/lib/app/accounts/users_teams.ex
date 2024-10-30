defmodule App.Accounts.UsersTeams do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users_teams" do
    field :user_id, :id
    field :team_id, :id

    timestamps()
  end

  @doc false
  def changeset(users_teams, attrs) do
    users_teams
    |> cast(attrs, [])
    |> validate_required([])
  end
end
