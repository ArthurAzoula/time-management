defmodule App.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @roles ~w(admin employee manager)a

  schema "users" do
    field :username, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :role, Ecto.Enum, values: @roles, default: :employee
    many_to_many :teams, App.Accounts.Team, join_through: "users_teams"
    has_one :clock, App.Clock

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password, :role])
    |> validate_required([:username, :email, :password])
    |> validate_format(:email, ~r/^[\w._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/)
    |> validate_length(:password, min: 8, max: 20)
    |> unique_constraint(:email)
    |> put_pass_hash()
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(pass))
      _ ->
        changeset
    end
  end
end
