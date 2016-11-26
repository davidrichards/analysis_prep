# AnalysisPrep

Support data extraction for analysis and machine learning.

In order to extract data from several systems, I've combined some of the
tools that make this easier.

* Normalize and scale a data series
* One hot or label encode a data series
* Calculate frequencies and frequency percentages
* Summarize variables with basic statistics (mean, sum, min, max, median, standard deviation, etc.)
* Estimate the correlation between variables.
* Extract probabilistic values for Markov models and other probabilistic models.
* Save data into CSV files

For now, the Doctests are the best documentation for using these features.  I'll write up some better
demonstrations soon.

## TODO:

This is a work in progress. There are several things I'd still like to add.

* Demonstrate the core features
* Extraction via Ecto
* Binning functions
* Test and expand to support GenStage and Flow
* Time series analysis

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `metrics` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:metrics, "~> 0.1.0"}]
    end
    ```

  2. Ensure `metrics` is started before your application:

    ```elixir
    def application do
      [applications: [:metrics]]
    end
    ```

