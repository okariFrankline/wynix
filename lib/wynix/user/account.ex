defmodule Wynix.User.Account do
  @moduledoc """
    Defines the Account module that holds details about a given account
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Wynix.User.Utils
  alias Wynix.Utilities.ContactValidations, as: Validations

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts" do
    field :account_code, :string
    # an account can either be "Client" or "Practise" or "Freelance"
    field :account_type, :string
    field :email, :string
    field :full_name, :string
    field :password, :string, virtual: true
    field :password_hash, :string
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
      :account_type,
      :account_code,
      :is_active,
      :is_suspended,
      :full_name
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
      :password,
      :password_hash
    ])
    # validate required
    |> validate_required([
      :email
    ], message: "Email address is required.")
    # validate the password
    |> validate_required([
      :password
      ],
      message: "Password is required."
    )
    # ensure the full_name is given
    |> validate_required([
      :full_name
    ], message: "Account Full Name is required.")
    # ensure the password is atleast 8 characters
    |> validate_length(
      :password,
      max_length: 100,
      min_length: 8,
      message: "Password must be atleast 8 characters long"
    )
    # validate the email format
    |> Validations.validate_email_format()
    # put the account code
    |> Utils.put_account_code()
    # hash the password
    |> Utils.hash_password()
    # ensure the email is unique
    |> unique_constraint(
      :email,
      message: "The email #{attrs.email} is already taken."
    )

  end # end of the registration changeset

  @spec password_changeset(
          {map, map} | %{:__struct__ => atom | %{__changeset__: map}, optional(atom) => any},
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  @doc false
  def password_changeset(account, attrs) do
    changeset(account, attrs)
    # cast the password
    |> cast(attrs, [
      :password
    ])
    # ensure the new passsword is given
    |> validate_required([
      :password
    ], message: "New password must be given.")
    # ensure the password is atleast 8 characters long
    |> validate_length(
      :password,
      min_length: 8,
      max_length: 100,
      message: "New password must be 8 characters long."
    )
    # ensure the passwords are not duplicate
    |> Utils.validate_duplicate_current_email()
  end # end of the passsword_changeset function

  @doc false
  def email_changeset(account, attrs) do
    changeset(account, attrs)
    # ensure the eamil is given
    |> validate_required([
      :email
    ], message: "New email address is required.")
    # ensure the email address is valid
    |> Validations.validate_email_format()
    # ensure the email is unique
    |> unique_constraint(
      :email,
      message: "The email #{attrs.email} is already taken."
    )
  end # end of the email_changeset

end # end of the module defintion
