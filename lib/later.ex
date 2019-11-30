defmodule Later do
  alias Later.IO, as: LaterIO
  alias Later.{Print, Utilities}

  def show(%{:id => id}) do
    LaterIO.read_file()
    |> Enum.find(fn t -> t.id == id end)
    |> Print.main()
  end

  def show(%{}) do
    LaterIO.read_file()
    |> Print.main()
  end

  def add(todo) do
    todos = LaterIO.read_file()
    todo = Utilities.create_todo_struct(todos, todo)

    todos
    |> Utilities.merge_todos(todo)
    |> LaterIO.save_file()
    |> Print.main()
  end

  def edit(new_todo) do
    todos = LaterIO.read_file()
    old_todo = Enum.find(todos, fn t -> t.id == new_todo.id end)
    handle_edit({todos, old_todo, new_todo})
  end

  def delete(%{:id => id}) do
    todos = LaterIO.read_file()
    todo = Enum.find(todos, fn t -> t.id == id end)

    handle_delete({todos, todo})
  end

  defp handle_edit({_todos, nil, _new_todo}) do
    Print.error(%{:reason => "Todo not found."})
  end

  defp handle_edit({todos, old_todo, new_todo}) do
    updated_todo = Map.merge(old_todo, new_todo)

    todos
    |> Enum.filter(fn t -> t.id != updated_todo.id end)
    |> Utilities.merge_todos(updated_todo)
    |> Enum.sort_by(fn t -> t.id end)
    |> LaterIO.save_file()
    |> Print.main()
  end

  defp handle_delete({_todos, nil}) do
    Print.error(%{:reason => "Todo not found."})
  end

  defp handle_delete({todos, todo}) do
    todos
    |> Enum.filter(fn t -> t.id != todo.id end)
    |> LaterIO.save_file()
    |> Print.main()
  end
end
