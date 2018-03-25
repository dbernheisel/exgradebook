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
    Repo.all(Course)
  end

  def list_semesters do
    Repo.all(Semester)
  end
end
