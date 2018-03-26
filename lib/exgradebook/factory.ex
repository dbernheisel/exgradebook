defmodule Exgradebook.Factory do
  use ExMachina.Ecto, repo: Exgradebook.Repo
  alias Exgradebook.Repo, warn: false

  def staff_factory do
    %Exgradebook.Users.Staff{
      email: sequence(:staff_email, &"staff-#{&1}@example.com"),
      first_name: sequence(:staff_first_name, &"First Name #{&1}"),
      hashed_password: sequence(:hashed_password, &"password-#{&1}"),
      last_name: sequence(:staff_last_name, &"Last Name #{&1}"),
      role: "teacher",
      session_secret: sequence(:session_secret, &"session-#{&1}"),
    }
  end

  def student_factory do
    %Exgradebook.Users.Student{
      email: sequence(:student_email, &"flastname#{&1}@student.example.com"),
      first_name: sequence(:student_first_name, &"First Name #{&1}"),
      hashed_password: sequence(:hashed_password, &"password-#{&1}"),
      last_name: sequence(:student_last_name, &"Last Name #{&1}"),
      session_secret: sequence(:session_secret, &"session-#{&1}"),
    }
  end

  def teacher_factory do
    build(:staff, role: "teacher")
  end

  def admin_factory do
    build(:teacher, role: "administrator")
  end

  def course_factory do
    %Exgradebook.Curriculum.Course{
      title: sequence(:course_title, &"Course Title #{&1}"),
      enrollments_count: 0,
      semester: build(:semester),
      teacher: build(:teacher),
    }
  end

  def enrollment_factory do
    %Exgradebook.Curriculum.Enrollment{
      student: build(:student),
      course: build(:course),
    }
  end

  def semester_factory do
    %Exgradebook.Curriculum.Semester{
      name: sequence(:semester_name, &"Semester Name #{&1}"),
      started_on: Timex.today(),
      ended_on: Timex.shift(Timex.today(), days: 180),
    }
  end

  def assignment_factory do
    %Exgradebook.Curriculum.Assignment{
      name: sequence(:assignment_name, &"Assignment Name #{&1}"),
      value: Enum.random(0..100),
      course: build(:course),
    }
  end

  def grade_factory do
    %Exgradebook.Curriculum.Grade{
      value: Enum.random(0..100),
      assignment: build(:assignment),
      student: build(:student),
    }
  end

  def course_with_students_for_teacher_and_semester(teacher, semester, number_of_students \\ 10) do
    students = insert_list(number_of_students, :student)
    course = insert(
      :course,
      enrollments_count: number_of_students,
      semester: semester,
      teacher: teacher
    )
    Enum.each(students, fn student ->
      insert(:enrollment, student: student, course: course)
    end)
    course
  end

  def add_assignments_and_grades_for_course(course) do
    course = course |> Repo.preload(:students)
    assignments =
      insert_list(10, :assignment, course: course)
      |> Enum.map(& add_grades_to_assignment(&1, course.students))

    %{course | assignments: assignments}
  end

  def add_grades_to_assignment(assignment, students, grades \\ [])
  def add_grades_to_assignment(assignment, [], grades) do
    %{assignment | grades: grades}
  end
  def add_grades_to_assignment(assignment, [student | rest_of_students], grades) do
    grade = insert(
      :grade,
      value: Enum.random(0..round(assignment.value)),
      assignment: assignment,
      student: student
    )
    add_grades_to_assignment(assignment, rest_of_students, [grade | grades])
  end

  def for_registration(user) do
    user
    |> Map.delete(:hashed_password)
    |> Map.delete(:session_secret)
    |> Map.put(:password, "password")
  end
end
