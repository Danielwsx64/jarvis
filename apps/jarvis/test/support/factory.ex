defmodule Jarvis.Support.Factory do
  use ExMachina.Ecto, repo: Jarvis.Repo

  # Factories
  use Jarvis.Support.Factories.UsersFactory
end
