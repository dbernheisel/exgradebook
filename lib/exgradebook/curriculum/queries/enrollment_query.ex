defmodule Exgradebook.Curriculum.Query.EnrollmentQuery do
  defmacro __using__(_opts) do
    quote do
      import Ecto.Query
      alias Exgradebook.Repo
      alias Exgradebook.Curriculum.Enrollment
      alias Exgradebook.Curriculum.Course

      def enroll(%{student_id: student_id, course_id: course_id}) do
        %Enrollment{}
        |> Enrollment.changeset(%{
          student_id: student_id,
          course_id: course_id
        })
        |> Repo.insert
        |> case do
          {:ok, enrollment} ->
            increment_enrollments_count(enrollment.course_id)
            {:ok, enrollment}

          error ->
            error
        end
      end

      def unenroll(enrollment_id) do
        enrollment = get_enrollment!(enrollment_id)

        case Repo.delete(enrollment) do
          {:ok, _enrollment} ->
            increment_enrollments_count(enrollment.course_id, -1)
            {:ok, enrollment}

          error ->
            error
        end
      end

      def get_enrollment!(enrollment_id) do
        Repo.get!(Enrollment, enrollment_id)
      end

      def list_enrollments_for_student(student_id) do
        Enrollment
        |> where([e, ...], e.student_id == ^student_id)
        |> Repo.all
        |> Repo.preload([course: [:teacher, :semester]])
      end

      def list_enrollments_for_course(course_id) do
        Enrollment
        |> join(:inner, [e], s in assoc(e, :student))
        |> where([e, ...], e.course_id == ^course_id)
        |> Repo.all
        |> Repo.preload(:student)
      end

      def increment_enrollments_count(course_id, count \\ 1) do
        Course
        |> where([c], c.id == ^course_id)
        |> Repo.update_all(inc: [enrollments_count: count])
      end
    end
  end
end
