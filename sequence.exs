defmodule Sequence do

  @doc """
  Maps a collection to another collection applying the given function to each element.

    iex> Sequence.map( [ 1, 2, 3 ], &1 * &1)
    [ 1, 4, 9 ]

    iex> Sequence.map( [], &1 * &1)
    [ ]
  """
  def map([], _fun), do: []
  def map([h|t], fun), do: [ fun.(h) | map(t, fun) ]

end


ExUnit.start

defmodule SequenceTest do
  use ExUnit.Case
  doctest Sequence
end
