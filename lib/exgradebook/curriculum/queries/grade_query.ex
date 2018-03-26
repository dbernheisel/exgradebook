defmodule Exgradebook.Curriculum.Query.GradeQuery do
  defmacro __using__(_opts) do
    quote do
      alias Exgradebook.Repo
      alias Exgradebook.Curriculum.Grade
      alias Exgradebook.Curriculum.StudentCourseSummary
      import Ecto.Query

      def points_earned_for_student_in_course(student_id, course_id) do
        Grade
        |> where([g], g.student_id == ^student_id)
        |> join(:inner, [g], a in assoc(g, :assignment))
        |> where([..., a], a.course_id == ^course_id)
        |> select([g], g.value)
        |> Repo.aggregate(:sum, :value)
      end

      def points_earned_for_course(course_id) do
        Grade
        |> join(:inner, [g], a in assoc(g, :assignment))
        |> where([..., a], a.course_id == ^course_id)
        |> select([g], g.value)
        |> Repo.aggregate(:sum, :value)
      end

      def points_earned_for_semester(student, semester) do
        StudentCourseSummary
        |> where([s], s.student_id == ^student.id)
        |> where([s], s.semester_id == ^semester.id)
        |> select([s], s.grade_sum)
        |> Repo.aggregate(:sum, :grade_sum)
      end

      def gpa_for_student_in_semester(student, semester) do
        grade_sum = points_earned_for_semester(student, semester)
        assignment_sum = points_total_for_semester(student, semester)
        grade_sum / assignment_sum
      end
    end
  end
end
