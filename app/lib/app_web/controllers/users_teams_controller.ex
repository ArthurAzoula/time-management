defmodule AppWeb.UsersTeamsController do
  use AppWeb, :controller

  alias App.Accounts
  alias App.Accounts.UsersTeams

  action_fallback AppWeb.FallbackController

  def index(conn, _params) do
    users_teams = Accounts.list_users_teams()
    render(conn, "index.json", users_teams: users_teams)
  end

  def create(conn, %{"users_teams" => users_teams_params}) do
    with {:ok, %UsersTeams{} = users_teams} <- Accounts.create_users_teams(users_teams_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.users_teams_path(conn, :show, users_teams))
      |> render("show.json", users_teams: users_teams)
    end
  end

  def show(conn, %{"id" => id}) do
    users_teams = Accounts.get_users_teams!(id)
    render(conn, "show.json", users_teams: users_teams)
  end

  def update(conn, %{"id" => id, "users_teams" => users_teams_params}) do
    users_teams = Accounts.get_users_teams!(id)

    with {:ok, %UsersTeams{} = users_teams} <- Accounts.update_users_teams(users_teams, users_teams_params) do
      render(conn, "show.json", users_teams: users_teams)
    end
  end

  def delete(conn, %{"id" => id}) do
    users_teams = Accounts.get_users_teams!(id)

    with {:ok, %UsersTeams{}} <- Accounts.delete_users_teams(users_teams) do
      send_resp(conn, :no_content, "")
    end
  end
end
