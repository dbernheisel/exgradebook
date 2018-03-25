defmodule Exgradebook.Curriculum do
  import Ecto.Query, warn: false
  alias Exgradebook.Repo
  alias Exgradebook.Curriculum.Enrollment
  alias Exgradebook.Curriculum.Course
  alias Exgradebook.Curriculum.Semester

  def enroll_student_to_course(student, course) do
    %Enrollment{}
    |> Enrollment.create_changeset(%{
      student_id: student.id,
      course_id: course.id
    })
    |> Repo.insert
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

  defp course_preloads do
    [:semester, :teacher]
  end

  def prepare_course(%Course{} = course, attrs \\ %{}) do
    Course.changeset(course, attrs)
  end
end
