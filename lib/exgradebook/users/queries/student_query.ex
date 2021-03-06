defmodule Exgradebook.Users.Query.StudentQuery do
  defmacro __using__(_opts) do
    quote do
      import Ecto.Query
      import Ecto.Changeset
      alias Exgradebook.Curriculum
      alias Exgradebook.Repo
      alias Exgradebook.Users.Student

      def list_students(queryable \\ Student) do
        Repo.all(queryable)
      end

      def list_students_not_in_course(course_id) do
        Student
        |> where([s], not s.id in fragment(
          "SELECT enrollments.student_id FROM enrollments WHERE enrollments.course_id = ?", type(^course_id, :binary_id)
        ))
        |> list_students
      end

      def get_student!(id), do: Repo.get!(Student, id)

      def create_student(attrs \\ %{}) do
        %Student{}
        |> prepare_student(attrs)
        |> put_unique_email()
        |> Student.registration_changeset(attrs)
        |> Repo.insert()
      end

      def update_student(%Student{} = student, attrs) do
        student
        |> Student.changeset(attrs)
        |> Repo.update()
      end

      def delete_student(%Student{} = student) do
        student = student |> Repo.preload(:courses)
        case Repo.delete(student) do
          {:ok, deleted_student} ->
            student
            |> Map.get(:courses)
            |> Enum.each(&Curriculum.increment_enrollments_count(&1, -1))

            {:ok, deleted_student}
          error -> error
        end
      end

      def prepare_student(%Student{} = student, attrs \\ %{}) do
        Student.changeset(student, attrs)
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

    end
  end
end
