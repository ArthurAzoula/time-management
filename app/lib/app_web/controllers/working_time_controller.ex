defmodule AppWeb.WorkingTimeController do
  use AppWeb, :controller

  alias App.Time
  alias App.Time.WorkingTime

  action_fallback AppWeb.FallbackController

  def index(conn, _params) do
    workingtime = Time.list_workingtime()
    render(conn, "index.json", workingtime: workingtime)
  end

  def create(conn, %{"userID" => user_id, "workingtime" => working_time_params}) do
    working_time_params = Map.put(working_time_params, "user", user_id)

    with {:ok, %WorkingTime{} = working_time} <- Time.create_working_time(working_time_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.working_time_path(conn, :show, working_time))
      |> render("show.json", working_time: working_time)
    end
  end

  def show(conn, %{"id" => id}) do
    working_time = Time.get_working_time!(id)
    render(conn, "show.json", working_time: working_time)
  end

  def update(conn, %{"id" => id, "workingtime" => working_time_params}) do
    working_time = Time.get_working_time!(id)

    with {:ok, %WorkingTime{} = working_time} <- Time.update_working_time(working_time, working_time_params) do
      render(conn, "show.json", working_time: working_time)
    end
  end

  def delete(conn, %{"id" => id}) do
    working_time = Time.get_working_time!(id)

    with {:ok, %WorkingTime{}} <- Time.delete_working_time(working_time) do
      send_resp(conn, :no_content, "")
    end
  end
end
