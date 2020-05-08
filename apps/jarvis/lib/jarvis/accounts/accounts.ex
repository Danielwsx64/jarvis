defmodule Jarvis.Accounts do
  defdelegate get_user(uuid), to: Jarvis.Accounts.Users, as: :get
end
