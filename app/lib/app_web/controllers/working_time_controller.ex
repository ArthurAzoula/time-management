defmodule AppWeb.WorkingTimeController do
  use AppWeb, :controller
  use PhoenixSwagger

  alias ElixirLS.LanguageServer.Plugins.Ecto.Schema
  alias App.Time
  alias App.Time.WorkingTime

  action_fallback(AppWeb.FallbackController)

  def swagger_info do
    %{
      tags: ["WorkingTime"],
      description: "WorkingTime management",
      produces: ["application/json"],
      consumes: ["application/json"],
      parameters: [
        %{
          name: "id",
          in: "path",
          description: "WorkingTime ID",
          required: true,
          type: :string
        },
        %{
          name: "workingtime",
          in: "body",
          description: "WorkingTime attributes",
          required: true,
          schema: %{
            type: :object,
            properties: %{
              user: %{type: :string},
              start: %{type: :naive_datetime},
              end: %{type: :naive_datetime}
            }
          }
        }
      ],
      responses: %{
        "200": %{
          description: "WorkingTime found",
          schema: %{
            type: :object,
            properties: %{
              user: %{type: :string},
              start: %{type: :naive_datetime},
              end: %{type: :naive_datetime}
            }
          }
        },
        "201": %{
          description: "WorkingTime created",
          schema: %{
            type: :object,
            properties: %{
              user: %{type: :string},
              start: %{type: :naive_datetime},
              end: %{type: :naive_datetime}
            }
          }
        },
        "204": %{
          description: "WorkingTime deleted"
        }
      }
    }
  end

  swagger_path :show_by_user_and_id do
    get("/api/workingtime/{userId}/{id}")
    summary("Show a workingtime by user and ID")
    description("Show a workingtime by user and ID")
    parameter(:userId, :path, :string, "User ID", required: true)
    parameter(:id, :path, :string, "WorkingTime ID", required: true)
    response(200, "OK", :WorkingTime)
  end

  swagger_path :show_by_user do
    get("/api/workingtime/{userId}")
    summary("Show workingtimes by user")
    description("Show workingtimes by user")
    parameter(:user_id, :path, :string, "User ID", required: true)
    parameter(:start, :query, :date, "Start date", required: false)
    parameter(:end, :query, :date, "End date", required: false)
    response(200, "OK", :WorkingTime)
  end

  swagger_path :create do
    post("/api/workingtime/{userId}")
    summary("Create a workingtime")
    description("Create a workingtime for a user")
    parameter(:userId, :path, :string, "User ID", required: true)
    parameter(:workingtime, :body, :WorkingTime, "WorkingTime attributes", required: true)
    response(201, "Created", :WorkingTime)
  end

  swagger_path :update do
    put("/api/workingtime/{id}")
    summary("Update a workingtime")
    description("Update a workingtime by ID")
    parameter(:id, :path, :string, "WorkingTime ID", required: true)
    parameter(:workingtime, :body, :WorkingTime, "WorkingTime attributes", required: true)
    response(200, "OK", :WorkingTime)
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete("/api/workingtime/{id}")
    summary("Delete a workingtime")
    description("Delete a workingtime by ID")
    parameter(:id, :path, :string, "WorkingTime ID", required: true)
    response(204, "No Content")
  end

  def index(conn, _params) do
    workingtime = Time.list_workingtime()
    render(conn, "index.json", working_times: workingtime)
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

  def show(conn, %{"userID" => user_id} = params) do
    working_times = Time.list_working_time_by_user(user_id, params)
    render(conn, "index.json", working_times: working_times)
  end

  def show_by_user(conn, %{"userID" => user_id} = params) do
    working_times = Time.list_working_time_by_user(user_id, params)
    render(conn, "index.json", working_times: working_times)
  end

  def show_by_user_and_id(conn, %{"userID" => user_id, "id" => id}) do
    case Time.get_working_time_by_user_and_id(user_id, id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Working time not found"})

      working_time ->
        conn
        |> put_status(:ok)
        |> json(working_time)
    end
  end

  def update(conn, %{"id" => id, "workingtime" => working_time_params}) do
    working_time = Time.get_working_time!(id)

    with {:ok, %WorkingTime{} = working_time} <-
           Time.update_working_time(working_time, working_time_params) do
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
