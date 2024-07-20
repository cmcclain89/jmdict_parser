defmodule YomiKomi.Kanjidic2.Character do
  alias YomiKomi.Kanjidic2.{Codepoint, Misc, Radical}

  defstruct [:literal, :codepoint, :radical, :misc, :dic_number, :query_code, :reading_meaning]

  def new(character) do
    %{
      literal: literal,
      codepoint: codepoint,
      radical: radical,
      misc: misc
    } = character

    %__MODULE__{
      literal: literal,
      codepoint: Codepoint.parse_elements(codepoint),
      radical: Radical.parse_elements(radical),
      misc: Misc.new(misc),
      dic_number: nil,
      query_code: nil,
      reading_meaning: nil
    }
  end
end
