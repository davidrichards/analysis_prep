defmodule AnalysisPrep.Normalize do
  @moduledoc """
  Reduce a numeric sequence to max 1.0
  """

  @doc """
  Takes a list or map-like structure and normalizes it.

  Allows for a maximum number so that normalize can produce percent of total instead of percent
  of max. E.g. normalize([1,2,3], 6)

  Examples

      iex> normalize([])
      []

      iex> normalize([1,2])
      [0.5, 1.0]

      iex> normalize([1,2,3], 6)
      [0.16666666666666666, 0.3333333333333333, 0.5]

      iex> normalize(%{a: 1, b: 2, c: 3})
      %{a: 0.3333333333333333, b: 0.6666666666666666, c: 1.0}

      iex> normalize(%{a: 1, b: 2, c: 3, d: 4}, 10)
      %{a: 0.1, b: 0.2, c: 0.3, d: 0.4}

  """
  def normalize(map, max \\ nil)
  def normalize([], _), do: []
  def normalize(map, max) when is_map(map) do
    keys = Map.keys(map)
    values = normalize(Map.values(map), max)
    zipped = Enum.zip(keys, values)
    Enum.into(zipped, %{})
  end
  def normalize(list, max) do
    max = max || Enum.max(list)
    Enum.map(list, & &1 / max)
  end
end

