defmodule Wynix.User.Account do
  @moduledoc """
    Defines the Account module that holds details about a given account
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Wynix.User.Utils

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts" do
    field :account_code, :string
    # an account can either be "Client" or "Practise" or "Freelance"
    field :account_type, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :username, :string
    field :is_active, :boolean, default: true
    field :is_suspended, :boolean, default: false

    timestamps()
  end

  @doc false
  @spec changeset(
          {map, map} | %{:__struct__ => atom | %{__changeset__: map}, optional(atom) => any},
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  def changeset(account, attrs) do
    account
    |> cast(attrs, [
      :email,
      :password,
      :password_hash,
      :account_type,
      :account_code,
      :username,
      :is_active,
      :is_suspended
    ])
  end

  @doc false
  @spec registration_changeset(
          {map, map} | %{:__struct__ => atom | %{__changeset__: map}, optional(atom) => any},
          :invalid
          | %{:email => any, optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
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
      message: "Your password must be given"
    )
    # ensure the password is atleast 8 characters
    |> validate_length(
      :password,
      max_length: 100,
      min_length: 8,
      message: "Password must be atleast 8 characters long"
    )
    # generate the username for the user
    |> Utils.put_username()
    # put the account code
    |> Utils.put_account_code()
    # hash the password
    |> Utils.hash_password()
    # ensure the email is unique
    |> unique_constraint(
      :email,
      message: "The email #{attrs.email} is already taken"
    )

  end # end of the registration changeset

  # changeset for changing the username
  def username_changeset(account, attrs) do
    changeset(account, attrs)
    # ensure the username is given
    |> validate_required([:username],
      message: "The new username is already taken."
    )
    # ensure the username is unique
    |> unique_constraint(
      :username,
      message: "The username #{attrs.username} is already taken."
    )
    # ensure the username is not similar to the one given
    |> ensure_not_similar()
  end # end of username changeset

end # end of the module defintion
