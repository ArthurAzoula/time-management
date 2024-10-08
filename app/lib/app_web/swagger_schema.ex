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
      end
    }
  end
end
