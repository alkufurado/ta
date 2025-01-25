defmodule TA.Ema do
  require Explorer.Series, as: Series

  def ema(series, period) do
    aux(series, period) |> Series.from_list()
  end

  defp aux(series, period, index \\ 0, list \\ []) do
    cond do
      index >= Series.size(series) ->
        list

      index < period ->
        ema = (series |> Series.head(period) |> Series.sum()) / period
        List.duplicate(nil, period - 1) ++ aux(series, period, period, [ema | list])

      true ->
        multiplier = 2 / (period + 1)
        value = Series.at(series, index)
        previous_ema = Enum.at(list, 0)

        ema =
          if is_nil(value) or is_nil(previous_ema) do
            0
          else
            previous_ema * (1 - multiplier) + value * multiplier
          end

        [previous_ema | aux(series, period, index + 1, [ema | Enum.drop(list, 2)])]
    end
  end
end
