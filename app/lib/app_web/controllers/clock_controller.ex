defmodule AppWeb.ClockController do
  use AppWeb, :controller

  alias App.Time
  alias App.Repo
  alias App.Time.Clock

  action_fallback AppWeb.FallbackController

  def index(conn, _params) do
    clocks = Time.list_clocks()
    render(conn, "index.json", clocks: clocks)
  end

  def create(conn, %{"userID" => user_id}) do
    # Prépare les paramètres avec user_id inclus
    clock_params = %{
      "user_id" => user_id,  # Associe le user_id au bon champ
      "time" => DateTime.utc_now(),
      "status" => true  # Exemple pour "clock in"
    }

    # Insère les données dans la table clocks
    with {:ok, %Clock{} = clock} <- Repo.insert(Clock.changeset(%Clock{}, clock_params)) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.clock_path(conn, :show, clock))
      |> render("show.json", clock: clock)
    else
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(AppWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    clock = Time.get_clock!(id)
    render(conn, "show.json", clock: clock)
  end

  def update(conn, %{"id" => id, "clock" => clock_params}) do
    clock = Time.get_clock!(id)

    with {:ok, %Clock{} = clock} <- Time.update_clock(clock, clock_params) do
      render(conn, "show.json", clock: clock)
    end
  end

  def delete(conn, %{"id" => id}) do
    clock = Time.get_clock!(id)

    with {:ok, %Clock{}} <- Time.delete_clock(clock) do
      send_resp(conn, :no_content, "")
    end
  end
end
