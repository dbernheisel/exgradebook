defmodule Exgradebook.Curriculum.StudentCourseSummary do
  use Ecto.Schema
  alias Exgradebook.Curriculum.Course
  alias Exgradebook.Curriculum.Semester
  alias Exgradebook.Users.Student

  @primary_key false
  schema "student_course_summaries" do
    belongs_to :student, Student, type: :binary_id
    belongs_to :course, Course, type: :binary_id
    belongs_to :semester, Semester, type: :binary_id
    field :grade_sum, :float
    field :assignment_sum, :float
    field :grade_percentage, :float
  end
end
