defmodule Jarvis.Accounts.Users.MutatorTest do
  use Jarvis.DataCase, async: true

  alias Jarvis.Accounts.Users.{Mutator, Schema}

  describe "create/1" do
    test "create a new user" do
      params = %{email: "some@email.com"}

      assert {:ok, %Schema{email: "some@email.com"}} = Mutator.create(params)
    end

    test "error when email has been already taken" do
      email = "some@email.com"
      insert(:user, email: email)

      params = %{email: email}

      assert {:error, changeset} = Mutator.create(params)

      assert changeset.errors == [
               {:email,
                {"has already been taken",
                 [constraint: :unique, constraint_name: "users_email_index"]}}
             ]
    end
  end
end
