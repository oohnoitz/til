ExUnit.configure(exclude: [feature: true])
ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(Til.Repo, :manual)
