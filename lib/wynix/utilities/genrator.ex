defmodule Wynix.Utilities.Random do
  @moduledoc """
    Generates a random string to be used in the generation the delimitation
    of the Orders, Quotations, and Account codes
  """
  @bytes Enum.concat([?a..?z, ?A..?Z, ?0..?9]) |> List.to_string

  @spec random(integer) :: bitstring
  def random(length) do
    for _ <- 1..length, into: <<>> do
      index = :rand.uniform(byte_size(@bytes)) - 1
      <<:binary.at(@bytes, index)>>
    end
  end

end # end of the wynix module
