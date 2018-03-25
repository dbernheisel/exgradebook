defmodule Exgradebook.Curriculum.EnrollmentTest do
  use Exgradebook.DataCase, async: true
  alias Exgradebook.Curriculum
  alias Exgradebook.Curriculum.Enrollment
  alias Exgradebook.Curriculum.Course

  describe "enroll_student_to_course" do
    test "creates enrollment for student for course and increments count" do
      student = insert(:student)
      course = insert(:course, enrollments_count: 0)

      {:ok, enrollment} = Curriculum.enroll_student_to_course(student, course)

      course = Repo.get!(Course, course.id)
      assert %Enrollment{} = enrollment
      assert enrollment.student_id == student.id
      assert enrollment.course_id == course.id
      assert course.enrollments_count == 1
    end
  end

  describe "create_changeset" do
    test "adds transaction to increment enrollment count for course" do
      course = insert(:course)
      params = params_with_assocs(:enrollment, course: course)

      changeset = Enrollment.create_changeset(%Enrollment{}, params)

      assert changeset.prepare |> List.first
    end
  end

  describe "changeset" do
    test "requires fields" do
      params = params_for(:enrollment, course: nil, student: nil)

      changeset = Enrollment.changeset(%Enrollment{}, params)

      assert changeset.errors[:course_id]
      assert changeset.errors[:student_id]
    end

    test "student can only be enrolled once in course" do
      student = insert(:student)
      course = insert(:course)
      _existing_enrollment = insert(:enrollment, course: course, student: student)
      params = params_for(:enrollment, course: course, student: student)

      {:error, changeset} =
        %Enrollment{}
        |> Enrollment.changeset(params)
        |> Repo.insert

      assert {"already enrolled for course", _} = changeset.errors[:student]
    end
  end
end
