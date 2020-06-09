defmodule Wynix.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :email, :string
      add :full_name, :string
      add :password_hash, :string
      add :account_type, :string
      add :account_code, :string
      add :is_active, :boolean, default: true
      add :is_suspended, :boolean, deafult: false

      timestamps()
    end

    create unique_index(:accounts, [:account_code])
    create index(:accounts, [:is_suspended])
    create index(:accounts, [:is_active])
    create index(:accounts, [:full_name])
    create index(:accounts, [:account_tyoe])

  end
end
