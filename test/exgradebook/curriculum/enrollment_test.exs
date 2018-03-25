defmodule Exgradebook.Curriculum.EnrollmentTest do
  use Exgradebook.DataCase, async: true
  alias Exgradebook.Curriculum
  alias Exgradebook.Curriculum.Enrollment
  alias Exgradebook.Curriculum.Course

  describe "enroll" do
    test "creates enrollment for student for course and increments count" do
      course = insert(:course, enrollments_count: 0)
      params = params_with_assocs(:enrollment, course: course)

      {:ok, enrollment} = Curriculum.enroll(params)

      course = Repo.get!(Course, course.id)
      assert %Enrollment{} = enrollment
      assert course.enrollments_count == 1
    end
  end

  describe "unenroll" do
    test "deletes enrollment for student for course and decrements count" do
      course = insert(:course, enrollments_count: 1)
      enrollment = insert(:enrollment, course: course)

      {:ok, enrollment} = Curriculum.unenroll(enrollment.id)

      course = Repo.get!(Course, course.id)
      assert_raise Ecto.NoResultsError, fn -> Curriculum.get_enrollment!(enrollment.id) end
      assert course.enrollments_count == 0
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

  describe "list_enrollments_for_course" do
    test "returns all enrollments in course" do
      course = insert(:course)
      expected_enrollment = insert(
        :enrollment,
        course: course
      )
      _other_enrollment = insert(:enrollment)

      [enrollment] = Curriculum.list_enrollments_for_course(course.id)

      assert enrollment.id == expected_enrollment.id
    end
  end
end
