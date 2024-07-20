defmodule YomiKomi.Jmdict.JmdictEventHandler do
  @behaviour Saxy.Handler

  def handle_event(:start_document, prolog, state) do
    IO.inspect("Start parsing document")
    {:ok, [{:start_document, prolog} | state]}
  end

  def handle_event(:end_document, _data, state) do
    IO.inspect("Finish parsing document")
    {:ok, [{:end_document} | state]}
  end

  def handle_event(:start_element, {name, attributes}, state) do
    IO.inspect("Start parsing element #{name} with attributes #{inspect(attributes)}")
    {:ok, [{:start_element, name, attributes} | state]}
  end

  def handle_event(:end_element, name, state) do
    IO.inspect("Finish parsing element #{name}")
    {:ok, [{:end_element, name} | state]}
  end

  def handle_event(:characters, chars, state) do
    IO.inspect("Receive characters #{chars}")
    {:ok, [{:characters, chars} | state]}
  end

  def handle_event(:cdata, cdata, state) do
    IO.inspect("Receive CData #{cdata}")
    {:ok, [{:cdata, cdata} | state]}
  end
end
