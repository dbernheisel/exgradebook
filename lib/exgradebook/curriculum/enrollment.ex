defmodule Exgradebook.Curriculum.Enrollment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Exgradebook.Curriculum.Course
  alias Exgradebook.Users.Student

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "enrollments" do
    belongs_to :course, Course
    belongs_to :student, Student

    timestamps()
  end

  @required_fields ~w(
    course_id
    student_id
  )a

  @doc false
  def create_changeset(struct, params) do
    struct
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> Course.increment_course_enrollment_count()
  end
end
