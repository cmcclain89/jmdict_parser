defmodule JmdictParser do
  import SweetXml

  @moduledoc """
  Documentation for `JmdictParser`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> JmdictParser.hello()
      :world

  """
  def hello do
    :world
  end

  def read(count \\ 1) do
    # extract = fn {num, _} -> num end

    jmdict_file()
    |> File.stream!()
    |> stream_tags!([:entry], discard: [:entry])
    |> Stream.map(fn {_, doc} ->
      # IO.inspect(doc)
      # IO.inspect(doc, label: "unchanged")
      IO.inspect(~x"")

      cool =
        %{
          ent_seq: xpath(doc, ~x".//ent_seq/text()"i),
          k_ele: xpath(doc, ~x".//k_ele"l),
          r_ele: xpath(doc, ~x".//r_ele"l),
          sense: xpath(doc, ~x".//sense"l)
        }
        |> Jmdict.Entry.new()

      IO.inspect(cool, label: "Formatted")

      cool
    end)
    |> Stream.take(count)
    |> Enum.reverse()
    |> Enum.take(5)

    # |> IO.inspect(label: "First 15?")
  end

  def jmdict_file do
    Application.app_dir(:jmdict_parser, "/priv/JMdict_e.xml")
  end
end
