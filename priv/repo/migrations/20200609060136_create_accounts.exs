defmodule Wynix.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :email, :string
      add :password, :string
      add :password_hash, :string
      add :account_type, :string
      add :account_code, :string
      add :username, :string

      timestamps()
    end

  end
end
