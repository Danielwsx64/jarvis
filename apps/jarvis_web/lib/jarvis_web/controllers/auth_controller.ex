defmodule JarvisWeb.AuthController do
  use JarvisWeb, :controller

  alias Jarvis.Accounts.Users
  alias JarvisWeb.Endpoint

  plug(Ueberauth)

  def new(conn, _params) do
    render(conn)
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> clear_session()
    |> redirect(to: login_path())
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: login_path())
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    auth.info
    |> get_or_create_user()
    |> handle_authentication(conn)
  end

  defp get_or_create_user(%{email: email, image: image_url}) do
    Users.get_or_create_by_email(%{email: email, image_url: image_url})
  end

  defp handle_authentication({:ok, user}, conn) do
    conn
    |> put_flash(:info, "Successfully authenticated.")
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
    |> redirect(to: Routes.home_path(conn, :index))
  end

  defp handle_authentication(_error, conn) do
    conn
    |> put_flash(:error, "Authentication error")
    |> redirect(to: login_path())
  end

  defp login_path, do: Routes.auth_path(Endpoint, :new)
end
