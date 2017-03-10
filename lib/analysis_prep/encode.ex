defmodule AnalysisPrep.Encode do
  @moduledoc """
  Encode series with one-hot or label encoding.
  """

  @doc """
  Produce a hot key encoding, a column for every value with a 0 or 1 in each cell.

  Examples:

      iex> one_hot ["a", "b", "a"]
      [["a", "b"], [1,0], [0,1], [1,0]]

      iex> one_hot []
      []

  """
  @spec one_hot(list) :: list
  def one_hot([]), do: []
  def one_hot(list) do
    keys = get_keys(list)
    limit = length(keys) - 1
    values = list
    |> Enum.map(fn(e) ->
      Enum.map((0..limit), fn(i) ->
        if Enum.at(keys, i) == e, do: 1, else: 0
      end)
    end)
    [keys|values]
  end

  @doc """
  Produce a label encoding, a sorted set of known labels, returning the index of that label.

  Examples:

      iex> label ["b", "a", "b", "c"]
      [1,0,1,2]

      iex> label []
      []

  """
  @spec label(list) :: list
  def label([]), do: []
  def label(list) do
    keys = get_keys(list)
    Enum.map(list, fn(e) ->
      Enum.find_index(keys, & &1 == e)
    end)
  end

  defp get_keys(list) do
    list |> Enum.uniq |> Enum.sort
  end
end

