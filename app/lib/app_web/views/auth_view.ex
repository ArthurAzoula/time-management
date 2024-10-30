defmodule AppWeb.AuthView do
  use AppWeb, :view

  def render("show.json", %{user: user}) do
    %{data: render_one(user, AppWeb.AuthView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      username: user.username,
      email: user.email,
      role: user.role
    }
  end

  def render("error.json", %{changeset: changeset}) do
    %{errors: translate_errors(changeset)}
  end

  defp translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      AppWeb.ErrorHelpers.translate_error(msg, opts)
    end)
  end
end
