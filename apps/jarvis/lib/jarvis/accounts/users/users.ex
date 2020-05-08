defmodule Jarvis.Accounts.Users do
  alias Jarvis.Accounts.Users.{Loader, Mutator}

  defdelegate get(uuid), to: Loader

  def get_or_create_by_email(%{email: email} = params) do
    email
    |> Loader.get_by_email()
    |> create_if_needed(params)
  end

  defp create_if_needed(nil, params), do: Mutator.create(params)
  defp create_if_needed(user, _email), do: {:ok, user}
end
