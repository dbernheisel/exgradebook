defmodule ExgradebookWeb.CourseView do
  alias Exgradebook.Curriculum
  alias Exgradebook.Curriculum.GradeScale

  def grade_percentage_for_student_in_course(student, course_id) do
    points_earned = Curriculum.points_earned_for_student_in_course(student.id, course_id) || 0
    points_possible = Curriculum.points_possible_for_course(course_id)
    (points_earned / points_possible) * 100
  end

  def grade_percentage_for_course(course_id) do
    course = Curriculum.get_course!(course_id)
    points_earned = Curriculum.points_earned_for_course(course_id) || 0
    points_possible = Curriculum.points_possible_for_course(course_id) * course.enrollments_count
    (points_earned / points_possible) * 100
  end

  def letter_grade(percentage) do
    rounded_percentage =
      percentage
      |> Decimal.from_float()
      |> Decimal.round(0, :half_up)
      |> Decimal.to_integer

    GradeScale.all_grades
    |> Enum.find(%GradeScale{}, fn grade ->
      rounded_percentage in grade.min_range..grade.max_range
    end)
    |> Map.get(:letter)
  end

  def display_grade(course_id) do
    percentage = grade_percentage_for_course(course_id)
    [
      Number.Percentage.number_to_percentage(percentage, precision: 1),
      letter_grade(percentage)
    ] |> Enum.join(" ")
  end
  def display_grade(course_id, student) do
    percentage = grade_percentage_for_student_in_course(student, course_id)
    [
      Number.Percentage.number_to_percentage(percentage, precision: 1),
      letter_grade(percentage)
    ] |> Enum.join(" ")
  end
end
