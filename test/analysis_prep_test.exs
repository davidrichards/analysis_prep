defmodule AnalysisPrepTest do
  use ExUnit.Case

  import Statistics
  import AnalysisPrep

  doctest AnalysisPrep
  doctest AnalysisPrep.Encode
  doctest AnalysisPrep.Frequency
  doctest AnalysisPrep.Normalize
  doctest AnalysisPrep.Probability
  doctest AnalysisPrep.Scale
  doctest AnalysisPrep.Summary
end
