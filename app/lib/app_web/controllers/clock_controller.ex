defmodule AppWeb.ClockController do
  use AppWeb, :controller
  use PhoenixSwagger

  alias ElixirLS.LanguageServer.Plugins.Phoenix
  alias App.Time
  alias App.Repo
  alias App.Time.Clock

  action_fallback AppWeb.FallbackController

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

  # TODO : add swagger_path for each action


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
