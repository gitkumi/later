# Later
Log it now, do it later. Todo list on your terminal written on Elixir.

## Requirements

You need Elixir.

## Installation

1. Clone the repo.

2. `cd` into the project directory.
   
3. Build the project.
- `mix deps.get && MIX_ENV=prod mix escript.build` This will generate a bin file. 

4. Install the generated bin.
- `mix escript.install later`

5. It will be installed on `/home/user/.mix/escripts` or `/home/user/.asdf/installs/elixir/<version>/.mix/escripts` if you are using asdf-vm.

6. Add the directory to your `$PATH` variable to run the program anywhere.

7. Run `later -h` to see how to use it.

![help](/docs/help.png)

## FAQ

1. Why is this not written on Go or Python?!?!
- I don't know Go or Python.

2. You mean to say I need Elixir on my machine to run this program!?!?
- Technically only Erlang/OTP, but yes.