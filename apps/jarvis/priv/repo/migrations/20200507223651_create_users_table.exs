defmodule Jarvis.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def up do
    create table(:users, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:email, :string, null: false)
      timestamps()
    end

    create(unique_index(:users, :email))
  end

  def down do
    drop(table(:users))
  end
end
