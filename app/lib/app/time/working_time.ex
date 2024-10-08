defmodule App.Time.WorkingTime do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :start, :end, :user, :inserted_at, :updated_at]}
  schema "workingtime" do
    field :start, :naive_datetime
    field :end, :naive_datetime
    field :user, :integer

    timestamps()
  end

  @doc false
  def changeset(working_time, attrs) do
    working_time
    |> cast(attrs, [:start, :end, :user])
    |> validate_required([:start, :end, :user])
  end
end
