defmodule Jarvis.Accounts.Users do
  alias Jarvis.Accounts.Users.{Loader, Mutator}

  def get_or_create_by_email(email) do
    email
    |> Loader.get_by_email()
    |> create_if_needed(email)
  end

  defp create_if_needed(nil, email), do: Mutator.create(%{email: email})
  defp create_if_needed(user, _email), do: {:ok, user}
end
