defmodule Exgradebook.Users do
  import Ecto.Query
  import Ecto.Changeset
  alias Exgradebook.Repo
  alias Exgradebook.Users.Staff
  alias Exgradebook.Users.Student

  @moduledoc """
  The Users context.
  """

  def list_staff do
    Repo.all(Staff)
  end

  def list_students(queryable \\ Student) do
    Repo.all(queryable)
  end

  def list_students_for_course(course_id) do
    Student
    |> join(:inner, [s], e in assoc(s, :enrollments))
    |> where([s, e], e.course_id == ^course_id)
    |> list_students
  end

  def list_students_not_in_course(course_id) do
    Student
    |> where([s], not s.id in fragment(
      "SELECT enrollments.student_id FROM enrollments WHERE enrollments.course_id = ?", type(^course_id, :binary_id)
    ))
    |> list_students
  end

  def get_staff!(id), do: Repo.get!(Staff, id)

  def get_student!(id), do: Repo.get!(Student, id)

  def create_staff(attrs \\ %{}) do
    %Staff{}
    |> Staff.registration_changeset(attrs)
    |> Repo.insert()
  end

  def create_student(attrs \\ %{}) do
    %Student{}
    |> prepare_student(attrs)
    |> put_unique_email()
    |> Student.registration_changeset(attrs)
    |> Repo.insert()
  end

  defp put_unique_email(changeset) do
    case get_field(changeset, :email) do
      nil ->
        email =
          changeset
          |> generate_unique_email(domain: "student.example.com")
          |> String.downcase
        changeset
        |> put_change(:email, email)

      _email ->
        changeset
    end
  end

  defp generate_unique_email(changeset, [domain: domain], number \\ nil) do
    last_name = changeset |> get_field(:last_name) |> sanitize
    first_name_letter = changeset |> get_field(:first_name) |> sanitize |> String.first

    email = [
      first_name_letter,
      last_name,
      number,
      "@",
      domain,
    ]
    |> Enum.reject(&is_nil/1)
    |> Enum.join("")

    case Repo.get_by(Student, email: email) do
      nil ->
        email
      _existing_student ->
        changeset
        |> generate_unique_email([domain: domain], (number || 0) + 1)
    end
  end

  defp sanitize(string) do
    String.replace(string, ~r/[^a-zA-Z0-9]/, "")
  end

  def update_staff(%Staff{} = staff, attrs) do
    staff
    |> Staff.changeset(attrs)
    |> Repo.update()
  end

  def update_student(%Student{} = student, attrs) do
    student
    |> Student.changeset(attrs)
    |> Repo.update()
  end

  def delete_staff(%Staff{} = staff) do
    Repo.delete(staff)
  end

  def delete_student(%Student{} = student) do
    student = student |> Repo.preload(:courses)
    case Repo.delete(student) do
      {:ok, deleted_student} ->
        student
        |> Map.get(:courses)
        |> Enum.each(&decrement_enrollments_count/1)

        {:ok, deleted_student}
      error -> error
    end
  end

  defp decrement_enrollments_count(course) do
    Repo.update_all(course, inc: [enrollments_count: -1])
  end

  def prepare_staff(%Staff{} = staff, attrs \\ %{}) do
    Staff.changeset(staff, attrs)
  end

  def prepare_student(%Student{} = student, attrs \\ %{}) do
    Student.changeset(student, attrs)
  end
end
