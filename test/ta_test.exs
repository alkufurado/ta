defmodule TATest do
  use ExUnit.Case
  doctest TA

  require Explorer.Series

  setup_all do
    {:ok,
     ma_values:
       [22.27, 22.19, 22.08, 22.17, 22.18, 22.13, 22.23, 22.43, 22.24, 22.29, 22.15, 22.39] ++
         [22.38, 22.61, 23.36, 24.05, 23.75, 23.83, 23.95, 23.63, 23.82, 23.87, 23.65] ++
         [23.19, 23.10, 23.33, 22.68, 23.10, 22.40, 22.17],
     rsi_values:
       [44.34, 44.09, 44.15, 43.61, 44.33, 44.83, 45.10, 45.42, 45.84, 46.08, 45.89, 46.03] ++
         [45.61, 46.28, 46.28, 46.00, 46.03, 46.41, 46.22, 45.64, 46.21, 46.25, 45.71] ++
         [46.45, 45.78, 45.35, 44.03, 44.18, 44.22, 44.57, 43.42, 42.66, 43.13]}
  end

  test "sma", state do
    period = 10

    sma =
      state[:ma_values]
      |> Explorer.Series.from_list()
      |> TA.sma(period)
      |> Explorer.Series.round(1)

    expected_sma =
      Explorer.Series.from_list(
        [nil, nil, nil, nil, nil, nil, nil, nil, nil] ++
          [22.22, 22.21, 22.23, 22.26, 22.31, 22.42, 22.61, 22.77, 22.91, 23.08, 23.21] ++
          [23.38, 23.53, 23.65, 23.71, 23.69, 23.61, 23.51, 23.43, 23.28, 23.13]
      )
      |> Explorer.Series.round(1)

    assert Explorer.Series.all_equal(sma, expected_sma)
  end

  test "ema", state do
    period = 10

    ema =
      state[:ma_values]
      |> Explorer.Series.from_list()
      |> TA.ema(period)
      |> Explorer.Series.round(1)

    expected_ema =
      Explorer.Series.from_list(
        [nil, nil, nil, nil, nil, nil, nil, nil, nil] ++
          [22.22, 22.21, 22.24, 22.27, 22.33, 22.52, 22.80, 22.97, 23.13, 23.28, 23.34] ++
          [23.43, 23.51, 23.54, 23.47, 23.40, 23.39, 23.26, 23.23, 23.08, 22.92]
      )
      |> Explorer.Series.round(1)

    assert Explorer.Series.all_equal(ema, expected_ema)
  end

  test "rsi", state do
    period = 14

    rsi =
      state[:rsi_values]
      |> Explorer.Series.from_list()
      |> TA.rsi(period)
      |> Explorer.Series.round(2)

    expected_rsi =
      Explorer.Series.from_list(
        [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil] ++
          [70.46, 66.25, 66.48, 69.35, 66.29, 57.92, 62.88, 63.21, 56.01, 62.34, 54.67] ++
          [50.39, 40.02, 41.49, 41.9, 45.5, 37.32, 33.09, 37.79]
      )

    assert Explorer.Series.all_equal(rsi, expected_rsi)
  end
end
