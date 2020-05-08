defmodule JarvisWeb.AuthControllerTest do
  use JarvisWeb.ConnCase, async: true

  alias Jarvis.Accounts.Users.Schema

  describe "GET /auth/new [ new ]" do
    test "render the new authentication page", %{conn: conn} do
      response =
        conn
        |> get(auth_path(conn, :new))
        |> html_response(200)

      assert floki_find(response, "a[href='/auth/google']") != []
    end
  end

  describe "DELETE /auth/logout [ delete ]" do
    test "clear session and redirect", %{conn: conn} do
      response =
        conn
        |> init_test_session(current_user: "someuser")
        |> delete(auth_path(conn, :delete))

      assert redirected_to(response, 302) =~ "/auth/new"
      assert get_flash(response, :info) == "You have been logged out!"

      refute Map.has_key?(response.private.plug_session, "current_user")
    end
  end

  describe "GET/POST /auth/:provider/callback [ callback ]" do
    test "redirect when fail to authenticate", %{conn: conn} do
      response =
        conn
        |> assign(:ueberauth_failure, [])
        |> post(auth_path(conn, :callback, "google"))

      assert redirected_to(response, 302) =~ "/auth/new"
      assert get_flash(response, :error) == "Failed to authenticate."
    end

    test "assign user to session when success authenticate", %{conn: conn} do
      email = "user@gmail.com"
      user = insert(:user, email: email)

      ueberauth_auth = %Ueberauth.Auth{
        info: %Ueberauth.Auth.Info{
          birthday: nil,
          description: nil,
          email: email,
          first_name: nil,
          image: "https://lh3.googleusercontent.com/a-/sadfasdfasdfdsaf",
          last_name: nil,
          location: nil,
          name: nil,
          nickname: nil,
          phone: nil,
          urls: %{profile: nil, website: "user.co"}
        },
        provider: :google,
        strategy: Ueberauth.Strategy.Google,
        uid: "23845728349572309572439"
      }

      response =
        conn
        |> assign(:ueberauth_auth, ueberauth_auth)
        |> post(auth_path(conn, :callback, "google"))

      assert redirected_to(response, 302) =~ "/"
      assert get_flash(response, :info) == "Successfully authenticated."
      assert response.private.plug_session["current_user"] == user.id
    end

    test "create a new user when success authenticate with new email", %{conn: conn} do
      email = "user@gmail.com"
      image = "https://lh3.googleusercontent.com/a-/sadfasdfasdfdsaf"

      ueberauth_auth = %Ueberauth.Auth{
        info: %Ueberauth.Auth.Info{
          birthday: nil,
          description: nil,
          email: email,
          first_name: nil,
          image: image,
          last_name: nil,
          location: nil,
          name: nil,
          nickname: nil,
          phone: nil,
          urls: %{profile: nil, website: "user.co"}
        },
        provider: :google,
        strategy: Ueberauth.Strategy.Google,
        uid: "23845728349572309572439"
      }

      response =
        conn
        |> assign(:ueberauth_auth, ueberauth_auth)
        |> post(auth_path(conn, :callback, "google"))

      assert redirected_to(response, 302) =~ "/"
      assert get_flash(response, :info) == "Successfully authenticated."
      assert user_id = response.private.plug_session["current_user"]
      assert Repo.get(Schema, user_id)
    end

    test "error when try create new user", %{conn: conn} do
      email = "invalid_email.com"
      image = "https://lh3.googleusercontent.com/a-/sadfasdfasdfdsaf"

      ueberauth_auth = %Ueberauth.Auth{info: %Ueberauth.Auth.Info{email: email, image: image}}

      response =
        conn
        |> assign(:ueberauth_auth, ueberauth_auth)
        |> post(auth_path(conn, :callback, "google"))

      assert redirected_to(response, 302) =~ "/auth/new"
      assert get_flash(response, :error) == "Authentication error"
    end
  end
end
