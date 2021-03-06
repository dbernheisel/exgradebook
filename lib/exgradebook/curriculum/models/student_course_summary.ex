defmodule Exgradebook.Curriculum.StudentCourseSummary do
  use Ecto.Schema
  alias Exgradebook.Curriculum.Course
  alias Exgradebook.Curriculum.Semester
  alias Exgradebook.Users.Student

  @primary_key false
  @foreign_key_type :binary_id
  schema "student_course_summaries" do
    belongs_to :student, Student
    belongs_to :course, Course
    belongs_to :semester, Semester
    field :grade_sum, :float
    field :assignment_sum, :float
    field :grade_percentage, :float
  end
end
