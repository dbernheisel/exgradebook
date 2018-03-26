defmodule Exgradebook.Repo.Migrations.CreateStudentCourseView do
  use Ecto.Migration

  def up do
    execute """
      CREATE OR REPLACE VIEW student_course_summaries AS
      SELECT
        course_id,
        student_id,
        assignment_sum,
        semester_id,
        grade_sum,
        grade_sum / assignment_sum AS grade_percentage
      FROM (
        SELECT
          courses.id AS course_id,
          courses.semester_id AS semester_id,
          SUM(assignments.value) AS assignment_sum
        FROM courses
        INNER JOIN assignments ON assignments.course_id = courses.id
        GROUP BY courses.id
      ) c1 LEFT JOIN LATERAL (
        SELECT
          grades.student_id AS student_id,
          SUM(grades.value) AS grade_sum
        FROM grades
        INNER JOIN assignments ON grades.assignment_id = assignments.id
        WHERE c1.course_id = assignments.course_id
        GROUP BY grades.student_id
      ) s2 ON true
    """
  end

  def down do
    execute """
      DROP VIEW student_course_summaries
    """
  end
end
