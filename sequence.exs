defmodule Sequence do

  @doc """
  Maps a collection to another collection applying the given function to each element.

    iex> Sequence.map( [ 1, 2, 3 ], &1+&1)
    [ 1, 4, 9 ]
  """
  def map([], _fun), do: []
  def map([h|t], fun), do: [ fun.(h) | map(t, fun) ]

end


ExUnit.start

defmodule SequenceTest do
  use ExUnit.Case
  doctest Sequence

  test 'map an empty list' do
    assert [] |> Sequence.map(&1 * &1) == []
  end

  test 'map a non-empty list' do
    #assert Sequence.map( [ 1, 2, 3 ], fn x -> x * x end ) == [ 1, 4, 9 ]
    assert [ 1, 2, 3 ] |> Sequence.map(&1 * &1) == [ 1, 4, 9 ]
  end
end
