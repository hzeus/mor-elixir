defmodule Sequence do

  @doc """
  An imperformant implentation of fibonacci numbers

  [ 36, 37, 38, 39, 39, 39, 39, 39 ] |> Sequence.map( Sequence.fib(&1) )
  [ 36, 37, 38, 39, 39, 39, 39, 39 ] |> Sequence.pmap( Sequence.fib(&1) )

  end

  iex> Sequence.fib(10)
  55
  """
  def fib(0), do: 0
  def fib(1), do: 1
  def fib(n), do: fib(n-1) + fib(n-2)

  @doc """
  Maps a collection to another collection applying the given function to each element.

    iex> Sequence.map( [ 1, 2, 3 ], &1 * &1)
    [ 1, 4, 9 ]

    iex> Sequence.map( [], &1 * &1)
    [ ]
  """
  def map([], _fun), do: []
  def map([h|t], fun), do: [ fun.(h) | map(t, fun) ]

  @doc """
  Maps a collection to another collection applying the given function to each element.

    iex> Sequence.pmap( [ 1, 2, 3 ], &1 * &1)
    [ 1, 4, 9 ]

    iex> Sequence.pmap( [], &1 * &1)
    [ ]
  """
  def pmap(collection, fun) do
    collection |> spawn_children(fun) |> collect_results
  end

  """
  Spawns children for each element in the collection, returns a list of pids
  """
  defp spawn_children(collection, fun) do
    collection |> map( spawn_child(&1, fun) )
  end

  defp spawn_child(elem, fun) do
    spawn Sequence, :child_execution, [ self, elem, fun ]
  end

  defp collect_results(pids) do
    pids |> map(result_for_pid(&1))
  end

  defp result_for_pid(pid) do
    receive do
      { ^pid, value } -> value
    end
  end

  def child_execution(parent_pid, elem, fun) do
    parent_pid <- { self, fun.(elem) }
  end

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
