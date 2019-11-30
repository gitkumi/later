defmodule Later.IO do
  alias Later.Utilities

  @root_dir "#{System.user_home()}/.later"
  @todos_file_name Application.fetch_env!(:later, :file_name)
  @todos_dir "#{@root_dir}/#{@todos_file_name}"

  # @finished_todos_file_name "finished_todos.json"
  # @finished_todos_dir "#{@root_dir}/#{@finished_todos_file_name}"

  def read_file do
    with {:ok, json} <- File.read(@todos_dir),
         {:ok, todos} <- Utilities.json_to_map(json) do
      todos
      |> Enum.map(fn t ->
        t
        |> Utilities.atomize_keys()
        |> Utilities.convert_to_todo_struct()
      end)
    else
      {:error, :enoent} ->
        initialize_file()
    end
  end

  def save_file(todos) do
    with {:ok, json} <- Utilities.map_to_json(todos),
         :ok <- File.write(@todos_dir, json) do
      todos
    end
  end

  defp initialize_file(data \\ "[]") do
    File.mkdir_p(@root_dir)
    File.write(@todos_dir, data)
    []
  end
end
