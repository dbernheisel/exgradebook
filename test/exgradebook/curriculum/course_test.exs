defmodule Exgradebook.Curriculum.CourseTest do
  use Exgradebook.DataCase, async: true
  alias Exgradebook.Curriculum
  alias Exgradebook.Curriculum.Course

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

  describe "list_courses" do
    test "returns all courses" do
      courses = insert_pair(:course)

      [fetched_course_one, fetched_course_two] = Curriculum.list_courses()

      assert fetched_course_one.id in map_ids(courses)
      assert fetched_course_two.id in map_ids(courses)
    end
  end

  describe "search_courses" do
    test "returns matching courses" do
      semester = insert(:semester)
      matching_course_one = insert(:course, semester: semester)
      _other_course = insert(:course)
      teacher = insert(:teacher)
      matching_course_two = insert(:course, teacher: teacher)
      _other_course = insert(:course)
      matching_courses = [matching_course_one, matching_course_two]
      semester_params = %{"semester_id" => semester.id, "teacher_id" => ""}
      teacher_params = %{"semester_id" => "", "teacher_id" => teacher.id}

      [fetched_course_one] = Curriculum.search_courses(semester_params)
      [fetched_course_two] = Curriculum.search_courses(teacher_params)

      assert fetched_course_one.id in map_ids(matching_courses)
      assert fetched_course_two.id in map_ids(matching_courses)
    end

    test "returns all when no params" do
      courses = insert_pair(:course)
      params = %{"semester_id" => "", "teacher_id" => ""}

      [fetched_course_one, fetched_course_two] = Curriculum.search_courses(params)

      assert fetched_course_one.id in map_ids(courses)
      assert fetched_course_two.id in map_ids(courses)
    end
  end
end
