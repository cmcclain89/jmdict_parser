defmodule YomiKomi.Kanjidic2.DicNumber do
  import SweetXml
  defstruct [:dic_ref, :dr_type, m_vol: nil, m_page: nil]

  def new(element) when Kernel.elem(element, 1) == :dic_ref do
    %__MODULE__{
      dic_ref: xpath(element, ~x".///text()"s),
      dr_type: xpath(element, ~x".//attribute::dr_type"s),
      m_vol: xpath(element, ~x".//attribute::m_vol"oi),
      m_page: xpath(element, ~x".//attribute::m_page"os) |> parse_m_page()
    }
  end

  def parse_elements(element) when Kernel.elem(element, 1) == :dic_number do
    xpath(element, ~x"//dic_ref"el)
    |> Enum.map(&__MODULE__.new(&1))
  end

  def parse_elements(nil), do: []

  def parse_m_page(""), do: nil
  def parse_m_page(val), do: val
end
