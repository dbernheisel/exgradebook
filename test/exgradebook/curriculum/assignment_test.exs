defmodule Exgradebook.Curriculum.AssignmentTest do
  use Exgradebook.DataCase, async: true
  alias Exgradebook.Curriculum
  alias Exgradebook.Curriculum.Assignment

  describe "changeset" do
    test "requires fields" do
      params = params_for(
        :assignment,
        name: nil,
        value: nil,
        course: nil
      )

      changeset = Assignment.changeset(%Assignment{}, params)

      assert changeset.errors[:name]
      assert changeset.errors[:value]
      assert changeset.errors[:course_id]
    end
  end

  describe "list_assignments" do
    test "returns all assignments" do
      assignments = insert_pair(:assignment)

      [fetched_assignment_one, fetched_assignment_two] = Curriculum.list_assignments()

      assert fetched_assignment_one.id in map_ids(assignments)
      assert fetched_assignment_two.id in map_ids(assignments)
    end
  end

  describe "list_assignments_for_course" do
    test "returns all assignments for course" do
      course = insert(:course)
      assignments = insert_pair(:assignment, course: course)
      _other_assignment = insert(:assignment)

      [fetched_assignment_one, fetched_assignment_two] = Curriculum.list_assignments_for_course(course.id)

      assert fetched_assignment_one.id in map_ids(assignments)
      assert fetched_assignment_two.id in map_ids(assignments)
    end

    test "returns all assignments scoped to staff for course" do
      other_user = insert(:teacher)
      user = insert(:teacher)
      course = insert(:course, teacher: other_user)
      _assignments = insert_pair(:assignment, course: course)
      _other_assignment = insert(:assignment)

      assert [] = Curriculum.list_assignments_for_course(course.id, user: user)
    end

    test "returns all assignments scoped to student for course" do
      student = insert(:student)
      course = insert(:course)
      _other_course = insert(:course)
      _assignments = insert_pair(:assignment, course: course)
      insert(:enrollment, student: student, course: course)
      _other_assignment = insert(:assignment)

      assert [] = Curriculum.list_assignments_for_course(course.id, user: student)
    end
  end

  describe "points possible for course" do
    test "returns the sum of the assignments for the course" do
      course = insert(:course)
      _assignments = insert_pair(:assignment, course: course, value: 41)
      _other_assignment = insert(:assignment, value: 30)

      points_possible = Curriculum.points_possible_for_course(course.id)

      assert points_possible == 82
    end
  end

  describe "points_total_for_semester" do
    test "returns the sum of the assignments for the semester" do
      student = insert(:student)
      semester = insert(:semester)
      course = insert(:course, semester: semester)
      insert(:enrollment, student: student, course: course)
      [assignment_one, assignment_two] = insert_pair(:assignment, value: 1, course: course)
      insert(:grade, value: 1, assignment: assignment_one, student: student)
      insert(:grade, value: 1, assignment: assignment_two, student: student)
      _other_assignment = insert(:assignment, value: 1)

      result = Curriculum.points_total_for_semester(student, semester)

      assert result == 2.0
    end
  end
end
