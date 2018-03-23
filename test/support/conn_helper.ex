defmodule ExgradebookWeb.Test.ConnHelper do
  @secret_key_base "111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"
  @default_options [
    encrypt: false,
    key: "foobar",
    log: false,
    signing_salt: "signing salt",
    store: :cookie
  ]

  def build_conn_with_session do
    Phoenix.ConnTest.build_conn().secret_key_base
    |> put_in(@secret_key_base)
    |> Plug.Session.call(signing_options())
    |> Plug.Conn.fetch_session
    |> Phoenix.Controller.fetch_flash
  end

  defp signing_options do
    Plug.Session.init(@default_options)
  end
end
