defmodule App.Accounts do

  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias App.Repo
  alias App.Accounts.User
  alias App.Accounts.Team
  alias App.Accounts.UsersTeams
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
      with {:ok, %User{} = user} <- %User{}
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

      Ecto.Adapters.SQL.query!(Repo, "DELETE FROM clocks c WHERE c.user = $1", [user.id])

      Ecto.Adapters.SQL.query!(Repo, "DELETE FROM workingtime wt WHERE wt.user = $1", [user.id])

      Ecto.Adapters.SQL.query!(Repo, "DELETE FROM users_teams WHERE user_id = $1", [user.id])

      case Repo.delete(user) do
        {:ok, _} -> {:ok, user}
        {:error, reason} -> Repo.rollback(reason)
      end
    end)
    |> case do
      {:ok, {:ok, user}} -> {:ok, user}
      {:ok, _} -> {:error, :unexpected_result}
      {:error, reason} -> {:error, reason}
    end
  end

  # Get user by email
  def get_user_by_email(email) do
    Repo.get_by(User, email: email)
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


  alias App.Accounts.Team

  @doc """
  Returns the list of teams.

  ## Examples

      iex> list_teams()
      [%Team{}, ...]

  """
  def list_teams do
    Repo.all(Team)
  end


  def get_users_by_manager_id(manager_id) do
    from(t in Team,
      join: ut in UsersTeams, on: t.id == ut.team_id,
      join: u in User, on: ut.user_id == u.id,
      where: t.manager_id == ^manager_id,
      order_by: [t.id, u.username],
      select: %{
        team_id: t.id,
        team_name: t.name,
        user_id: u.id,
        username: u.username,
        email: u.email
      }
    )
    |> Repo.all()
    |> Enum.group_by(& &1.team_id, fn member ->
      %{
        user_id: member.user_id,
        username: member.username,
        email: member.email,
        team_name: member.team_name  
      }
    end)
  end



  @doc """
  Gets a single team.

  Raises `Ecto.NoResultsError` if the Team does not exist.

  ## Examples

      iex> get_team!(123)
      %Team{}

      iex> get_team!(456)
      ** (Ecto.NoResultsError)

  """
  def get_team!(id), do: Repo.get!(Team, id)



  @doc """
  Creates a team.

  ## Examples

      iex> create_team(%{field: value})
      {:ok, %Team{}}

      iex> create_team(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_team(attrs \\ %{}) do
    %Team{}
    |> Team.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a team.

  ## Examples

      iex> update_team(team, %{field: new_value})
      {:ok, %Team{}}

      iex> update_team(team, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_team(%Team{} = team, attrs) do
    team
    |> Team.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a team.

  ## Examples

      iex> delete_team(team)
      {:ok, %Team{}}

      iex> delete_team(team)
      {:error, %Ecto.Changeset{}}

  """
  def delete_team(%Team{} = team) do
    Repo.delete(team)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking team changes.

  ## Examples

      iex> change_team(team)
      %Ecto.Changeset{data: %Team{}}

  """
  def change_team(%Team{} = team, attrs \\ %{}) do
    Team.changeset(team, attrs)
  end

  alias App.Accounts.UsersTeams

  @doc """
  Returns the list of users_teams.

  ## Examples

      iex> list_users_teams()
      [%UsersTeams{}, ...]

  """
  def list_users_teams do
    Repo.all(UsersTeams)
  end

  @doc """
  Gets a single users_teams.

  Raises `Ecto.NoResultsError` if the Users teams does not exist.

  ## Examples

      iex> get_users_teams!(123)
      %UsersTeams{}

      iex> get_users_teams!(456)
      ** (Ecto.NoResultsError)

  """
  def get_users_teams!(id), do: Repo.get!(UsersTeams, id)

  @doc """
  Creates a users_teams.

  ## Examples

      iex> create_users_teams(%{field: value})
      {:ok, %UsersTeams{}}

      iex> create_users_teams(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_users_teams(attrs \\ %{}) do
    %UsersTeams{}
    |> UsersTeams.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a users_teams.

  ## Examples

      iex> update_users_teams(users_teams, %{field: new_value})
      {:ok, %UsersTeams{}}

      iex> update_users_teams(users_teams, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_users_teams(%UsersTeams{} = users_teams, attrs) do
    users_teams
    |> UsersTeams.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a users_teams.

  ## Examples

      iex> delete_users_teams(users_teams)
      {:ok, %UsersTeams{}}

      iex> delete_users_teams(users_teams)
      {:error, %Ecto.Changeset{}}

  """
  def delete_users_teams(%UsersTeams{} = users_teams) do
    Repo.delete(users_teams)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking users_teams changes.

  ## Examples

      iex> change_users_teams(users_teams)
      %Ecto.Changeset{data: %UsersTeams{}}

  """
  def change_users_teams(%UsersTeams{} = users_teams, attrs \\ %{}) do
    UsersTeams.changeset(users_teams, attrs)
  end
end
