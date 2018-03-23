defmodule Exgradebook.Users.StaffTest do
  use Exgradebook.DataCase
  alias Exgradebook.Users
  alias Exgradebook.Users.Staff

  describe "list_staff" do
    test "returns all staff" do
      staff = insert(:teacher)
      assert Users.list_staff() == [staff]
    end
  end

  describe "get_staff!/1" do
    test "returns the staff with given id" do
      staff = insert(:teacher)

      assert Users.get_staff!(staff.id) == staff
    end
  end

  describe "create_staff/1" do
    test "with valid data creates a staff" do
      params = params_for(:teacher) |> without_secrets

      assert {:ok, %Staff{}} = Users.create_staff(params)
      assert Repo.get_by(Staff, params)
    end

    test "with invalid data returns error changeset" do
      params = params_for(:teacher, last_name: nil) |> without_secrets

      assert {:error, %Ecto.Changeset{}} = Users.create_staff(params)
    end
  end

  describe "update_staff" do
    test "with valid data updates the staff" do
      staff = insert(:teacher)
      params = params_for(:teacher) |> without_secrets

      assert {:ok, %Staff{}} = Users.update_staff(staff, params)
      assert Repo.get_by(Staff, Map.put(params, :id, staff.id))
    end

    test "with invalid data returns error changeset" do
      staff = insert(:teacher)
      params = params_for(:teacher, role: "invalid role") |> without_secrets

      assert {:error, %Ecto.Changeset{}} = Users.update_staff(staff, params)
    end
  end

  describe "delete_staff" do
    test "deletes the staff" do
      staff = insert(:teacher)

      assert {:ok, %Staff{}} = Users.delete_staff(staff)
      assert_raise Ecto.NoResultsError, fn -> Users.get_staff!(staff.id) end
    end
  end

  describe "prepare_staff" do
    test "returns a staff changeset" do
      staff = build(:teacher)

      assert %Ecto.Changeset{} = Users.prepare_staff(staff)
    end
  end

  defp without_secrets(params) do
    params
    |> Map.delete(:password)
    |> Map.delete(:hashed_password)
    |> Map.delete(:session_secret)
  end
end
