use Mix.Releases.Config,
    # This sets the default release built by `mix release`
    default_release: :default,
    # This sets the default environment used by `mix release`
    default_environment: :dev

# For a full list of config options for both releases
# and environments, visit https://hexdocs.pm/distillery/configuration.html


# You may define one or more environments in this file,
# an environment's settings will override those of a release
# when building in that environment, this combination of release
# and environment configuration is called a profile

environment :dev do
  set dev_mode: true
  set include_erts: false
  set cookie: :"sR8jd_k3;BMu54/kG`f/vVM=|9[.jp6X<OUfKy~v`/1s78sX.Ay4W!YFWo8NzHbO"
end

environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :"W9aD1)D/6NHogrHOrp~7eI?lohzcm^C57wcL/0zR|AxD&rv$)u)N=I`LL=aq)/@D"
end

# You may define one or more releases in this file.
# If you have not set a default release, or selected one
# when running `mix release`, the first release in the file
# will be used by default

release :exgradebook do
  set version: current_version(:exgradebook)
end

