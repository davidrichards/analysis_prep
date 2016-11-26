defmodule AnalysisPrep.Summary do
  @moduledoc """
  Summarize a data series.
  
  Assume it's a continuous data series. Returns the normal kinds of analysis_prep:

  * count
  * min
  * max
  * mean
  * median
  * variance
  * standard deviation
  * sum

  If it is a categorical value, calculate the frequency of each category, as well as the frequency
  percent. Also, summarize the shape of the frequencies with the regular summary.

  Uses a struct to contain all the possible values.
  """

  defstruct count: nil, min: nil, max: nil, mean: nil, median: nil, variance: nil, stdev: nil,
    sum: nil, frequency: nil, frequency_percent: nil

  import Statistics
  import AnalysisPrep.Frequency
  import AnalysisPrep.Normalize

  @doc """

      iex> summary([1,2,3]).count
      3

      iex> summary([1,2,3]).min
      1

      iex> summary([1,2,3]).max
      3

      iex> summary([1,2,3]).mean
      2.0

      iex> summary([1,2,3]).median
      2

      iex> summary([1,2,3,4]).median
      2.5

      iex> summary([1,2,3]).variance
      0.6666666666666666

      iex> summary([1,2,3]).stdev
      0.816496580927726

      iex> summary([1,2,3]).sum
      6

      iex> summary([1,2,3], :categorical).frequency
      %{1 => 1, 2 => 1, 3 => 1}

      iex> summary([1,2,3], :categorical).frequency_percent
      %{1 => 0.3333333333333333, 2 => 0.3333333333333333, 3 => 0.3333333333333333}

  """
  def summary(list, type \\ :continuous)
  def summary(list, :continuous) do
   %AnalysisPrep.Summary{
     count: length(list),
     min: min(list),
     max: max(list),
     mean: mean(list),
     median: median(list),
     variance: variance(list),
     stdev: stdev(list),
     sum: sum(list)
   }
  end
  def summary(list, :categorical) do
    f = frequency(list)
    values = Map.values(f)
    s = sum(values)
    frequency_summary = summary(values)
    Map.merge(frequency_summary, %{frequency: f, frequency_percent: normalize(f, s)})
  end
end

