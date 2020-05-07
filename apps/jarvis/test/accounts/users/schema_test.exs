defmodule Jarvis.Accounts.Users.SchemaTest do
  use Jarvis.DataCase, async: true

  alias Jarvis.Accounts.Users.Schema

  describe "schema" do
    test "schema must has keys" do
      Enum.each([:email, :inserted_at, :updated_at], fn key ->
        assert Map.has_key?(%Schema{}, key)
      end)
    end
  end

  describe "changeset/2" do
    test "return a valid changeset" do
      params = %{email: "test@email.com"}

      changeset = Schema.changeset(%Schema{}, params)

      assert changeset.valid?
    end

    test "validate required email" do
      params = %{}

      changeset = Schema.changeset(%Schema{}, params)

      refute changeset.valid?
      assert changeset.errors == [{:email, {"can't be blank", [validation: :required]}}]
    end

    test "validate invalid email type" do
      params = %{email: 1000}

      changeset = Schema.changeset(%Schema{}, params)

      refute changeset.valid?
      assert changeset.errors == [email: {"is invalid", [{:type, :string}, {:validation, :cast}]}]
    end

    test "validate invalid email" do
      params = %{email: "invalid_email.com"}

      changeset = Schema.changeset(%Schema{}, params)

      refute changeset.valid?
      assert changeset.errors == [email: {"invalid format", []}]
    end
  end
end
