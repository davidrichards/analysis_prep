defmodule AnalysisPrep.Scale do
  @moduledoc """
  Scale a numeric sequence to a mean 0, std 1 series.
  """

  import Statistics
  import Statistics.Math

  @doc """
  Scale a numeric series to a new mean and standard deviation, typically 0 and 1.
  This is used for machine learning algorithms such as deep learning where the inputs
  need to be roughly uniform.

  Examples

      iex> scale([1,2,3,4])
      [-1.3416407864998738, -0.4472135954999579, 0.4472135954999579, 1.3416407864998738]

      iex> mean([1,2,3,4])
      2.5

      iex> mean(scale([1,2,3,4]))
      0.0

      iex> variance([1,2,3,4])
      1.25

      iex> variance(scale([1,2,3,4]))
      1.0

      iex> scale([])
      []

      iex> mean scale([1,2,3,4], mu: 2.0)
      2.0

      iex> variance scale([1,2,3,4], sigma: 2.0)
      1.9999999999999998

      iex> variance scale([1,2,3,4], mu: 42, sigma: 2.0)
      2.000000000000003

  """
  def scale([]), do: []
  def scale(list, opts \\ []) do
    mu2 = Keyword.get(opts, :mu, 0.0)
    sigma2 = Keyword.get(opts, :sigma, 1.0)
    mu = mean(list)
    sigma = stdev(list)
    Enum.map(list, fn(e) ->
      mu2 + (e - mu) * (sqrt(sigma2) / sigma)
    end)
  end
end

