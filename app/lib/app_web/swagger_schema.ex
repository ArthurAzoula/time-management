# lib/app_web/swagger_schema.ex
defmodule AppWeb.SwaggerSchema do
  use PhoenixSwagger

  def swagger_definitions do
    %{
      User: swagger_schema do
        title "User"
        description "A user of the application"
        properties do
          username :string, "User name"
          email :string, "User email"
        end
        example %{
          id: 1,
          username: "John Doe",
          email: "john.doe@example.com",
        }
      end,

      Clock: swagger_schema do
        title "Clock"
        description "A clock for the user"
        properties do
          time :nativedatetime, "Time"
          status :boolean, "Status"
        end
        example %{
          time: "2020-01-01T00:00:00Z",
          status: false,
        }
      end,

      WorkingTime: swagger_schema do
        title "WorkingTime"
        description "A working time for the user"
        properties do
          start_time :nativedatetime, "Start time"
          end_time :nativedatetime, "End time"
        end
        example %{
          start_time: "2020-01-01T00:00:00Z",
          end_time: "2020-01-01T08:00:00Z",
        }
      end
    }
  end
end
