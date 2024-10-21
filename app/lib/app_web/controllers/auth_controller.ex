defmodule AppWeb.AuthController do
  use AppWeb, :controller
  use PhoenixSwagger

  alias App.Accounts
  alias App.Accounts.User

  def swagger_info do
    %{
      tags: ["Auth"],
      description: "Auth management",
      produces: ["application/json"],
      consumes: ["application/json"]
    }
  end

  swagger_path :login do
    post("/api/auth/login")
    summary("Login")
    description("Login user")
    parameter(:Auth, :body, Schema.ref(:Auth), "User attributes", required: true)
    response(200, "OK", Schema.ref(:AuthResponse))
    response(401, "Unauthorized", Schema.ref(:ErrorResponse))
  end

  def login(conn, %{"email" => email, "password" => password}) do
    case Accounts.get_user_by_email(email) do
      nil ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid credentials"})

      user ->
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

  def register(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, {:ok, %User{} = user}} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.user_path(conn, :show, user))
        |> render(AppWeb.UserView, "show.json", user: user)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(AppWeb.UserView, "error.json", changeset: changeset)
    end
  end
end
