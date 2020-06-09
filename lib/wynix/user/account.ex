defmodule Wynix.User.Account do
  @moduledoc """
    Defines the Account module that holds details about a given account
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts" do
    field :account_code, :string
    field :account_type, :string
    field :email, :string
    field :password, :string
    field :password_hash, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [
      :email,
      :password,
      :password_hash,
      :account_type,
      :account_code,
      :username
    ])
    |> validate_required([
      :email,
      :password,
      :account_code
    ])
  end

  @doc false
  def registration_changeset(account, attrs) do
    changeset(account, attrs)
    # ensure the password is given
    |> cast(attrs, [
      :email,
      :password,
      :password_confirmation
    ])
    # validate required
    |> validate_required([
      :email
    ], message: "Your email address is required.")
    # validate the password
    |> validate_required([
      :password
      ],
      message: "Your password must br given"
    )
    # ensure the password is atleast 8 characters
    |> validate_length(:password, max_length: 100, min_length: 8, message: "Password must be atleast 8 characters long")
    # ensure passwords are a match
    |> validate_confirmation(:password_confirmation, message: "Your passwords do not match")
    # ensure the email is unique
    |> unique_constraint(:email, message: "The email #{attrs.email} is already taken")
    # generate a unique account code
    |> put_account_code()
    # generate the username for the user
    |> put_username()
    # hash the password
    |> hash_password()
  end # end of the registration changeset

  
end
