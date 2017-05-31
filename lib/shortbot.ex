defmodule Shortbot do
    use Application
 
  def start(_type, _args) do
    Shortbot.Supervisor.start_link
  end

end