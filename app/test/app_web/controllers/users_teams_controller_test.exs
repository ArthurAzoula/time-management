defmodule AppWeb.UsersTeamsControllerTest do
  use AppWeb.ConnCase

  alias App.Accounts
  alias App.Accounts.UsersTeams

  @create_attrs %{

  }
  @update_attrs %{

  }
  @invalid_attrs %{}

  def fixture(:users_teams) do
    {:ok, users_teams} = Accounts.create_users_teams(@create_attrs)
    users_teams
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users_teams", %{conn: conn} do
      conn = get(conn, Routes.users_teams_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create users_teams" do
    test "renders users_teams when data is valid", %{conn: conn} do
      conn = post(conn, Routes.users_teams_path(conn, :create), users_teams: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.users_teams_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.users_teams_path(conn, :create), users_teams: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update users_teams" do
    setup [:create_users_teams]

    test "renders users_teams when data is valid", %{conn: conn, users_teams: %UsersTeams{id: id} = users_teams} do
      conn = put(conn, Routes.users_teams_path(conn, :update, users_teams), users_teams: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.users_teams_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, users_teams: users_teams} do
      conn = put(conn, Routes.users_teams_path(conn, :update, users_teams), users_teams: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete users_teams" do
    setup [:create_users_teams]

    test "deletes chosen users_teams", %{conn: conn, users_teams: users_teams} do
      conn = delete(conn, Routes.users_teams_path(conn, :delete, users_teams))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.users_teams_path(conn, :show, users_teams))
      end
    end
  end

  defp create_users_teams(_) do
    users_teams = fixture(:users_teams)
    %{users_teams: users_teams}
  end
end
