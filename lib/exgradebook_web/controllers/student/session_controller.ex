defmodule ExgradebookWeb.Student.SessionController do
  use ExgradebookWeb, :controller
  #alias Exgradebook.Users.Student
  alias ExgradebookWeb.Session

  def new(conn, _params) do
    conn
    |> render(:new)
  end

  #def create(conn, %{"login" => %{"email" => email, "password" => pass}}) do
    #if user = Doorman.authenticate(Student, email, pass) do
      #conn
      #|> Session.login(user)
      #|> put_flash(:notice, gettext("Successfully signed in"))
      #|> redirect(to: student_course_path(conn, :index))
    #else
      #conn
      #|> put_flash(:error, gettext("Incorrect email or password"))
      #|> redirect(to: student_session_path(conn, :new))
    #end
  #end
end
