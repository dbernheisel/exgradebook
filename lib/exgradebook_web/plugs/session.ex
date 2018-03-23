defmodule ExgradebookWeb.Session do
  use Doorman.Login
  alias Exgradebook.Users.Staff
  alias Exgradebook.Users.Student

  @session_key :user_id
  @session_secret :session_secret

  @doc """
  Logs in given user by setting `:user_id` on the session of passed in `conn`.
  """
  def login(conn, user) do
    conn
    |> Plug.Conn.put_session(@session_key, user.id)
    |> Plug.Conn.put_session(@session_secret, user.session_secret)
  end

  @doc """
  Logs out current user.
  """
  def logout(conn) do
    conn
    |> Plug.Conn.delete_session(@session_key)
    |> Plug.Conn.delete_session(@session_secret)
  end

  @doc """
  Returns the current user or nil based on `:user_id` in the session.
  """
  def get_current_user(conn) do
    id = Plug.Conn.get_session(conn, @session_key)
    secret = Plug.Conn.get_session(conn, @session_secret)
    repo = Application.get_env(:doorman, :repo)

    if !is_nil(id) && !is_nil(secret) do
      repo.get_by(Staff, [id: id, session_secret: secret]) ||
        repo.get_by(Student, [id: id, session_secret: secret])
    end
  end
end
