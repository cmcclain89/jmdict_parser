defmodule YomiKomi.Tatoeba.Sentence do
  defstruct [:content, :meaning]

  def new(entry) do
    {content, meaning} = parse_entry(entry)

    %__MODULE__{
      content: content,
      meaning: meaning
    }
  end

  def parse_entry(entry) do
    entry
    |> String.split_at(2)
    |> then(fn {_, rest} -> rest end)
    |> String.trim()
    |> split()
    |> then(fn [content, meaning_with_extra] ->
      meaning =
        meaning_with_extra
        |> String.split("#ID=")
        |> hd

      {content, meaning}
    end)
  end

  def split(sub_string) do
    cond do
      String.contains?(sub_string, "\t") ->
        String.graphemes(sub_string)
        |> parse_graphemes("")

      true ->
        sub_string
        |> String.split("。")
        |> then(fn [jp, eng] ->
          jp = jp <> "。"
          [jp, eng]
        end)
    end
  end

  def parse_graphemes(["\t" | rest], acc) do
    [String.reverse(acc), Enum.join(rest, "")]
  end

  def parse_graphemes([current | rest], acc) do
    parse_graphemes(rest, current <> acc)
  end
end
