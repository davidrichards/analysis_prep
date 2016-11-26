defmodule AnalysisPrep.Probability do
  @moduledoc """
  Provide basic probability functions
  """

  import Statistics.Math, only: [factorial: 1, floor: 1]
  import AnalysisPrep, only: [is_range: 1, sum_map: 1]

  @doc """
  The probability of an event, given a sample space of equiprobable outcomes.
  The event can be either a set of outcomes, or a predicate (true for outcomes in the event).

  Examples

    iex> p([1,2], [1,2,3,4])
    Ratio.new(2,4)

    iex> p([1,2,3], 2..5)
    Ratio.new(2,4)

    iex> p([:a], %{a: 1, b: 2})
    Ratio.new(1,3)

  """
  def p(predicate, space) when is_function(predicate) do
    event = such_that(predicate, space)
    p(event, space)
  end
  def p(event, space) do
    if !is_range(space) && is_map(space) do
      space
      |> Enum.filter(fn({k, _}) ->
        Enum.member?(event, k)
      end)
      |> Enum.into(%{})
      |> sum_map
      |> Ratio.new(sum_map(space))
    else
      event = MapSet.new(event)
      space = MapSet.new(space)
      numerator = MapSet.intersection(event, space) |> MapSet.size
      denominator = MapSet.size(space)
      Ratio.new(numerator, denominator)
    end
  end

  @doc """
  Filter a data series by a predicate.

  Examples

      iex> such_that(fn(e) -> rem(e, 2) == 0 end, 1..10) |> Enum.to_list
      [2,4,6,8,10]

      iex> such_that(& &1 == :a, %{a: 1, b: 2})
      %{a: 1}

  """
  def such_that(predicate, space) do
    cond do
      is_range(space) -> such_that(predicate, space, :enumerable)
        space |> Enum.filter(& predicate.(&1)) |> MapSet.new
      is_map(space) -> such_that(predicate, space, :map)
      true -> such_that(predicate, space, :enumerable)
    end
  end
  def such_that(predicate, space, :enumerable) do
    space |> Enum.filter(& predicate.(&1)) |> MapSet.new
  end
  def such_that(predicate, space, :map) do
    space
    |> Enum.filter(fn({k, _}) ->
      predicate.(k)
    end)
    |> Enum.into(%{})
  end

  @doc """
  Joint probability from two map-like distributions.

  Example

      iex> joint(%{a: 0.3, b: 0.6}, %{x: 0.25, y: 0.75})
      %{{:a, :x} => 0.075, {:a, :y} => 0.22499999999999998, {:b, :x} => 0.15, {:b, :y} => 0.44999999999999996}

  """
  def joint(a, b) do
    Enum.flat_map(a, fn({k1, v1}) -> 
      Enum.map(b, fn({k2, v2}) ->
        {{k1, k2}, v1 * v2}
      end)
    end)
    |> Enum.into(%{})
    
  end

  @doc """
  The cross produce of all items from two collections.
  Uses arrays for each pair.

  Examples

      iex> cross(1..2, 4..5)
      [[1,4],[1,5],[2,4],[2,5]]

  """
  def cross(a, b) do
    Enum.flat_map(a, fn(e) ->
      Enum.map(b, fn(f) -> [e, f] end)
    end)
  end

  @doc """
  Get combinations of n items at a time, returned as combinations

  Examples

    iex> combinations(1..3)
    [[3,2], [3,1], [2,1]]

    iex> combinations(1..4, 3)
    [[4,3,2], [4,3,1], [4,2,1], [3,2,1]]

  """
  def combinations(list, n \\ 2) do
    list |> Combination.combine(n)
  end


  @doc """
  Generate samples from a series

  Examples

      iex> sample(0..5) <= 5
      true

      iex> sample [42]
      42

      iex> length sample(0..5, 2)
      2

      iex> sample []
      nil

      iex> sample 1..5, 0
      nil

  """
  def sample(list, n \\ 1)
  def sample([], _), do: nil
  def sample(_, 0), do: nil
  def sample(list, 1) do
    set_seed!
    hd get_sample(list, 1)
  end
  def sample(list, n) do
    set_seed!
    get_sample(list, n)
  end

  defp get_sample(list, n) do
  Enum.map(1..n, fn(_) -> Enum.random(list) end)
  end

  defp set_seed! do
    # << i1 :: unsigned-integer-32, i2 :: unsigned-integer-32, i3 :: unsigned-integer-32>> = :crypto.strong_rand_bytes(12)
    # :rand.seed(:exsplus, {i1, i2, i3})
  end

  @doc """
  The number of ways to choose c items from a list of n items

  Examples
      iex> choose(3,2)
      3.0

      iex> choose(12,4)
      495.0

      iex> choose(3,0)
      0

  """
  @spec choose(integer,integer) :: integer
  def choose(_, 0), do: 0
  def choose(n, c) do
    floor(factorial(n) / (factorial(n - c) * factorial(c)))
  end
end

