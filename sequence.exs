ExUnit.start

defmodule SequenceTest do
  use ExUnit.Case

  test 'map an empty list' do
    assert [] |> Sequence.map(&1 * &1) == []
  end

  test 'map a non-empty list' do
    #assert Sequence.map( [ 1, 2, 3 ], fn x -> x * x end ) == [ 1, 4, 9 ]
    assert [ 1, 2, 3 ] |> Sequence.map(&1 * &1) == [ 1, 4, 9 ]
  end
end
