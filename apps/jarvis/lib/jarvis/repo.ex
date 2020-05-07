defmodule Jarvis.Repo do
  use Ecto.Repo,
    otp_app: :jarvis,
    adapter: Ecto.Adapters.Postgres
end
