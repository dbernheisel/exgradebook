defmodule Exgradebook.Users.StaffTest do
  use Exgradebook.DataCase, async: true
  alias Exgradebook.Users
  alias Exgradebook.Users.Staff

  describe "changeset" do
    test "requires fields" do
      params = params_for(
        :teacher,
        email: nil,
        first_name: nil,
        last_name: nil
      )

      changeset = Staff.changeset(%Staff{}, params)

      assert changeset.errors[:email]
      assert changeset.errors[:first_name]
      assert changeset.errors[:last_name]
    end

    test "requires role to be valid" do
      params = params_for(
        :teacher,
        role: "not valid"
      )

      changeset = Staff.changeset(%Staff{}, params)

      assert changeset.errors[:role]
    end

    test "requires email to be unique" do
      existing_user = insert(:staff, email: "test@example.com")
      params = params_for(:teacher, email: existing_user.email)

      {:error, changeset} =
        %Staff{}
        |> Staff.changeset(params)
        |> Repo.insert

      assert changeset.errors[:email]
    end
  end

  describe "registration_changeset" do
    test "hashes the provided password and inserts session secret" do
      params = params_for(:teacher, password: "secret")

      changeset = Staff.registration_changeset(%Staff{}, params)

      assert changeset.changes[:hashed_password]
      assert changeset.changes[:session_secret]
    end

    test "requires a password" do
      invalid_params = params_for(:teacher, password: nil)

      changeset = Staff.registration_changeset(%Staff{}, invalid_params)

      assert changeset.errors[:password]
    end
  end

  describe "list_staff" do
    test "returns all staff" do
      Users.list_staff()
      staff = insert(:teacher)

      [result] = Users.list_staff()

      assert result.id == staff.id
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
      params = params_for(:teacher) |> for_registration

      assert {:ok, %Staff{}} = Users.create_staff(params)
      assert Repo.get_by(Staff, params |> without_secrets)
    end

    test "with invalid data returns error changeset" do
      params = params_for(:teacher, last_name: nil) |> for_registration

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
