defmodule Jarvis.Accounts.Users.LoaderTest do
  use Jarvis.DataCase, async: true

  alias Jarvis.Accounts.Users.Loader

  describe "get/1" do
    test "get user by id" do
      user = insert(:user)

      assert Loader.get(user.id) == user
    end

    test "return nil when not found" do
      uuid = UUID.generate()

      assert Loader.get(uuid) == nil
    end
  end

  describe "get_by_email/1" do
    test "get user by id" do
      email = "some@email.co"
      user = insert(:user, email: email)

      assert Loader.get_by_email(email) == user
    end

    test "return nil when not found" do
      email = "some@email.co"

      assert Loader.get_by_email(email) == nil
    end
  end
end
