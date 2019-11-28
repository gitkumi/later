defmodule Later.Utilities do
  alias Later.Todo

  def atomize_keys(json), do: for {key, value} <- json, into: %{}, do: {String.to_atom(key), value}

  def convert_to_todo_struct(todo) do
    id =
      if is_binary(todo.id),
        do: String.to_integer(todo.id),
        else: todo.id

    %Todo{
      :id => id,
      :title => todo.title,
      :description => todo.description
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
