defmodule Later.Print do
  alias Later.Commands

  @help_title "Later"
  @help_description "Log it now, do it later. Todo list on your terminal written on Elixir."
  @repo_link "https://github.com/gitkumi/later"
  @tab "    "

  def main(todos) when is_list(todos) do
    IO.puts(" ")
    IO.puts("#{@tab}#{ansi_bright()}Todos#{ansi_normal()}")
    IO.puts(" ")
    Enum.each(todos, fn t -> print_todo(t) end)
    IO.puts(" ")

    :ok
  end

  def main(todo) do
    IO.puts(" ")
    print_todo(todo)
    IO.puts(" ")

    if Map.has_key?(todo, :description) do
      IO.puts("#{@tab}- #{todo.description}")
      IO.puts(" ")
    end

    :ok
  end

  def help() do
    IO.puts(" ")
    IO.puts("#{@tab}#{ansi_bright()}#{@help_title}#{ansi_normal()}")
    IO.puts("#{@tab}#{@help_description}")
    IO.puts(" ")
    IO.puts("#{@tab}#{ansi_bright()}Repository#{ansi_normal()}")
    IO.puts("#{@tab}#{@repo_link}")
    IO.puts(" ")
    IO.puts("#{@tab}#{ansi_bright()}Commands#{ansi_normal()}")
    Enum.each(Commands.get_commands(), fn m -> print_help(m) end)
    IO.puts(" ")
  end

  def error(args) do
    IO.puts(" ")
    IO.puts("#{@tab}#{args.reason}")
    IO.puts(" ")

    :ok
  end

  defp print_todo(todo),
    do: IO.puts("#{@tab}#{todo.id}. #{ansi_bright()}#{todo.title}#{ansi_normal()}")

  defp print_help(command) do
    command_name = "#{ansi_bright()}· #{command.name}#{ansi_normal()}"
    command_alias = "(-#{command.alias})"
    command_description = "#{command.description}"

    command_examples = command.examples
    command_parameters = command.parameters

    IO.puts(" ")
    IO.puts("#{@tab}#{@tab}#{command_name} #{command_alias}")
    IO.puts("#{@tab}#{@tab}#{ansi_faint()}#{command_description}#{ansi_normal()}")

    if command_parameters do
      IO.puts(" ")
      IO.puts("#{@tab}#{@tab}#{@tab}#{ansi_bright()}parameters#{ansi_normal()}")

      Enum.each(command_parameters, fn a ->
        IO.puts(
          "#{@tab}#{@tab}#{@tab}#{a.name} #{
            if a.required, do: "#{ansi_faint()}(required)#{ansi_normal()}"
          }"
        )
      end)
    end

    if command_examples do
      IO.puts(" ")
      IO.puts("#{@tab}#{@tab}#{@tab}#{ansi_bright()}examples#{ansi_normal()}")

      Enum.each(command_examples, fn e ->
        IO.puts("#{@tab}#{@tab}#{@tab}#{e.command} #{ansi_faint()}# #{e.comment}#{ansi_normal()}")
      end)
    end
  end

  defp ansi_bright, do: IO.ANSI.bright()
  defp ansi_faint, do: IO.ANSI.faint()
  defp ansi_normal, do: IO.ANSI.normal()
end
