defmodule Exgradebook.Curriculum.Query.CourseQuery do
  defmacro __using__(_opts) do
    quote do
      import Ecto.Query
      alias Exgradebook.Repo
      alias Exgradebook.Curriculum.Course
      alias Exgradebook.Users.Student
      alias Exgradebook.Users.Staff

      def search_courses(queryable \\ Course, params) do
        queryable
        |> where_semester_id(params["semester_id"])
        |> where_teacher_id(params["teacher_id"])
        |> list_courses
      end
      def list_courses(queryable \\ Course) do
        queryable
        |> Repo.all
        |> Repo.preload(course_preloads())
      end

      defp where_semester_id(queryable, ""), do: queryable
      defp where_semester_id(queryable, semester_id) do
        queryable
        |> where([q], q.semester_id == ^semester_id)
      end
      defp where_teacher_id(queryable, ""), do: queryable
      defp where_teacher_id(queryable, teacher_id) do
        queryable
        |> where([q], q.teacher_id == ^teacher_id)
      end

      def list_courses_for_user(%Student{} = student) do
        Course
        |> scope_courses_to_user(student)
        |> order_by([..., e], asc: e.inserted_at)
        |> list_courses
      end
      def list_courses_for_user(%Staff{} = staff) do
        Course
        |> scope_courses_to_user(staff)
        |> order_by(:inserted_at)
        |> list_courses
      end

      def get_course!(id, opts \\ []) do
        Course
        |> scope_courses_to_user(Keyword.get(opts, :user))
        |> where([c], c.id == ^id)
        |> Repo.one!
        |> Repo.preload(course_preloads())
      end

      defp scope_courses_to_user(query, %Student{id: student_id}) do
        query
        |> join(:inner, [c], e in assoc(c, :enrollments))
        |> where([c, e], e.student_id == ^student_id)
      end
      defp scope_courses_to_user(query, %Staff{id: staff_id}) do
        query
        |> where([c], c.teacher_id == ^staff_id)
      end
      defp scope_courses_to_user(query, nil), do: query

      def update_course(%Course{} = course, attrs) do
        course
        |> Course.changeset(attrs)
        |> Repo.update()
      end

      def delete_course(%Course{} = course) do
        Repo.delete(course)
      end

      def create_course(attrs \\ %{}) do
        %Course{}
        |> Course.changeset(attrs)
        |> Repo.insert()
      end

      defp course_preloads do
        [:semester, :teacher]
      end

      def prepare_course(%Course{} = course, attrs \\ %{}) do
        Course.changeset(course, attrs)
      end
    end
  end
end
