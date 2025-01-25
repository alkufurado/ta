defmodule SeriesEx do
  require Explorer.Series, as: Series

  @spec map_with_index(Explorer.Series.t(), any()) :: Explorer.Series.t()
  def map_with_index(series, func) do
    0..(Series.size(series) - 1)
    |> Enum.to_list()
    |> Enum.map(fn index -> func.(Series.at(series, index), index) end)
    |> Series.from_list()
  end

  @spec mapl_with_index(list(Explorer.Series.t()), any()) :: Explorer.Series.t()
  def mapl_with_index(series, func) do
    first_series = hd(series)

    0..(Series.size(first_series) - 1)
    |> Enum.to_list()
    |> Enum.map(fn index -> func.(Enum.map(series, &Series.at(&1, index)), index) end)
    |> Series.from_list()
  end
end
