defmodule AppWeb.TeamController do
  use AppWeb, :controller
  use PhoenixSwagger

  alias ElixirLS.LanguageServer.Plugins.Phoenix
  alias App.Accounts
  alias App.Accounts.Team

  action_fallback AppWeb.FallbackController

  def swagger_info do
    %{
      tags: ["Team"],
      description: "Team management",
      produces: ["application/json"],
      consumes: ["application/json"],
      parameters: [
        %{
          name: "id",
          in: "path",
          description: "Team ID",
          required: true,
          type: :string
        },
        %{
          name: "team",
          in: "body",
          description: "Team attributes",
          required: true,
          schema: %{
            type: :object,
            properties: %{
              name: %{type: :string},
              manager: %{type: :integer}
            }
          }
        }
      ],
      responses: %{
        "200": %{
          description: "Team found",
          schema: %{
            type: :object,
            properties: %{
              name: %{type: :string},
              manager: %{type: :integer}
            }
          }
        },
        "201": %{
          description: "Team created",
          schema: %{
            type: :object,
            properties: %{
              name: %{type: :string},
              manager: %{type: :integer}
            }
          }
        },
        "204": %{
          description: "Team deleted"
        }
      }
    }
  end

  swagger_path :index do
    get("/api/teams")
    summary("List teams")
    description("List all teams")
    response(200, "OK", Schema.ref(:Team))
  end

  swagger_path :create do
    post("/api/teams")
    summary("Create a team")
    description("Create a team with a manager")
    parameter(:team, :body, Schema.ref(:Team), "Team attributes", required: true)
    response(201, "Team created", Schema.ref(:Team))
  end

  swagger_path :show do
    get("/api/teams/{id}")
    summary("Show a team")
    description("Show a team by ID")
    parameter(:id, :path, :string, "Team ID", required: true)
    response(200, "OK", Schema.ref(:Team))
  end

  swagger_path :update do
    put("/api/teams/{id}")
    summary("Update a team")
    description("Update a team by ID")
    parameter(:id, :path, :string, "Team ID", required: true)
    parameter(:team, :body, Schema.ref(:Team), "Team attributes", required: true)
    response(200, "OK", Schema.ref(:Team))
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete("/api/teams/{id}")
    summary("Delete a team")
    description("Delete a team by ID")
    parameter(:id, :path, :string, "Team ID", required: true)
    response(204, "Team deleted")
  end

  def index(conn, _params) do
    teams = Accounts.list_teams()
    render(conn, "index.json", teams: teams)
  end

  def create(conn, %{"team" => team_params}) do
    with {:ok, %Team{} = team} <- Accounts.create_team(team_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.team_path(conn, :show, team))
      |> render("show.json", team: team)
    end
  end

  def show(conn, %{"id" => id}) do
    team = Accounts.get_team!(id)
    render(conn, "show.json", team: team)
  end

  def update(conn, %{"id" => id, "team" => team_params}) do
    team = Accounts.get_team!(id)

    with {:ok, %Team{} = team} <- Accounts.update_team(team, team_params) do
      render(conn, "show.json", team: team)
    end
  end

  def delete(conn, %{"id" => id}) do
    team = Accounts.get_team!(id)

    with {:ok, %Team{}} <- Accounts.delete_team(team) do
      send_resp(conn, :no_content, "")
    end
  end
end
