Application.ensure_all_started(:wallaby)
PhantomJS.start()
ExUnit.configure(exclude: [skip: true])
ExUnit.start()
Application.put_env(:wallaby, :base_url, ExgradebookWeb.Endpoint.url)

Ecto.Adapters.SQL.Sandbox.mode(Exgradebook.Repo, :manual)

