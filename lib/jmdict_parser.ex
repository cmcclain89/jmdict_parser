defmodule JmdictParser do
  import SweetXml

  @ent_seq ~x".//ent_seq/text()"i
  @k_ele ~x".//k_ele"l
  @r_ele ~x".//r_ele"l
  @sense ~x".//sense"l

  @moduledoc """
  Documentation for `JmdictParser`.
  """
  def read_to_end() do
    jmdict_file()
    |> File.stream!(read_ahead: 250_000)
    |> stream_tags!([:entry], discard: [:entry])
    |> Flow.from_enumerable()
    |> Flow.map(fn {_, doc} ->
      cool =
        %{
          ent_seq: xpath(doc, @ent_seq),
          k_ele: xpath(doc, @k_ele),
          r_ele: xpath(doc, @r_ele),
          sense: xpath(doc, @sense)
        }
        |> Jmdict.Entry.new()

      IO.inspect(cool.ent_seq, label: "Processed")

      cool
    end)
    |> Enum.to_list()
  end

  def jmdict_file do
    Application.app_dir(:jmdict_parser, "/priv/JMdict_e.xml")
  end
end
