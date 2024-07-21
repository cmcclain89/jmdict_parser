defmodule YomiKomi.Kanjidic2.Reading do
  import SweetXml

  defstruct [:r_value, r_type: nil]

  def new(element) when Kernel.elem(element, 1) == :reading do
    %__MODULE__{
      r_value: xpath(element, ~x"///text()"s),
      r_type: xpath(element, ~x"///attribute::r_type"os) |> parse_r_type()
    }
  end

  def parse_r_type(""), do: nil
  def parse_r_type(val), do: val
end
