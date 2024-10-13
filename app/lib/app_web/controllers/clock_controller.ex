defmodule AppWeb.ClockController do
  import Ecto.Query, warn: false
  use AppWeb, :controller
  use PhoenixSwagger

  alias ElixirLS.LanguageServer.Plugins.Phoenix
  alias App.Time
  alias App.Repo
  alias App.Time.Clock

  action_fallback(AppWeb.FallbackController)

  def swagger_info do
    %{
      tags: ["Clock"],
      description: "Clock management",
      produces: ["application/json"],
      consumes: ["application/json"],
      parameters: [
        %{
          name: "id",
          in: "path",
          description: "Clock ID",
          required: true,
          type: :string
        },
        %{
          name: "clock",
          in: "body",
          description: "Clock attributes",
          required: true,
          schema: %{
            type: :object,
            properties: %{
              time: %{type: :string},
              status: %{type: :boolean}
            }
          }
        }
      ],
      responses: %{
        "200": %{
          description: "Clock found",
          schema: %{
            type: :object,
            properties: %{
              time: %{type: :string},
              status: %{type: :boolean}
            }
          }
        },
        "201": %{
          description: "Clock created",
          schema: %{
            type: :object,
            properties: %{
              time: %{type: :string},
              status: %{type: :boolean}
            }
          }
        },
        "204": %{
          description: "Clock deleted"
        }
      }
    }
  end

  swagger_path :create do
    post("/api/clocks/{userId}")
    summary("Create a clock")
    description("Create a clock for the user")
    parameter(:userId, :path, :string, "User ID", required: true)
    parameter(:clock, :body, Schema.ref(:Clock), "Clock attributes", required: true)
    response(201, "Clock created", Schema.ref(:Clock))
  end

  swagger_path :show do
    get("/api/clocks/{userId}")
    summary("List clocks")
    description("List all clocks")
    parameter(:userId, :path, :string, "User ID", required: true)
    response(200, "OK", Schema.ref(:Clock))
  end

  swagger_path :update do
    put("/api/clocks/{id}")
    summary("Update a clock")
    description("Update a clock")
    parameter(:id, :path, :string, "Clock ID", required: true)
    parameter(:clock, :body, Schema.ref(:Clock), "Clock attributes", required: true)
    response(200, "OK", Schema.ref(:Clock))
  end

  def index(conn, _params) do
    clocks = Time.list_clocks()
    render(conn, "index.json", clocks: clocks)
  end

  def create(conn, %{"userID" => user_id}) do
    clock_params = %{
      "user" => user_id,
      "time" => DateTime.utc_now(),
      "status" => true
    }

    clocks = Repo.all(from(c in Clock, where: c.user == ^user_id))

    if length(clocks) > 0 do
      conn
      |> put_status(:unprocessable_entity)
      |> render("error.json", error: "Clock already exists for this user")
    else
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
  end

  def show(conn, %{"userID" => user_id}) do
    clocks = Time.get_user_clocks(user_id)
    render(conn, "index.json", clocks: clocks)
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
