defmodule AnalysisPrep.Mixfile do
  use Mix.Project

  def project do
    [app: :analysis_prep,
     description: "Analysis preparation for data series for machine learning and other analysis.",
     version: File.read!("VERSION") |> String.strip,
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     package: package]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:combination, ">= 0.0.2"},
      {:csv, "~> 1.4.2"}, 
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:gen_stage, "~> 0.4"},
      {:mix_test_watch, "~> 0.2", only: :test},
      {:ratio, "~> 1.0.0"},
      {:statistics, "~> 0.4.0"},
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*", "VERSION"],
      maintainers: ["David Richards"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/davidrichards/analysis_prep"}
    ]
  end
end
