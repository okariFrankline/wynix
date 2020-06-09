defmodule Wynix.User.Utils do
  @moduledoc """
  Defines utility functions to be used by the User context
  """
  import Ecto.Changeset

  @doc false
  def put_account_code(%Ecto.Changeset{valid?: true} = changeset) do
    changeset |> put_change(:account_code, UUID.uuid4())
  end
  # called if the changeset is not valid
  def put_account_code(changeset), do: changeset

  @doc false
  def put_password_hash() do

  end
  # called when the changeset is not valid
end # end of the utils module
