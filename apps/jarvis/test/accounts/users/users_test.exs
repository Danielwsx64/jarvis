defmodule Jarvis.Accounts.UsersTest do
  use Jarvis.DataCase, async: true

  alias Jarvis.Accounts.Users
  alias Jarvis.Accounts.Users.Schema

  describe "get_or_create_by_email/1" do
    test "create a new user when email is new" do
      email = "some@email.com"

      assert {:ok, %Schema{email: ^email}} = Users.get_or_create_by_email(email)
    end

    test "get user when is already created" do
      email = "some@email.com"
      user = insert(:user, email: email)

      assert Users.get_or_create_by_email(email) == {:ok, user}
    end

    test "error when try create user" do
      email = "invalid_email.com"

      assert {:error, changeset} = Users.get_or_create_by_email(email)
      assert changeset.errors == [{:email, {"invalid format", []}}]
    end
  end
end
