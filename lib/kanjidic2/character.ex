defmodule YomiKomi.Kanjidic2.Character do
  alias YomiKomi.Kanjidic2.{Codepoint, DicNumber, Misc, QueryCode, Radical, ReadingMeaning}

  defstruct [:literal, :codepoint, :radical, :misc, :dic_number, :query_code, :reading_meaning]

  def new(character) do
    %{
      literal: literal,
      codepoint: codepoint,
      radical: radical,
      misc: misc,
      dic_number: dic_number,
      query_code: query_code,
      reading_meaning: reading_meaning
    } = character

    %__MODULE__{
      literal: literal,
      codepoint: Codepoint.parse_elements(codepoint),
      radical: Radical.parse_elements(radical),
      misc: Misc.new(misc),
      dic_number: DicNumber.parse_elements(dic_number),
      query_code: QueryCode.parse_elements(query_code),
      reading_meaning: ReadingMeaning.new(reading_meaning)
    }
  end
end
