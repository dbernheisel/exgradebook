# Exgradebook

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Getting Started

After you have cloned this repo, run this setup script to set up your machine
with the necessary dependencies to run and test this app:

    % ./bin/setup

It assumes you have a machine equipped with [asdf], [asdf-elixir],
[asdf-erlang], [asdf-nodejs], [PhantomJS], [postgres], etc.

After setting up, you can run the application:

    % ./bin/server

[asdf]: https://github.com/asdf-vm/asdf
[asdf-elixir]: https://github.com/asdf-vm/asdf-elixir
[asdf-erlang]: https://github.com/asdf-vm/asdf-erlang
[asdf-nodejs]: https://github.com/asdf-vm/asdf-nodejs
[PhantomJS]: http://phantomjs.org/
[postgres]: http://postgresapp.com/

## Requirements

[x] A Teacher can manage his course roster
[x] A Teacher can view the enrolled students and their grades for a given course
[x] A Student can see the courses he is registered for (with grades)
[ ] A Student can see his GPA for a given semester
[x] An Administrator can view enrollment counts across all courses for a semester (performance is a concern)
[x] An Administrator can view an average grade for a given course (performance is a concern)
