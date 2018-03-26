defmodule ExgradebookWeb.Staff.CourseView do
  use ExgradebookWeb, :view
  alias Exgradebook.Users
  alias Exgradebook.Curriculum
  import ExgradebookWeb.Staff.UserView, only: [display_name: 1]

  def student_options(course_id) do
    course_id
    |> Users.list_students_not_in_course
    |> Enum.map(& {display_name(&1), &1.id})
  end

  def semester_options do
    Curriculum.list_semesters()
    |> Enum.map(& {&1.name, &1.id})
  end

  def teacher_options do
    Users.list_staff()
    |> Enum.map(& {display_name(&1), &1.id})
  end

  def grade_percentage_for_student_in_course(student, course_id) do
    points_earned = Curriculum.points_earned_for_student_in_course(student.id, course_id) || 0
    points_possible = Curriculum.points_possible_for_course(course_id)
    Number.Percentage.number_to_percentage((points_earned / points_possible) * 100, precision: 1)
  end

  def grade_percentage_for_course(course_id) do
    course = Curriculum.get_course!(course_id)
    points_earned = Curriculum.points_earned_for_course(course_id) || 0
    points_possible = Curriculum.points_possible_for_course(course_id) * course.enrollments_count
    Number.Percentage.number_to_percentage((points_earned / points_possible) * 100, precision: 1)
  end
end
