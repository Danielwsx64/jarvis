defmodule Jarvis.Accounts.Users.Loader do
  alias Jarvis.Accounts.Users.Schema
  alias Jarvis.Repo

  def get(uuid), do: Repo.get(Schema, uuid)

  def get_by_email(email), do: Repo.get_by(Schema, email: email)
end
