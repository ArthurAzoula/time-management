defmodule App.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias App.Repo

  alias App.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    Repo.transaction(fn ->
      with {:ok, %User{} = user} <-
             %User{}
             |> User.changeset(attrs)
             |> Repo.insert(),
           {:ok, %App.Time.Clock{} = clock} <- create_clock_for_user(user) do
        {:ok, user}
      else
        {:error, _reason} = error -> Repo.rollback(error)
      end
    end)
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.transaction(fn ->
      from(c in App.Time.Clock, where: c.user == ^user.id)
      |> Repo.delete_all()

      from(wt in App.Time.WorkingTime, where: wt.user == ^user.id)
      |> Repo.delete_all()

      Repo.delete(user)
    end)
    |> case do
      {:ok, {:ok, user}} -> {:ok, user}
      {:ok, _} -> {:error, :unexpected_result}
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  @doc """
  Return the user with params.

  ## Examples

      iex> get_user(%{field: value})
      %User{}
  """
  def list_users(params \\ %{}) do
    User
    |> filter_by_params(params)
    |> Repo.all()
  end

  defp filter_by_params(query, params) do
    query
    |> filter_by_email(Map.get(params, "email"))
    |> filter_by_username(Map.get(params, "username"))
  end

  defp filter_by_email(query, nil), do: query

  defp filter_by_email(query, email) do
    from u in query, where: ilike(u.email, ^"%#{email}%")
  end

  defp filter_by_username(query, nil), do: query

  defp filter_by_username(query, username) do
    from u in query, where: ilike(u.username, ^"%#{username}%")
  end

  defp create_clock_for_user(%User{id: user_id} = user) do
    # Vérifier s'il existe déjà un clock associé à cet utilisateur
    case Repo.get_by(App.Time.Clock, user: user_id) do
      nil ->
        %App.Time.Clock{}
        |> App.Time.Clock.changeset(%{user: user_id, time: NaiveDateTime.utc_now(), status: true})
        |> Repo.insert()

      _clock ->
        {:error, :clock_already_exists}
    end
  end
end
