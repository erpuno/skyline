defmodule Skyline.Mixfile do
  use Mix.Project
  def project do [ app: :skyline, version: "1.0.0", deps: deps ] end
  defp deps do [ {:n2o_elixir, github: "synrc/n2o_elixir"} ] end
end
