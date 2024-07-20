defmodule YomiKomi.Kanjidic2.Misc do
  import SweetXml
  defstruct stroke_count: [], variant: [], rad_name: [], grade: nil, freq: nil, jlpt: nil

  def new(element) when Kernel.elem(element, 1) == :misc do
    %__MODULE__{
      stroke_count: xpath(element, ~x"//stroke_count/text()"li),
      variant: xpath(element, ~x"//variant"el) |> Enum.map(&parse_variant/1),
      rad_name: xpath(element, ~x"//rad_name/text()"l),
      grade: xpath(element, ~x"//grade/text()"oi),
      freq: xpath(element, ~x"//freq/text()"oi),
      jlpt: xpath(element, ~x"//jlpt/text()"oi)
    }
  end

  def parse_variant(variant) do
    var = xpath(variant, ~x".//text()"s)
    var_type = xpath(variant, ~x".//attribute::var_type"s)

    %{
      variant: var,
      var_type: var_type
    }
  end
end
