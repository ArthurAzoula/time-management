defmodule AppWeb.SwaggerSchema do
  use PhoenixSwagger

  def swagger_definitions do
    %{
      User:
        swagger_schema do
          title("User")
          description("A user of the application")

          properties do
            username(:string, "User name")
            email(:string, "User email")
          end

          example(%{
            username: "John Doe",
            email: "john.doe@example.com"
          })
        end,
      Clock:
        swagger_schema do
          title("Clock")
          description("A clock for the user")

          properties do
            time(:nativedatetime, "Time")
            status(:boolean, "Status")
          end

          example(%{
            time: "2020-01-01T00:00:00Z",
            status: false
          })
        end,
      WorkingTime:
        swagger_schema do
          title("WorkingTime")
          description("A working time for the user")

          properties do
            start_time(:nativedatetime, "Start time")
            end_time(:nativedatetime, "End time")
          end

          example(%{
            start_time: "2020-01-01T00:00:00Z",
            end_time: "2020-01-01T08:00:00Z"
          })
      end,
      Team:
        swagger_schema do
          title("Team")
          description("A team to represent manager with team members")

          properties do
            name(:string, "Team name")
            manager(:string, "Manager ID")
          end

          example(%{
            name: "TEAM-012",
            manager: "12"
          })
        end,
      Auth:
        swagger_schema do
          title("Auth")
          description("Auth management")

          properties do
            email(:string, "User email")
            password(:string, "User password")
          end

          example(%{
            email: "mail@mail.fr",
            password: "password"
          })
        end,
      AuthResponse:
        swagger_schema do
          title("AuthResponse")
          description("Response for successful authentication")

          properties do
            token(:string, "JWT token")
          end

          example(%{
            token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
          })
        end,
      ErrorResponse:
        swagger_schema do
          title("ErrorResponse")
          description("Response for errors")

          properties do
            error(:string, "Error message")
          end

          example(%{
            error: "Invalid credentials"
          })
        end
    }
  end
end
