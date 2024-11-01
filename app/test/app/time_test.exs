defmodule App.TimeTest do
  use App.DataCase

  alias App.Time

  describe "clocks" do
    alias App.Time.Clock

    @valid_attrs %{status: true, time: ~N[2010-04-17 14:00:00], user: "1"}
    @update_attrs %{status: false, time: ~N[2011-05-18 15:01:01], user: "1"}
    @invalid_attrs %{status: nil, time: nil, user: nil}

    setup do
      # Clean de la db
      App.Repo.delete_all(App.Time.Clock)
      :ok
    end

    def clock_fixture(attrs \\ %{}) do
      {:ok, clock} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Time.create_clock()

      clock
    end

    @tag :skip
    test "list_clocks/0 returns all clocks" do
      clock = clock_fixture()
      assert Time.list_clocks() == [clock]
    end

    @tag :skip
    test "get_clock!/1 returns the clock with given id" do
      clock = clock_fixture()
      assert Time.get_clock!(clock.id) == clock
    end

    @tag :skip
    test "create_clock/1 with valid data creates a clock" do
      assert {:ok, %Clock{} = clock} = Time.create_clock(@valid_attrs)
      assert clock.status == true
      assert clock.time == ~N[2010-04-17 14:00:00]
    end

    @tag :skip
    test "create_clock/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Time.create_clock(@invalid_attrs)
    end

    @tag :skip
    test "update_clock/2 with valid data updates the clock" do
      clock = clock_fixture()
      assert {:ok, %Clock{} = clock} = Time.update_clock(clock, @update_attrs)
      assert clock.status == false
      assert clock.time == ~N[2011-05-18 15:01:01]
    end

    @tag :skip
    test "update_clock/2 with invalid data returns error changeset" do
      clock = clock_fixture()
      assert {:error, %Ecto.Changeset{}} = Time.update_clock(clock, @invalid_attrs)
      assert clock == Time.get_clock!(clock.id)
    end

    @tag :skip
    test "delete_clock/1 deletes the clock" do
      clock = clock_fixture()
      assert {:ok, %Clock{}} = Time.delete_clock(clock)
      assert_raise Ecto.NoResultsError, fn -> Time.get_clock!(clock.id) end
    end

    @tag :skip
    test "change_clock/1 returns a clock changeset" do
      clock = clock_fixture()
      assert %Ecto.Changeset{} = Time.change_clock(clock)
    end
  end

  describe "workingtime" do
    alias App.Time.WorkingTime

    @valid_attrs %{start: ~N[2010-04-17 14:00:00], end: ~N[2010-04-17 14:00:00], user: "1"}
    @update_attrs %{start: ~N[2011-05-18 15:01:01], end: ~N[2011-05-18 15:01:01], user: "1"}
    @invalid_attrs %{start: nil, end: nil, user: nil}

    setup do
      # Clean de la db
      App.Repo.delete_all(App.Time.WorkingTime)
      :ok
    end

    def working_time_fixture(attrs \\ %{}) do
      {:ok, working_time} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Time.create_working_time()

      working_time
    end

    @tag :skip
    test "list_workingtime/0 returns all workingtime" do
      working_time = working_time_fixture()
      assert Time.list_workingtime() == [working_time]
    end

    @tag :skip
    test "get_working_time!/1 returns the working_time with given id" do
      working_time = working_time_fixture()
      assert Time.get_working_time!(working_time.id) == working_time
    end

    @tag :skip
    test "create_working_time/1 with valid data creates a working_time" do
      assert {:ok, %WorkingTime{} = working_time} = Time.create_working_time(@valid_attrs)
      assert working_time.start == ~N[2010-04-17 14:00:00]
      assert working_time.end == ~N[2010-04-17 14:00:00]
    end

    test "create_working_time/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Time.create_working_time(@invalid_attrs)
    end

    @tag :skip
    test "update_working_time/2 with valid data updates the working_time" do
      working_time = working_time_fixture()
      assert {:ok, %WorkingTime{} = working_time} =
               Time.update_working_time(working_time, @update_attrs)
      assert working_time.start == ~N[2011-05-18 15:01:01]
      assert working_time.end == ~N[2011-05-18 15:01:01]
    end

    @tag :skip
    test "update_working_time/2 with invalid data returns error changeset" do
      working_time = working_time_fixture()
      assert {:error, %Ecto.Changeset{}} = Time.update_working_time(working_time, @invalid_attrs)
      assert working_time == Time.get_working_time!(working_time.id)
    end

    @tag :skip
    test "delete_working_time/1 deletes the working_time" do
      working_time = working_time_fixture()
      assert {:ok, %WorkingTime{}} = Time.delete_working_time(working_time)
      assert_raise Ecto.NoResultsError, fn -> Time.get_working_time!(working_time.id) end
    end

    @tag :skip
    test "change_working_time/1 returns a working_time changeset" do
      working_time = working_time_fixture()
      assert %Ecto.Changeset{} = Time.change_working_time(working_time)
    end
  end
end
