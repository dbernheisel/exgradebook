defmodule Exgradebook.Curriculum do
  import Ecto.Query, warn: false
  alias Exgradebook.Repo
  alias Exgradebook.Curriculum.Enrollment
  alias Exgradebook.Curriculum.Course
  alias Exgradebook.Curriculum.Semester
  alias Exgradebook.Users.Student
  alias Exgradebook.Users.Staff

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

  def get_semester!(semester_id) do
    Repo.get!(Semester, semester_id)
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

  def list_courses_for_user(%Student{} = student) do
    Course
    |> scope_courses_to_user(student)
    |> order_by([..., e], asc: e.inserted_at)
    |> Repo.all
    |> Repo.preload(course_preloads())
  end
  def list_courses_for_user(%Staff{} = staff) do
    Course
    |> scope_courses_to_user(staff)
    |> order_by(:inserted_at)
    |> Repo.all
    |> Repo.preload(course_preloads())
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

  def update_semester(%Semester{} = semester, attrs) do
    semester
    |> Semester.changeset(attrs)
    |> Repo.update()
  end

  def list_semesters do
    Repo.all(Semester)
  end

  def delete_semester(%Semester{} = semester) do
    Repo.delete(semester)
  end

  def delete_course(%Course{} = course) do
    Repo.delete(course)
  end

  def create_course(attrs \\ %{}) do
    %Course{}
    |> Course.changeset(attrs)
    |> Repo.insert()
  end

  def create_semester(attrs \\ %{}) do
    %Semester{}
    |> Semester.changeset(attrs)
    |> Repo.insert()
  end

  defp course_preloads do
    [:semester, :teacher]
  end

  def prepare_course(%Course{} = course, attrs \\ %{}) do
    Course.changeset(course, attrs)
  end

  def prepare_semester(%Semester{} = semester, attrs \\ %{}) do
    Semester.changeset(semester, attrs)
  end

  def increment_enrollments_count(course_id, count \\ 1) do
    Course
    |> where([c], c.id == ^course_id)
    |> Repo.update_all(inc: [enrollments_count: count])
  end
end
