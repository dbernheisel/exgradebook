defmodule Exgradebook.Curriculum.Query.GradeQuery do
  defmacro __using__(_opts) do
    quote do
      alias Exgradebook.Repo
      alias Exgradebook.Curriculum.Grade
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
    end
  end
end
