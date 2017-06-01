defmodule Shortbot.Supervisor do

  use Supervisor
  
  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init(_) do
    children = [
      worker(Shortbot.Server, []),
      worker(Shortbot.SlackRtm, [])
    ]
    supervise(children, strategy: :one_for_one)
  end

end