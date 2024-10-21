defmodule AppWeb.Router do
  use AppWeb, :router
  use PhoenixSwagger

  alias App.Repo
  alias App.Clock

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug AppWeb.Guardian.AuthPipeline
  end

  pipeline :manager do
    plug AppWeb.RolePipeline, ["manager", "admin"]
  end

  pipeline :admin do
    plug AppWeb.RolePipeline, ["admin"]
  end

  # Routes for login and register
  scope "/api", AppWeb do
    pipe_through :api

    # Users
    post "/register", UserController, :create

    # Auth
    post "/auth/login", AuthController, :login
  end

  # Routes for admin
  scope "/api", AppWeb do
    pipe_through [:api, :auth, :admin]

    # Clocks
    resources "/clocks", ClockController, only: [:delete]
  end

  # Routes for managers and admin
  scope "/api", AppWeb do
    pipe_through [:api, :auth, :manager]

    # Users
    resources "/users", UserController, only: [:create, :update, :delete]

    # WorkingTime
    resources "/workingtime", WorkingTimeController, only: [:create, :update, :delete]
    post "/workingtime/:userID", WorkingTimeController, :create

    # Teams
    resources "/teams", TeamController, only: [:create, :update, :delete]

  end

  # Routes for users
  scope "/api", AppWeb do
    pipe_through [:api, :auth]

    # Users
    resources "/users", UserController, only: [:index, :show]

    # WorkingTime
    resources "/workingtime", WorkingTimeController, only: [:index]
    get "/workingtime/:userID", WorkingTimeController, :show
    get "/workingtime/:userID/:id", WorkingTimeController, :show_by_user_and_id

    # Clocks
    resources "/clocks", ClockController, only: [:index, :update]
    post "/clocks/:userID", ClockController, :create
    get "/clocks/:userID", ClockController, :show
    put "/clocks/:id", ClockController, :update

    # Teams
    resources "/teams", TeamController, only: [:index, :show]
  end

  scope "/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI,
      otp_app: :app,
      swagger_file: "swagger.json"
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: AppWeb.Telemetry
    end
  end

  def swagger_info do
    %{
      schemes: ["http"],
      info: %{
        title: "Time management private API",
        version: "0.1.0",
        description: "This is a private API for Epitech students to manage their time"
      },
      definitions: AppWeb.SwaggerSchema.swagger_definitions()
    }
  end
end
