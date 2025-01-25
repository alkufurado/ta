defmodule TA.Zlema do
  require Explorer.Series, as: Series
  import TA.Ema

  def zlema(series, period) do
    ema1 = ema(series, period)
    ema2 = ema(ema1, period)
    change = Series.subtract(ema1, ema2)
    Series.add(ema1, change)
  end
end
