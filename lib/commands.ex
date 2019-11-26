defmodule Later.Commands do
  alias Later.Error
  alias Later.Command
  alias Later.Command.{Example, Parameter}

  # TODO: Add finished and search command
  # TODO: Allow todo editing of only description

  @commands [
    %Command{
      :name => :show,
      :type => :boolean,
      :alias => :s,
      :description => "Show all todos. ",
      :examples => [
        %Example{
          :command => "later -s",
          :comment => "Show all todos."
        },
        %Example{
          :command => "later -s 1",
          :comment => "Show todo #1."
        }
      ],
      :parameters => [
        %Parameter{
          :name => :id,
          :required => false
        }
      ]
    },
    %Command{
      :name => :add,
      :type => :boolean,
      :alias => :a,
      :description => "Add a todo.",
      :examples => [
        %Example{
          :command => "later -a \"Take out the garbage.\"",
          :comment => "Add a todo with a title \"Take out the garbage.\""
        },
        %Example{
          :command => "later -a \"Pay for rent.\" \"Bank closes at 5PM.\"",
          :comment =>
            "Add a todo with a title \"Pay for rent.\" and a description \"Bank closes at 5PM.\""
        }
      ],
      :parameters => [
        %Parameter{
          :name => :title,
          :required => true
        },
        %Parameter{
          :name => :description,
          :required => false
        }
      ]
    },
    %Command{
      :name => :edit,
      :type => :boolean,
      :alias => :e,
      :description => "Edit a todo.",
      :examples => [
        %Example{
          :command => "later -e 1 \"Take out the garbage on Tuesday.\"",
          :comment => "Edit todo #1's title."
        },
        %Example{
          :command =>
            "later -e 1 \"Take out the garbage on Tuesday.\" \"Also disposed pet bottles\"",
          :comment => "Edit todo #1's title and todo #1's description."
        }
      ],
      :parameters => [
        %Parameter{
          :name => :id,
          :required => true
        },
        %Parameter{
          :name => :title,
          :required => false
        },
        %Parameter{
          :name => :description,
          :required => false
        }
      ]
    },
    %Command{
      :name => :delete,
      :type => :boolean,
      :alias => :d,
      :description => "Delete a todo.",
      :examples => [
        %Example{
          :command => "later -d 1",
          :comment => "Delete todo #1."
        }
      ],
      :parameters => [
        %Parameter{
          :name => :id,
          :required => true
        }
      ]
    },
    %Command{
      :name => :help,
      :type => :boolean,
      :alias => :h,
      :description => "Display help."
    }
  ]

  @options [
    # switches: Enum.map(@commands, fn c -> {c.name, c.type} end),
    strict: Enum.map(@commands, fn c -> {c.name, c.type} end),
    aliases: Enum.map(@commands, fn c -> {c.alias, c.name} end)
  ]

  def get_commands, do: @commands

  def parse_options(input) do
    {parsed, args, _invalid} = OptionParser.parse(input, @options)

    parsed
    |> parse_command()
    |> verify_command()
    |> parse_args(args)
  end

  defp parse_command(list) do
    list
    |> Enum.map(fn {c, _true} -> c end)
    |> Enum.at(0)
  end

  defp verify_command(command) do
    @commands
    |> Enum.map(fn c -> c.name end)
    |> Enum.find(:error, fn name -> name == command end)
  end

  defp parse_args(:help, _args), do: :help
  defp parse_args(:error, _args), do: {:error, %Error{:reason => "Invalid command."}}

  defp parse_args(command, input_args) do
    args =
      command
      |> get_command()
      |> Map.get(:parameters)
      |> Enum.with_index()
      |> Enum.map(fn {args, index} ->
        %{
          args.name => Enum.at(input_args, index)
        }
      end)

    {command, args}
  end

  defp get_command(name), do: Enum.find(@commands, fn c -> c.name == name end)
end
