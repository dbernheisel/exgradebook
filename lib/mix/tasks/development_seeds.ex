defmodule Mix.Tasks.DevelopmentSeeds do
  use Mix.Task
  use Exgradebook.DevelopmentSeeds.Helper
  alias Ecto.Changeset

  @shortdoc "Insert the seeds for development"
  def run(_arguments) do
    Mix.Task.run("ecto.migrate", [])
    Mix.Task.run("app.start", [])

    UsefulOutput.start_link()

    for table_name <- tables_to_truncate() do
      Ecto.Adapters.SQL.query!(Repo, "TRUNCATE TABLE #{table_name} CASCADE")
    end

    admin = create_user(:admin, email: "admin@example.com", first_name: "Test", last_name: "Admin")
    UsefulOutput.add("Added staff #{admin.email}/password")


    teacher = create_user(:teacher, email: "teacher@example.com", first_name: "Test", last_name: "Teacher")
    UsefulOutput.add("Added staff #{teacher.email}/password")
    teachers = insert_list(20, :teacher)

    student = create_user(:student, email: "student@student.example.com", first_name: "Test", last_name: "Student")
    UsefulOutput.add("Added student #{student.email}/password")

    [semester_one, semester_two] =
      [Timex.today(), Timex.shift(Timex.today(), days: 92)]
      |> Enum.map(fn date ->
        case Timex.quarter(date) do
          1 -> {"Spring", date}
          2 -> {"Summer", date}
          3 -> {"Fall", date}
          4 -> {"Winter", date}
        end
      end)
      |> Enum.map(fn {name, date} ->
        insert(:semester, name: "#{name} #{date.year}")
      end)

    teachers
    |> Enum.flat_map(fn teacher ->
      [
        course_with_content(teacher, semester_one, Enum.random(5..20)),
        course_with_content(teacher, semester_two, Enum.random(5..20)),
        course_with_content(teacher, semester_two, Enum.random(5..20)),
      ]
    end)
    |> Enum.take_random(10)
    |> Enum.each(& insert(:enrollment, student: student, course: &1))

    UsefulOutput.print()
  end

  defp course_with_content(teacher, semester, number_of_students) do
    teacher
    |> course_with_students_for_teacher_and_semester(semester, number_of_students)
    |> add_assignments_and_grades_for_course
  end

  defp tables_to_truncate do
    ~w(
      assignments
      courses
      enrollments
      grades
      semesters
      staff
      students
    )
  end

  defp create_user(type, params) do
    type
    |> build(params)
    |> set_password("password")
    |> insert
  end

  def set_password(struct, password) do
    struct
    |> Changeset.cast(%{password: password}, [:password])
    |> Doorman.Auth.Bcrypt.hash_password()
    |> Changeset.apply_changes()
  end
end
