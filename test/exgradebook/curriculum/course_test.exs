defmodule Exgradebook.Curriculum.CourseTest do
  use Exgradebook.DataCase, async: true
  alias Exgradebook.Curriculum
  alias Exgradebook.Curriculum.Course
  alias Exgradebook.Curriculum.Enrollment

  describe "changeset" do
    test "requires fields" do
      params = params_for(
        :course,
        title: nil,
        teacher: nil,
        semester: nil
      )

      changeset = Course.changeset(%Course{}, params)

      assert changeset.errors[:title]
      assert changeset.errors[:teacher_id]
      assert changeset.errors[:semester_id]
    end

    test "has defaults" do
      course = %Course{}

      assert course.enrollments_count == 0
    end

    test "requires title to be unique" do
      existing_course = insert(:course, title: "duplicate")
      params = params_with_assocs(:course, title: existing_course.title)

      {:error, changeset} =
        %Course{}
        |> Course.changeset(params)
        |> Repo.insert

      assert {"has already been taken", _} = changeset.errors[:title]
    end
  end

  describe "increment_course_enrollment_count" do
    test "adds a transaction to increase enrollment_count" do
      course = insert(:course, enrollments_count: 0)
      enrollment_params = params_with_assocs(:enrollment, course: course)

      enrollment_changeset =
        %Enrollment{}
        |> Enrollment.changeset(enrollment_params)
        |> Course.increment_course_enrollment_count
      assert enrollment_changeset.prepare |> List.first

      enrollment =
        enrollment_changeset
        |> Repo.insert!
        |> Repo.preload(:course)
      assert enrollment.course.enrollments_count == 1
    end
  end

  describe "list_courses" do
    test "returns all courses" do
      courses = insert_pair(:course)

      [fetched_course_one, fetched_course_two] = Curriculum.list_courses()

      assert fetched_course_one.id in map_ids(courses)
      assert fetched_course_two.id in map_ids(courses)
    end
  end
end