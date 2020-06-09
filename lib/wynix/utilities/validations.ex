defmodule Wynix.Utilities.ContactValidations do
    @moduledoc """
        Module holds validations for contact information such as emails, and phone numbers
    """
    import Ecto.Changeset

    @doc """
        Validate Email Format validates the format of a given email is valid or not
    """
    @spec validate_email_format(Ecto.Changeset.t) :: Ecto.Changeset.t
    def validate_email_format(%Ecto.Changeset{valid?: true, changes: %{email: email}} = changeset) do
        # check the email address against the regular expresion for the email address
        case Regex.run(~r/^[\w.!#$%&’*+\-\/=?\^`{|}~]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*$/i, email) do
            # email is invalid
            nil ->
              # add an error to the changeset
              changeset
              # add the error to the changeset
              |> add_error(:email, "The email: #{email}, has an invalid format.")

            # the email is valid.
            list when list !== [] ->
                # return the changeset
                changeset
        end # end of the case for Regex.run
    end # end of validate_email_format/1
    # called if the changeset is invalid
    def validate_email_format(changeset), do: changeset

    @doc """
        Validate Phone Format validates that a phone number is valid for a given country
        Inserts the internationalized phone number into the phone field
    """
    @spec validate_phone_format(Ecto.Changeset.t) :: Ecto.Changeset.t
    def validate_phone_format(%Ecto.Changeset{valid?: true, changes: %{phone: phone, country_code: code}} = changeset) do
        # craete the phone number using ExPhoneNUmber
        {:ok, phone_number} = ExPhoneNumber.parse(phone, code)
        # check if the phone number is valid
        if ExPhoneNumber.is_valid_number?(phone_number) do
            # internationalize the number and put it in the changeset
            changeset |> put_change(:phone, ExPhoneNumber.format(phone_number, :international))
        else # the phone number is invalid
            # add an error message
            changeset |> add_error(:phone, "The phone number #{phone} has an invalid format.")
        end # end of checking the validity of the phone number
    end # end of the validate_phone_format/1
    # called if the changeset is invalid
    def validate_phone_format(changeset), do: changeset
end # end of ContactValidations module
