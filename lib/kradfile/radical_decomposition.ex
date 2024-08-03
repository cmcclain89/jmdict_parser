defmodule YomiKomi.Kradfile.RadicalDecomposition do
  defstruct [:kanji, :radicals]

  def new(entry) do
    {kanji, radicals} = parse_entry(entry)

    %__MODULE__{
      kanji: kanji,
      radicals: radicals
    }
  end

  def parse_entry(entry) do
    entry
    |> String.split(":")
    |> then(fn [kanji | [radicals]] ->
      formatted_kanji = String.trim(kanji)

      formatted_radicals =
        String.trim(radicals)
        |> String.split(" ")
        |> Enum.map(&String.trim(&1))

      {formatted_kanji, formatted_radicals}
    end)
  end
end
