defmodule AnalysisPrep.Frequency do
  @moduledoc """
  Extract frequencies from list.
  """

  @doc """
  Extract the frequencies from a list. Used for summarizing categorical data.

  Examples

      iex> frequency([])
      %{}

      iex> frequency([:a, :b, :a])
      %{a: 2, b: 1}

      iex> frequency([:a, :b], %{a: 5})
      %{a: 6, b: 1}

  """
  def frequency(list, base \\ %{})
  def frequency([], _), do: %{}
  def frequency(list, base) do
    Enum.reduce(list, base, fn(e, acc) ->
      found = Map.get(acc, e, 0)
      Map.put(acc, e, found + 1)
    end)
  end
end

