defmodule AppWeb.UserController do
  use AppWeb, :controller
  use PhoenixSwagger

  alias App.Accounts
  alias App.Accounts.User

  action_fallback(AppWeb.FallbackController)

  def swagger_info do
    %{
      tags: ["User"],
      description: "User management",
      produces: ["application/json"],
      consumes: ["application/json"],
      parameters: [
        %{
          name: "id",
          in: "path",
          description: "User ID",
          required: true,
          type: :string
        },
        %{
          name: "user",
          in: "body",
          description: "User attributes",
          required: true,
          schema: %{
            type: :object,
            properties: %{
              username: %{type: :string},
              email: %{type: :string}
            }
          }
        }
      ],
      responses: %{
        "200": %{
          description: "User found",
          schema: %{
            type: :object,
            properties: %{
              username: %{type: :string},
              email: %{type: :string}
            }
          }
        },
        "201": %{
          description: "User created",
          schema: %{
            type: :object,
            properties: %{
              username: %{type: :string},
              email: %{type: :string}
            }
          }
        },
        "204": %{
          description: "User deleted"
        }
      }
    }
  end

  swagger_path :index do
    get("/api/users")
    summary("List users")
    description("List all users")
    parameter(:email, :query, :string, "Filter by email", required: false)
    parameter(:username, :query, :string, "Filter by username", required: false)
    response(200, "OK", Schema.ref(:User))
  end

  swagger_path :create do
    post("/api/users")
    summary("Create user")
    description("Create a new user")
    parameter(:user, :body, Schema.ref(:User), "User attributes", required: true)
    response(201, "Created", Schema.ref(:User))
  end

  swagger_path :show do
    get("/api/users/{id}")
    summary("Show user")
    description("Show a user by ID")
    parameter(:id, :path, :string, "User ID", required: true)
    response(200, "OK", Schema.ref(:User))
  end

  swagger_path :update do
    put("/api/users/{id}")
    summary("Update user")
    description("Update a user by ID")
    parameter(:id, :path, :string, "User ID", required: true)
    parameter(:user, :body, Schema.ref(:User), "User attributes", required: true)
    response(200, "OK", Schema.ref(:User))
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete("/api/users/{id}")
    summary("Delete a user")
    description("Delete a user by ID")
    parameter(:id, :path, :string, "User ID", required: true, example: 3)
    response(204, "No Content (User deleted)")
  end

  def index(conn, params) do
    users = Accounts.list_users(params)
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, {:ok, %User{} = user}} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.user_path(conn, :show, user))
        |> render("show.json", user: user)

      {:error, _reason} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", error: "Unable to create user or clock")
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  def login(conn, %{"email" => email, "password" => password}) do
    case Accounts.get_user_by_email(email) do
      nil ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid credentials"})

      user ->
        IO.inspect(user)
        if Bcrypt.verify_pass(password, user.password_hash) do
          {:ok, token, _claims} = AppWeb.Guardian.encode_and_sign(user, %{id: user.id, role: user.role})
          conn
          |> put_status(:ok)
          |> json(%{token: token})
        else
          conn
          |> put_status(:unauthorized)
          |> json(%{error: "Invalid credentials"})
        end
    end
  end

end
