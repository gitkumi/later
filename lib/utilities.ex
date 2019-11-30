defmodule Later.Utilities do
  alias Later.Todo

  def atomize_keys(json) do
    for({key, value} <- json, into: %{}, do: {String.to_atom(key), value})
  end

  def create_todo_struct([], todo) do
    todo
    |> Map.put(:id, 1)
    |> convert_to_todo_struct()
  end

  def create_todo_struct(todos, todo) do
    id =
      todos
      |> Enum.max_by(fn t -> t.id end)
      |> Map.get(:id)
      |> Kernel.+(1)

    todo
    |> Map.put(:id, id)
    |> convert_to_todo_struct()
  end

  def merge_todos(todos, todo), do: Enum.concat(todos, [todo])

  def convert_to_todo_struct(todo), do: Map.merge(%Todo{}, todo)

  def json_to_map(json), do: Jason.decode(json)

  def map_to_json(map), do: Jason.encode(map)

  defimpl Jason.Encoder, for: Todo do
    def encode(value, opts) do
      value
      |> Map.take([:id, :title, :description])
      |> Jason.Encode.map(opts)
    end
  end
end
