defmodule Later do
  alias Later.IO, as: LaterIO
  alias Later.{Print, Utilities}

  def show(%{:id => nil}) do
    LaterIO.read_file()
    |> Print.main()
  end

  def show(%{:id => id}) do
    LaterIO.read_file()
    |> Enum.find(fn t -> t.id == String.to_integer(id) end)
    |> Print.main()
  end

  def add(todo) do
    todos = LaterIO.read_file()
    todo  = create_todo_struct(todos, todo)

    todos
    |> merge_todos(todo)
    |> LaterIO.save_file()
    |> Print.main()
  end

  def edit(todo) do
    todos = LaterIO.read_file()
    todo = Utilities.convert_to_todo_struct(todo)

    todo =
      todos
      |> Enum.find(fn t -> t.id == todo.id end)
      |> Map.merge(todo)

    todos
    |> Enum.filter(fn t -> t.id != todo.id end)
    |> merge_todos(todo)
    |> Enum.sort_by(fn t -> t.id end)
    |> LaterIO.save_file()
    |> Print.main()
  end

  def delete(%{:id => id}) do
    LaterIO.read_file()
    |> Enum.filter(fn t -> t.id != String.to_integer(id) end)
    |> LaterIO.save_file()
    |> Print.main()
  end

  defp create_todo_struct(todos, todo) do
    id =
      todos
      |> Enum.max_by(fn t -> t.id end)
      |> Map.get(:id)
      |> Kernel.+(1)

    todo
    |> Map.put(:id, id)
    |> Utilities.convert_to_todo_struct()
  end

  defp merge_todos(todos, todo), do: Enum.concat(todos, [todo])
end