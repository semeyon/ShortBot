defmodule Shortbot do

  @moduledoc """
  Bootstrap of application
  """

  use Application

  def start(_type, _args) do
    Shortbot.Supervisor.start_link
  end

end