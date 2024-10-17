defmodule App.Accounts.Team do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field :name, :string
    belongs_to :manager, App.Accounts.User, foreign_key: :manager_id
    many_to_many :members, App.Accounts.User, join_through: "users_teams"

    timestamps()
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name, :manager])
    |> validate_required([:name, :manager])
  end
end
