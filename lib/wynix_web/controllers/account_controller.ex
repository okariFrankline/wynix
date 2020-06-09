defmodule WynixWeb.AccountController do
  use WynixWeb, :controller

  alias Wynix.User
  alias Wynix.User.Account

  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, _params) do
    accounts = User.list_accounts()
    render(conn, "index.html", accounts: accounts)
  end

  @spec new(Plug.Conn.t(), any) :: Plug.Conn.t()
  def new(conn, _params) do
    changeset = User.change_account(%Account{})
    render(conn, "new.html", changeset: changeset)
  end

  @spec create(Plug.Conn.t(), map) :: Plug.Conn.t()
  def create(conn, %{"account" => account_params}) do
    case User.create_account(account_params) do
      {:ok, account} ->
        conn
        |> put_flash(:info, "Account created successfully.")
        |> redirect(to: Routes.account_path(conn, :show, account))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  @spec show(Plug.Conn.t(), map) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    account = User.get_account!(id)
    render(conn, "show.html", account: account)
  end

  @spec edit(Plug.Conn.t(), map) :: Plug.Conn.t()
  def edit(conn, %{"id" => id}) do
    account = User.get_account!(id)
    changeset = User.change_account(account)
    render(conn, "edit.html", account: account, changeset: changeset)
  end

  @spec update(Plug.Conn.t(), map) :: Plug.Conn.t()
  def update(conn, %{"id" => id, "account" => account_params}) do
    account = User.get_account!(id)

    case User.update_account(account, account_params) do
      {:ok, account} ->
        conn
        |> put_flash(:info, "Account updated successfully.")
        |> redirect(to: Routes.account_path(conn, :show, account))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", account: account, changeset: changeset)
    end
  end

  @spec delete(Plug.Conn.t(), map) :: Plug.Conn.t()
  def delete(conn, %{"id" => id}) do
    account = User.get_account!(id)
    {:ok, _account} = User.delete_account(account)

    conn
    |> put_flash(:info, "Account deleted successfully.")
    |> redirect(to: Routes.account_path(conn, :index))
  end
end
