defmodule AppWeb.WorkingTimeControllerTest do
  use AppWeb.ConnCase

  alias App.Time
  alias App.Time.WorkingTime

  @create_attrs %{
    start: ~N[2010-04-17 14:00:00],
    end: ~N[2010-04-17 14:00:00],
    user: 1
  }
  @update_attrs %{
    start: ~N[2011-05-18 15:01:01],
    end: ~N[2011-05-18 15:01:01],
    user: 1
  }
  @invalid_attrs %{start: nil, end: nil}

  def fixture(:working_time) do
    {:ok, working_time} = Time.create_working_time(@create_attrs)
    working_time
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    @tag :skip
    test "lists all workingtime", %{conn: conn} do
      conn = get(conn, Routes.working_time_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create working_time" do
    @tag :skip
    test "renders working_time when data is valid", %{conn: conn} do
      conn = post(conn, Routes.working_time_path(conn, :create), working_time: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.working_time_path(conn, :show, id))

      assert %{
               "id" => id,
               "end" => "2010-04-17T14:00:00",
               "start" => "2010-04-17T14:00:00"
             } = json_response(conn, 200)["data"]
    end
    @tag :skip
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.working_time_path(conn, :create), working_time: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update working_time" do
    setup [:create_working_time]
    @tag :skip
    test "renders working_time when data is valid", %{
      conn: conn,
      working_time: %WorkingTime{id: id} = working_time
    } do
      conn =
        put(conn, Routes.working_time_path(conn, :update, working_time),
          working_time: @update_attrs
        )

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.working_time_path(conn, :show, id))

      assert %{
               "id" => id,
               "end" => "2011-05-18T15:01:01",
               "start" => "2011-05-18T15:01:01",
               "user" => 1
             } = json_response(conn, 200)["data"]
    end
    @tag :skip
    test "renders errors when data is invalid", %{conn: conn, working_time: working_time} do
      conn =
        put(conn, Routes.working_time_path(conn, :update, working_time),
          working_time: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete working_time" do
    setup [:create_working_time]
    @tag :skip
    test "deletes chosen working_time", %{conn: conn, working_time: working_time} do
      conn = delete(conn, Routes.working_time_path(conn, :delete, working_time))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.working_time_path(conn, :show, working_time))
      end
    end
  end

  defp create_working_time(_) do
    working_time = fixture(:working_time)
    %{working_time: working_time}
  end
end
