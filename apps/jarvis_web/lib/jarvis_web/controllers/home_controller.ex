defmodule JarvisWeb.HomeController do
  use JarvisWeb, :controller
  alias Jarvis.Accounts.Users.Loader

  def index(conn, _params) do
    current_user =
      conn
      |> get_session(:current_user)
      |> Loader.get()

    render(conn, current_user: current_user)
  end
end
