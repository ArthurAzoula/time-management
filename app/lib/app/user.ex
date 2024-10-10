defmodule App.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :email, :string
    has_one :clock, App.Clock, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email])
    |> validate_required([:username, :email])
    |> validate_format(:email, ~r/^[\w._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/)
  end
end
