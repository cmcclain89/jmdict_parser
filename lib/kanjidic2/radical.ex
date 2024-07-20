defmodule YomiKomi.Kanjidic2.Radical do
  import SweetXml
  defstruct [:rad_value, :rad_type]

  def new(element) when Kernel.elem(element, 1) == :rad_value do
    %__MODULE__{
      rad_value: xpath(element, ~x".///text()"s),
      rad_type: xpath(element, ~x".//attribute::rad_type"s)
    }
  end

  def parse_elements(element) when Kernel.elem(element, 1) == :radical do
    xpath(element, ~x"//rad_value"el)
    |> Enum.map(&__MODULE__.new(&1))
  end
end
