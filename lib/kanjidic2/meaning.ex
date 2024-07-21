defmodule YomiKomi.Kanjidic2.Meaning do
  import SweetXml

  defstruct [:m_value, m_lang: nil]

  def new(element) when Kernel.elem(element, 1) == :meaning do
    %__MODULE__{
      m_value: xpath(element, ~x"///text()"s),
      m_lang: xpath(element, ~x"///attribute::m_lang"os) |> parse_m_lang()
    }
  end

  def parse_m_lang(""), do: nil
  def parse_m_lang(val), do: val
end
