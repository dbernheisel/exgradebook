defmodule Exgradebook.Users.StudentTest do
  use Exgradebook.DataCase, async: true
  alias Exgradebook.Users
  alias Exgradebook.Users.Student

  describe "changeset" do
    test "requires fields" do
      params = params_for(
        :student,
        first_name: nil,
        last_name: nil
      )

      changeset = Student.changeset(%Student{}, params)

      assert changeset.errors[:first_name]
      assert changeset.errors[:last_name]
    end

    test "requires email to be unique" do
      existing_user = insert(:student, email: "test@example.com")
      params = params_for(:student, email: existing_user.email)

      {:error, changeset} =
        %Student{}
        |> Student.changeset(params)
        |> Repo.insert

      assert {"has already been taken", _} = changeset.errors[:email]
    end
  end

  describe "registration_changeset" do
    test "hashes the provided password and inserts session secret" do
      params = params_for(:student, password: "secret")

      changeset = Student.registration_changeset(%Student{}, params)

      assert changeset.changes[:hashed_password]
      assert changeset.changes[:session_secret]
    end

    test "requires a password" do
      invalid_params = params_for(:student, password: nil)

      changeset = Student.registration_changeset(%Student{}, invalid_params)

      assert changeset.errors[:password]
    end
  end

  describe "list_students_not_in_course" do
    test "returns all students not in course" do
      course = insert(:course)
      enrolled_student = insert(:student)
      insert(:enrollment, student: enrolled_student, course: course)
      expected_student = insert(:student)

      [student] = Users.list_students_not_in_course(course.id)

      assert student.id == expected_student.id
    end
  end

  describe "get_student!/1" do
    test "returns the student with given id" do
      student = insert(:student)

      assert Users.get_student!(student.id) == student
    end
  end

  describe "create_student/1" do
    test "with valid data creates a student" do
      params = params_for(:student) |> for_registration

      assert {:ok, %Student{}} = Users.create_student(params)
      assert Repo.get_by(Student, params |> without_secrets)
    end

    test "generates a unique email" do
      params = params_for(
        :student,
        first_name: "David",
        last_name: "Bernheisel",
        email: nil
      ) |> for_registration

      assert {:ok, %Student{} = student} = Users.create_student(params)
      assert Repo.get_by(Student, params |> without_secrets)
      assert student.email == "dbernheisel@student.example.com"
    end

    test "when email already exists, appends number to email" do
      insert(:student, email: "dbernheisel@student.example.com")
      params = params_for(
        :student,
        first_name: "David",
        last_name: "Bernheisel",
        email: nil
      ) |> for_registration

      assert {:ok, %Student{} = student} = Users.create_student(params)
      assert Repo.get_by(Student, params |> without_secrets)
      assert student.email == "dbernheisel1@student.example.com"
    end

    test "when funky last name, only allows alpha-numeric characters in email" do
      params = params_for(
        :student,
        first_name: "David",
        last_name: "O'Reilly van der d0rk",
        email: nil
      ) |> for_registration

      assert {:ok, %Student{} = student} = Users.create_student(params)
      assert Repo.get_by(Student, params |> without_secrets)
      assert student.email == "doreillyvanderd0rk@student.example.com"
    end

    test "with invalid data returns error changeset" do
      params = params_for(:student, last_name: nil) |> for_registration

      assert {:error, %Ecto.Changeset{}} = Users.create_student(params)
    end
  end

  describe "update_student" do
    test "with valid data updates the student" do
      student = insert(:student)
      params = params_for(:student) |> without_secrets

      assert {:ok, %Student{}} = Users.update_student(student, params)
      assert Repo.get_by(Student, Map.put(params, :id, student.id))
    end

    test "with invalid data returns error changeset" do
      existing_student = insert(:student, email: "existing@example.com")
      student = insert(:student)
      params = params_for(:student, email: existing_student.email) |> without_secrets

      assert {:error, %Ecto.Changeset{}} = Users.update_student(student, params)
    end
  end

  describe "delete_student" do
    test "deletes the student" do
      student = insert(:student)

      assert {:ok, %Student{}} = Users.delete_student(student)
      assert_raise Ecto.NoResultsError, fn -> Users.get_student!(student.id) end
    end
  end

  describe "prepare_student" do
    test "returns a student changeset" do
      student = build(:student)

      assert %Ecto.Changeset{} = Users.prepare_student(student)
    end
  end

  defp without_secrets(params) do
    params
    |> Map.delete(:password)
    |> Map.delete(:hashed_password)
    |> Map.delete(:session_secret)
  end
end
