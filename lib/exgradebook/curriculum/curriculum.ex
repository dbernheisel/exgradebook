defmodule Exgradebook.Curriculum do
  use Exgradebook.Curriculum.Query.CourseQuery
  use Exgradebook.Curriculum.Query.SemesterQuery
  use Exgradebook.Curriculum.Query.EnrollmentQuery
  use Exgradebook.Curriculum.Query.AssignmentQuery
  use Exgradebook.Curriculum.Query.GradeQuery

  @moduledoc """
  The Curriculum context.
  """
end
