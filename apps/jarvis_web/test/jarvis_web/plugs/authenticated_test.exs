defmodule JarvisWeb.Plugs.AuthenticatedTest do
  use JarvisWeb.ConnCase, async: true

  alias JarvisWeb.Plugs.Authenticated

  describe "init/1" do
    test "return empty options" do
      assert Authenticated.init(:options) == []
    end
  end

  describe "call/2" do
    test "assign current_user", %{conn: conn} do
      user = insert(:user)

      response =
        conn
        |> init_test_session(user_id: user.id)
        |> Authenticated.call([])

      assert response.assigns.current_user == user
    end

    test "halt and redirect when has no user_id", %{conn: conn} do
      response =
        conn
        |> init_test_session(session: "any")
        |> Authenticated.call([])

      assert response.halted
      assert redirected_to(response) =~ "/auth/new"
    end

    test "halt and redirect when user not found", %{conn: conn} do
      response =
        conn
        |> init_test_session(user_id: UUID.generate())
        |> Authenticated.call([])

      assert response.halted
      assert redirected_to(response) =~ "/auth/new"
    end
  end
end
