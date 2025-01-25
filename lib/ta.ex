defmodule TA do
  require Explorer.Series, as: Series
  require Explorer.DataFrame, as: DF

  def sma(series, period), do: TA.Sma.sma(series, period)
  def ema(series, period), do: TA.Ema.ema(series, period)
  def smma(series, period), do: TA.Smma.smma(series, period)
  def zlema(series, period), do: TA.Zlema.zlema(series, period)

  def rsi(series, period \\ 14) do
    avg = &smma(&1, period)
    previous = Series.shift(series, 1)
    change = Series.subtract(series, previous)
    gains = Series.transform(change, &if(&1 <= 0, do: 0, else: &1))
    losses = Series.transform(change, &if(&1 >= 0, do: 0, else: -&1))
    avg_gains = avg.(gains)
    avg_losses = avg.(losses)
    rs = Series.divide(avg_gains, avg_losses)

    Series.transform(rs, fn value ->
      cond do
        is_nil(value) -> nil
        value == :infinity -> 100
        true -> 100 - 100 / (1 + value)
      end
    end)
  end

  def stochastic_rsi(series, period \\ 14) do
    smoothK = 3
    smoothD = 3
    rsi = rsi(series, period)
    rsi_max = Series.window_max(rsi, period)
    rsi_min = Series.window_min(rsi, period)

    k =
      Series.subtract(rsi, rsi_min)
      |> Series.divide(Series.subtract(rsi_max, rsi_min))
      |> Series.multiply(100)
      |> sma(smoothK)

    d = sma(k, smoothD)
    DF.new(%{stochastic_k: k, stochastic_d: d})
  end

  def macd(series) do
    line = Series.subtract(ema(series, 12), ema(series, 26))
    signal = ema(line, 9)
    histogram = Series.subtract(line, signal)
    DF.new(%{macd_line: line, macd_signal: signal, macd_histogram: histogram})
  end

  @spec imacd(Explorer.Series.t(), Explorer.Series.t(), Explorer.Series.t()) ::
          Explorer.DataFrame.t()
  def imacd(high, low, close) do
    hlc3 = Series.add(high, low) |> Series.add(close) |> Series.divide(3)
    src = hlc3
    length_ma = 34
    length_signal = 9
    hi = smma(high, length_ma)
    lo = smma(low, length_ma)
    mi = zlema(src, length_ma)

    md =
      SeriesEx.mapl_with_index([mi, hi, lo], fn [mi, hi, lo], _index ->
        cond do
          is_nil(mi) or is_nil(hi) or is_nil(lo) -> nil
          mi > hi -> mi - hi
          mi < lo -> mi - lo
          true -> 0
        end
      end)

    sb = sma(md, length_signal)
    sh = Series.subtract(md, sb)
    DF.new(%{src: src, hi: hi, lo: lo, mi: mi, md: md, sb: sb, sh: sh})
  end

  def imacd(df) when is_struct(df, DF) do
    imacd(df["high"], df["low"], df["close"])
  end
end
