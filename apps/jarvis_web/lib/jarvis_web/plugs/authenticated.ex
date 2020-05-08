defmodule JarvisWeb.Plugs.Authenticated do
  use Phoenix.Controller, namespace: JarvisWeb

  import Plug.Conn

  alias Jarvis.Accounts
  alias JarvisWeb.Router.Helpers, as: Routes

  def init(_opts), do: []

  def call(conn, _opts) do
    conn
    |> get_session(:user_id)
    |> load_user()
    |> assigns_current_user(conn)
    |> handle_connection(conn)
  end

  defp load_user(nil), do: {:error, "missing user id"}
  defp load_user(uuid), do: Accounts.get_user(uuid)

  defp assigns_current_user(%{} = user, conn), do: assign(conn, :current_user, user)
  defp assigns_current_user(nil, _conn), do: {:error, "user not found"}
  defp assigns_current_user({:error, _} = error, _conn), do: error

  defp handle_connection({:error, _}, conn) do
    conn
    |> redirect(to: Routes.auth_path(conn, :new))
    |> halt()
  end

  defp handle_connection(conn, _org), do: conn
end
