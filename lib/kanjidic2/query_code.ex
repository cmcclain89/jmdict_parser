defmodule YomiKomi.Kanjidic2.QueryCode do
  import SweetXml
  defstruct [:q_code, :qc_type, :skip_misclass]

  def new(element) when Kernel.elem(element, 1) == :q_code do
    %__MODULE__{
      q_code: xpath(element, ~x".///text()"s),
      qc_type: xpath(element, ~x".//attribute::qc_type"s),
      skip_misclass: xpath(element, ~x".//attribute::skip_misclass"os) |> parse_skip_misclass()
    }
  end

  def parse_elements(element) when Kernel.elem(element, 1) == :query_code do
    xpath(element, ~x"//q_code"el)
    |> Enum.map(&__MODULE__.new(&1))
  end

  def parse_elements(nil), do: []

  def parse_skip_misclass(""), do: nil
  def parse_skip_misclass(val), do: val
end
