defmodule Jarvis.Accounts.UsersTest do
  use Jarvis.DataCase, async: true

  alias Jarvis.Accounts.Users
  alias Jarvis.Accounts.Users.Schema

  describe "get_or_create_by_email/1" do
    test "create a new user when email is new" do
      params = %{email: "some@email.com", image_url: "someurl"}

      assert {:ok, %Schema{email: "some@email.com", image_url: "someurl"}} =
               Users.get_or_create_by_email(params)
    end

    test "get user when is already created" do
      email = "some@email.com"
      params = %{email: email}
      user = insert(:user, email: email)

      assert Users.get_or_create_by_email(params) == {:ok, user}
    end

    test "error when try create user" do
      params = %{email: "invalid_email.com"}

      assert {:error, changeset} = Users.get_or_create_by_email(params)
      assert changeset.errors == [{:email, {"invalid format", []}}]
    end
  end
end
