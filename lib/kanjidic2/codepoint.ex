defmodule YomiKomi.Kanjidic2.Codepoint do
  import SweetXml
  defstruct [:cp_value, :cp_type]

  def new(element) when Kernel.elem(element, 1) == :cp_value do
    %__MODULE__{
      cp_value: xpath(element, ~x".//cp_value/text()"s),
      cp_type: xpath(element, ~x".//attribute::cp_type"s)
    }
  end

  def parse_elements(element) when Kernel.elem(element, 1) == :codepoint do
    xpath(element, ~x"//cp_value"el)
    |> Enum.map(&__MODULE__.new(&1))
  end
end
