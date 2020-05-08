defmodule Jarvis.Accounts.Users.Schema do
  use Jarvis.Schema

  @email_regex ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/

  schema "users" do
    field(:email, :string)
    field(:image_url, :string)

    timestamps()
  end

  def changeset(%__MODULE__{} = user, params \\ %{}) do
    user
    |> cast(params, [:email, :image_url])
    |> validate_required([:email])
    |> validate_email()
    |> unique_constraint(:email)
  end

  defp validate_email(%{valid?: false} = changeset), do: changeset

  defp validate_email(%{valid?: true} = changeset) do
    changeset
    |> get_field(:email)
    |> String.match?(@email_regex)
    |> handle_validate(changeset)
  end

  defp handle_validate(true, changeset), do: changeset
  defp handle_validate(false, chset), do: add_error(chset, :email, "invalid format")
end
