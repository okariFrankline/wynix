defmodule Wynix.UserTest do
  use Wynix.DataCase

  alias Wynix.User

  describe "accounts" do
    alias Wynix.User.Account

    @valid_attrs %{account_code: "some account_code", account_type: "some account_type", email: "some email", password: "some password", password_hash: "some password_hash", username: "some username"}
    @update_attrs %{account_code: "some updated account_code", account_type: "some updated account_type", email: "some updated email", password: "some updated password", password_hash: "some updated password_hash", username: "some updated username"}
    @invalid_attrs %{account_code: nil, account_type: nil, email: nil, password: nil, password_hash: nil, username: nil}

    def account_fixture(attrs \\ %{}) do
      {:ok, account} =
        attrs
        |> Enum.into(@valid_attrs)
        |> User.create_account()

      account
    end

    test "list_accounts/0 returns all accounts" do
      account = account_fixture()
      assert User.list_accounts() == [account]
    end

    test "get_account!/1 returns the account with given id" do
      account = account_fixture()
      assert User.get_account!(account.id) == account
    end

    test "create_account/1 with valid data creates a account" do
      assert {:ok, %Account{} = account} = User.create_account(@valid_attrs)
      assert account.account_code == "some account_code"
      assert account.account_type == "some account_type"
      assert account.email == "some email"
      assert account.password == "some password"
      assert account.password_hash == "some password_hash"
      assert account.username == "some username"
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = User.create_account(@invalid_attrs)
    end

    test "update_account/2 with valid data updates the account" do
      account = account_fixture()
      assert {:ok, %Account{} = account} = User.update_account(account, @update_attrs)
      assert account.account_code == "some updated account_code"
      assert account.account_type == "some updated account_type"
      assert account.email == "some updated email"
      assert account.password == "some updated password"
      assert account.password_hash == "some updated password_hash"
      assert account.username == "some updated username"
    end

    test "update_account/2 with invalid data returns error changeset" do
      account = account_fixture()
      assert {:error, %Ecto.Changeset{}} = User.update_account(account, @invalid_attrs)
      assert account == User.get_account!(account.id)
    end

    test "delete_account/1 deletes the account" do
      account = account_fixture()
      assert {:ok, %Account{}} = User.delete_account(account)
      assert_raise Ecto.NoResultsError, fn -> User.get_account!(account.id) end
    end

    test "change_account/1 returns a account changeset" do
      account = account_fixture()
      assert %Ecto.Changeset{} = User.change_account(account)
    end
  end
end
