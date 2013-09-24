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

  test 'a child executes a function and sends the result back' do
    #child_pid == self
    Sequence.child_execution( self, 3, &1 * &1 )
    assert_receive { self, 9 }

    #with a real child
    child = spawn Sequence, :child_execution, [ self, 4, &1 * &1 ]
    assert_receive { child, 16 }
  end

end
