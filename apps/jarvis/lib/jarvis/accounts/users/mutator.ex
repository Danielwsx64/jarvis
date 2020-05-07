defmodule Jarvis.Accounts.Users.Mutator do
  alias Jarvis.Accounts.Users.Schema
  alias Jarvis.Repo

  def create(%{} = params) do
    %Schema{}
    |> Schema.changeset(params)
    |> Repo.insert()
  end
end
