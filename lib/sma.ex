defmodule TA.Sma do
  require Explorer.Series, as: Series

  def sma(series, period) do
    series
    |> Series.window_mean(period)
    |> Series.shift(-period + 1)
    |> Series.shift(period - 1)
  end
end
