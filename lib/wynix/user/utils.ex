defmodule Wynix.User.Utils do
    @moduledoc """
        Module holds Utility functions for transforming the Accounts.User module changesets
    """
    import Ecto.Changeset
    # user struct
    alias Wynix.User.{Account}
    alias Wynix.Utilities.{Random}

    @spec put_account_code(Ecto.Changeset.t) :: Ecto.Changeset.t
    def put_account_code(%Ecto.Changeset{valid?: true, changes: %{username: username, account_type: account_type}} = changeset) do
      # generate a randome string
      rand = Random.random(10)
      # put the change to the changeset
      changeset |> put_change(:account_code, "#{account_type}-#{rand}")
    end
    # called if the changeset is invalid
    def put_account_code(changeset), do: changeset

    @doc """
        Add activation code adds an activation code to a newly created changeset
    """
    @spec add_activation_code(Ecto.Changeset.t) :: Ecto.Changeset.t
    def add_activation_code(%Ecto.Changeset{valid?: true} = changeset) do
        # generate a random six digit number and convert it to a string
        code = :rand.uniform(999999) |> Integer.to_string()
        # put the hashed in the changeset
        changeset |> put_change(:activation_code, Argon2.hash_pwd_salt(code))
    end # end of add_activation_code/1
    # called if changeset is not valid
    def add_activation_code(changeset), do: changeset

    @doc """
        Add Subscription information
        It sets the subscription date to the current date, the expiriy date to a month after todays date
    """
    @spec add_subscription(Ecto.Changeset.t) :: Ecto.Changeset.t
    def add_subscription(%Ecto.Changeset{valid?: true} = changeset) do
        # set the subscription date to the current date
        subscription = %{
            subscription_date: Timex.today(),
            subscription_length: "1 Month",
            expiry_date: Timex.shift(Timex.today(), days: 30),
            subscription_status: "Active"
        }
        # set the subscription to the changeset
        changeset |> put_change(:subscription, subscription)
    end # end of add_subscription/1
    # called if the changeset is invalid
    def add_subscription(changeset), do: changeset

    @doc """
        Hash password hashes the password of the currently new user
    """
    @spec hash_password(Ecto.Changeset.t) :: Ecto.Changeset.t
    def hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
        changeset
        # put the hashed assword
        |> change(Argon2.add_hash(password))
    end # end of the current password
    # called if the changeset is invalid
    def hash_password(changeset), do: changeset

    @doc """
        Validate duplicate current email checks the current email address and the newly entered to ensure
        that they are not similar
    """
    @spec validate_duplicate_current_email(Ecto.Changeset.t) :: Ecto.Changeset.t
    def validate_duplicate_current_email(%Ecto.Changeset{valid?: true, changes: %{email: new_email}, data: %Account{email: current_email}} = changeset) do
        # check if emails are similar
        if current_email === new_email do
            # add error message to the changeset
            changeset |> add_error(:email, "The new email: #{new_email} and the current email in use are similar.")
        # the emails are not similar
        else
            # return the changeset as is
            changeset |> put_change(:email, new_email)
        end # enf of if
    end # end of validate_duplicate_current_email/1
    # called if the changeset is invalid
    def validate_duplicate_current_email(changeset), do: changeset

    @doc """
        Validate duplicate current email checks the current password and the newly entered to ensure
        that they are not similar
    """
    @spec validate_duplicate_current_password(Ecto.Changeset.t) :: Ecto.Changeset.t
    def validate_duplicate_current_password(%Ecto.Changeset{valid?: true, changes: %{password: new_password}, data: %Account{password_hash: hash}} = changeset) do
        # check if passwords are similar
        if Argon2.verify_pass(hash, new_password) do
            # add error message to the changeset
            changeset |> add_error(:password, "The new passsword: #{new_password} and the current password in use are similar.")
        # the emails are not similar
        else
            # hash the new password and put it in the changeset
            changeset |> put_change(:password_hash, Argon2.add_hash(new_password))
        end # enf of if
    end # end of validate_duplicate_current_password/1
    # called if the changeset is invalid
    def validate_duplicate_current_password(changeset), do: changeset

end # end of Accounts.Utils module
