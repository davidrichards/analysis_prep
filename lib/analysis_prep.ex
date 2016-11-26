defmodule AnalysisPrep do
  @moduledoc """
  Analysis preparation for data series.

  Incorporates the excellent elixir-statistics with the types of things needed for exploratory
  analysis and preparing to use data in machine learning algorithms.
  """

  alias AnalysisPrep.Encode
  alias AnalysisPrep.Frequency
  alias AnalysisPrep.Normalize
  alias AnalysisPrep.Probability
  alias AnalysisPrep.Scale
  alias AnalysisPrep.Summary

  import Statistics

  use Ratio, override_math: false

  @doc """
  Calculate the precision from a series of values.

  Precision is the inverse of the variance, used in some Bayesian libraries for normal distributions
  instead of standard deviation.

  Examples

      iex> variance([1,2,3,4])
      1.25

      iex> precision([1,2,3,4])
      1 / 1.25

      iex> precision([1,2,3,4])
      0.8

      iex> precision([])
      []

  """
  @spec precision(list) :: list
  def precision([]), do: []
  def precision(list) do
    1 / variance(list)
  end

  def summary(list, type \\ :continuous), do: Summary.summary(list, type)
  def one_hot(list), do: Encode.one_hot(list)
  def label(list), do: Encode.label(list)
  def frequency(list), do: Frequency.frequency(list)
  def normalize(object, max \\ nil), do: Normalize.normalize(object, max)
  def scale(list, opts \\ []), do: Scale.scale(list, opts)
  def p(event, space), do: Probability.p(event, space)
  def such_that(predicate, space), do: Probability.such_that(predicate, space)
  def joint(a, b), do: Probability.joint(a, b)
  def cross(a, b), do: Probability.cross(a, b)
  def combinations(list, n \\ 2), do: Probability.combinations(list, n)
  def sample(list, n \\ 1), do: Probability.sample(list, n)
  def choose(n, c), do: Probability.choose(n, c)

  @doc """                                                                  
  values of a map or defer to Statistics.sum                            

  Examples

      iex> sum_map(%{a: 1, b: 2})
      3

  """                                                                       
  def sum_map(map) do                                                        
    map                                                                
    |> Map.values                                                         
    |> Statistics.sum                                                     
  end

  @doc """
  Save an array of arrays to a file

  Examples

      iex> save("/tmp/foo.csv", [["a","b"],[1,2],[3,4]]) && File.rm("/tmp/foo.csv")
      :ok

  """
  def save(filename, data) do
    file = File.open!(filename, [:write, :utf8])
    data |> CSV.encode |> Enum.each(&IO.write(file, &1))
  end

  @doc """
  Test for a range.

  A range is implemented with a struct, but behaves differently enough we need to restrict
  our program flow to handle things correctly.

  Examples

      iex> is_range 1..5
      true

  """
  def is_range(object) do
    try do
      Map.keys(object) == [:__struct__, :first, :last]
    rescue
      BadMapError -> false
      _ -> false
    end
  end
end

