defmodule TA.Smma do
  require Explorer.Series, as: Series

  def smma(series, period) do
    aux(series, period) |> Series.from_list()
  end

  defp aux(series, period, index \\ 0, list \\ []) do
    cond do
      index >= Series.size(series) ->
        list

      index < period ->
        [nil | aux(series, period, index + 1, list)]

      index == period ->
        aux(series, period, index + 1, [
          (series |> Series.head(period) |> Series.sum()) / period | list
        ])

      true ->
        [
          Enum.at(list, 0)
          | aux(series, period, index + 1, [
              (Enum.at(list, 0) * (period - 1) + Series.at(series, index)) / period
              | Enum.drop(list, 2)
            ])
        ]
    end
  end
end
