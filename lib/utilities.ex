defmodule Later.Utilities do
  alias Later.Todo

  def convert_to_todo_struct(todo) when is_list(todo) do
    todo
    |> Enum.reduce(%{}, fn param, params ->
      param = Map.new(param, fn {key, value} -> {Atom.to_string(key), value} end)
      Map.merge(params, param)
    end)
    |> convert_to_todo_struct()
  end

  def convert_to_todo_struct(todo) do
    id =
      if is_binary(todo["id"]),
        do: String.to_integer(todo["id"]),
        else: todo["id"]

    %Todo{
      :id => id,
      :title => todo["title"],
      :description => todo["description"]
    }
  end

  def json_to_map(json), do: Jason.decode(json)

  def map_to_json(map), do: Jason.encode(map)

  defimpl Jason.Encoder, for: Todo do
    def encode(value, opts) do
      Jason.Encode.map(Map.take(value, [:id, :title, :description]), opts)
    end
  end
end
