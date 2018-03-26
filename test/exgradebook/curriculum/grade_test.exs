defmodule Exgradebook.Curriculum.GradeTest do
  use Exgradebook.DataCase, async: true
  alias Exgradebook.Curriculum
  alias Exgradebook.Curriculum.Grade

  describe "changeset" do
    test "requires fields" do
      params = params_for(
        :grade,
        assignment: nil,
        student: nil,
        value: nil
      )

      changeset = Grade.changeset(%Grade{}, params)

      assert changeset.errors[:assignment_id]
      assert changeset.errors[:value]
      assert changeset.errors[:student_id]
    end

    test "unique grade for student and assignment" do
      student = insert(:student)
      assignment = insert(:assignment)
      _existing_grade = insert(:grade, student: student, assignment: assignment)
      params = params_for(:grade, student: student, assignment: assignment)

      {:error, changeset} =
        %Grade{}
        |> Grade.changeset(params)
        |> Repo.insert

      assert {"already has a grade for this assignment", _} = changeset.errors[:student]
    end
  end

  describe "points_earned_for_student_in_course" do
    test "returns the grade sum for all grades for a course" do
      student = insert(:student)
      course = insert(:course)
      insert(:enrollment, student: student, course: course)
      [assignment_one, assignment_two] = insert_pair(:assignment, value: 1, course: course)
      insert(:grade, value: 1, assignment: assignment_one, student: student)
      insert(:grade, value: 0.5, assignment: assignment_two, student: student)
      _other_assignment = insert(:assignment, value: 1)

      result = Curriculum.points_earned_for_student_in_course(student.id, course.id)

      assert result == 1.5
    end
  end

  describe "points_earned_for_course" do
    test "returns the grade sum for all grades for a course" do
      student_one = insert(:student)
      student_two = insert(:student)
      course = insert(:course)
      insert(:enrollment, student: student_one, course: course)
      insert(:enrollment, student: student_two, course: course)
      [assignment_one, assignment_two] = insert_pair(:assignment, value: 1, course: course)
      insert(:grade, value: 1, assignment: assignment_one, student: student_one)
      insert(:grade, value: 0.5, assignment: assignment_two, student: student_two)
      _other_grade = insert(:grade, value: 1)

      result = Curriculum.points_earned_for_course(course.id)

      assert result == 1.5
    end
  end

  describe "points_earned_for_semester" do
    test "returns the grade sum for all grades for courses in semester" do
      semester = insert(:semester)
      student_one = insert(:student)
      student_two = insert(:student)
      course = insert(:course, semester: semester)
      insert(:enrollment, student: student_one, course: course)
      insert(:enrollment, student: student_two, course: course)
      [assignment_one, assignment_two] = insert_pair(:assignment, value: 1, course: course)
      insert(:grade, value: 1, assignment: assignment_one, student: student_one)
      insert(:grade, value: 1, assignment: assignment_two, student: student_one)
      insert(:grade, value: 0.5, assignment: assignment_one, student: student_two)
      insert(:grade, value: 0.5, assignment: assignment_two, student: student_two)

      other_semester = insert(:semester)
      other_course = insert(:course, semester: other_semester)
      [other_assignment_one, other_assignment_two] =
        insert_pair(:assignment, value: 1, course: other_course)
      insert(:grade, value: 1, assignment: other_assignment_one, student: student_one)
      insert(:grade, value: 0.5, assignment: other_assignment_two, student: student_two)

      student_one_result = Curriculum.points_earned_for_semester(student_one, semester)
      student_two_result = Curriculum.points_earned_for_semester(student_two, semester)

      assert student_one_result == 2.0
      assert student_two_result == 1.0
    end
  end

  describe "gpa_for_student_in_semester" do
    test "returns the grade percentage" do
      semester = insert(:semester)
      student_one = insert(:student)
      student_two = insert(:student)
      course = insert(:course, semester: semester)
      insert(:enrollment, student: student_one, course: course)
      insert(:enrollment, student: student_two, course: course)
      [assignment_one, assignment_two] = insert_pair(:assignment, value: 1, course: course)
      insert(:grade, value: 1, assignment: assignment_one, student: student_one)
      insert(:grade, value: 1, assignment: assignment_two, student: student_one)
      insert(:grade, value: 0.5, assignment: assignment_one, student: student_two)
      insert(:grade, value: 0.5, assignment: assignment_two, student: student_two)

      other_semester = insert(:semester)
      other_course = insert(:course, semester: other_semester)
      [other_assignment_one, other_assignment_two] =
        insert_pair(:assignment, value: 1, course: other_course)
      insert(:grade, value: 1, assignment: other_assignment_one, student: student_one)
      insert(:grade, value: 0.5, assignment: other_assignment_two, student: student_two)

      student_one_result = Curriculum.gpa_for_student_in_semester(student_one, semester)
      student_two_result = Curriculum.gpa_for_student_in_semester(student_two, semester)

      assert student_one_result == 1.0
      assert student_two_result == 0.5
    end

  end
end
