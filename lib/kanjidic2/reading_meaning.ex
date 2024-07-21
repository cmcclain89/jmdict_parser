defmodule YomiKomi.Kanjidic2.ReadingMeaning do
  import SweetXml

  alias YomiKomi.Kanjidic2.{Meaning, Reading}
  defstruct rmgroup: [], nanori: []

  def new(nil), do: nil

  def new(element) when Kernel.elem(element, 1) == :reading_meaning do
    %__MODULE__{
      rmgroup: xpath(element, ~x"//rmgroup"el) |> Enum.map(&parse_rmgroup/1),
      nanori: xpath(element, ~x".//nanori/text()"ls)
    }
  end

  def parse_rmgroup(element) when Kernel.elem(element, 1) == :rmgroup do
    %{
      reading: xpath(element, ~x"///reading"el) |> Enum.map(&Reading.new/1),
      meaning: xpath(element, ~x"///meaning"el) |> Enum.map(&Meaning.new/1)
    }
  end
end
