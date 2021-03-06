defmodule Exgradebook.Curriculum.Query.AssignmentQuery do
  defmacro __using__(_opts) do
    quote do
      import Ecto.Query
      alias Exgradebook.Repo
      alias Exgradebook.Curriculum.Assignment
      alias Exgradebook.Curriculum.StudentCourseSummary
      alias Exgradebook.Users.Student
      alias Exgradebook.Users.Staff

      def list_assignments(queryable \\ Assignment) do
        queryable
        |> Repo.all
        |> Repo.preload(:grades)
      end

      def list_assignments_for_course(course_id, opts \\ []) do
        Assignment
        |> scope_grades_to_user(Keyword.get(opts, :user))
        |> where([a], a.course_id == ^course_id)
        |> list_assignments
      end

      def points_possible_for_course(course_id) do
        Assignment
        |> where([a], a.course_id == ^course_id)
        |> select([a], a.value)
        |> Repo.aggregate(:sum, :value)
      end

      def points_total_for_semester(student, semester) do
        StudentCourseSummary
        |> where([s], s.student_id == ^student.id)
        |> where([s], s.semester_id == ^semester.id)
        |> select([s], s.assignment_sum)
        |> Repo.aggregate(:sum, :assignment_sum)
      end

      defp scope_grades_to_user(query, %Student{id: student_id}) do
        query
        |> join(:inner, [a], g in assoc(a, :grades))
        |> where([_a, g], g.student_id == ^student_id)
      end
      defp scope_grades_to_user(query, %Staff{id: staff_id}) do
        query
        |> join(:inner, [a], c in assoc(a, :course))
        |> where([_a, c], c.teacher_id == ^staff_id)
      end
      defp scope_grades_to_user(query, nil), do: query
    end
  end
end
