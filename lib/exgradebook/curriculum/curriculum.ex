defmodule Exgradebook.Curriculum do
  import Ecto.Query, warn: false
  alias Exgradebook.Repo
  alias Exgradebook.Curriculum.Enrollment
  alias Exgradebook.Curriculum.Course
  alias Exgradebook.Curriculum.Semester

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

  def list_enrollments_for_course(course_id) do
    Enrollment
    |> join(:inner, [e], s in assoc(e, :student))
    |> where([e, ...], e.course_id == ^course_id)
    |> Repo.all
    |> Repo.preload(:student)
  end

  def list_courses do
    Course
    |> Repo.all
    |> Repo.preload(course_preloads())
  end

  def get_course!(id) do
    Course
    |> Repo.get!(id)
    |> Repo.preload(course_preloads())
  end

  def update_course(%Course{} = course, attrs) do
    course
    |> Course.changeset(attrs)
    |> Repo.update()
  end

  def list_semesters do
    Repo.all(Semester)
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

  def increment_enrollments_count(course_id, count \\ 1) do
    Course
    |> where([c], c.id == ^course_id)
    |> Repo.update_all(inc: [enrollments_count: count])
  end
end
