defmodule OnlineOpsWeb.Schema.Scalars do
  @moduledoc false

  use Absinthe.Schema.Notation

  @desc """
  This scalar type represents time values provided in the ISOz datetime format
  (that is, the ISO 8601 format without the timezone offset, e.g.,
  "2015-06-24T04:50:34Z").
  """
  scalar :time do
    parse(&Timex.parse(&1.value, "{ISO:Extended:Z}"))
    serialize(&Timex.format!(&1, "{ISO:Extended:Z}"))
  end

  @desc """
  This scalar type represents time values as a Unix timestamp (in milliseconds).
  """
  scalar :timestamp do
    parse(fn %{value: value} ->
      {:ok, Timex.from_unix(value, :millisecond)}
    end)

    serialize(fn time ->
      DateTime.to_unix(Timex.to_datetime(time), :millisecond)
    end)
  end
end
