defmodule App.WorkingTime do
  use Ecto.Schema
  import Ecto.Changeset

  schema "workingtime" do
    field :start, :naive_datetime
    field :end, :naive_datetime
    field :user, :id

    timestamps()
  end

  @doc false
  def changeset(working_time, attrs) do
    working_time
    |> cast(attrs, [:start, :end, :user])
    |> validate_required([:start, :end, :user])
  end
end
