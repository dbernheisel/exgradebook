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

  def for_registration(user) do
    user
    |> Map.delete(:hashed_password)
    |> Map.delete(:session_secret)
    |> Map.put(:password, "password")
  end
end
