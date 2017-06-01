defmodule Shortbot.SlackRtm do
    
  @moduledoc """
  Slack bot module
  """
  use Slack
  use GenServer
  require Logger

  @slack_token Application.get_env(:shortbot, :slack_token)
  
  # API
  def start_link do
   Slack.Bot.start_link(__MODULE__, [], @slack_token, %{name: :slack_bot})
  end


  def handle_connect(slack, state) do
    IO.puts "Connected as #{slack.me.name}"
    send_message("I'm back!", "#iam", slack)
    {:ok, state}
  end

  def handle_event(message = %{type: "message"}, slack, state) do
    IO.puts inspect message
    shortener = Process.whereis(:shortener)
    send_message("I got a message!", message.channel, slack)
    short_url = Shortbot.Server.make_shorter(shortener, "http://ixbt.com")
    send_message(short_url, message.channel, slack)

    {:ok, state}
  end

  def handle_event(_, _, state), do: {:ok, state}

  def handle_info({:message, text, channel}, slack, state) do
    IO.puts "Sending your message, captain!"

    send_message(text, channel, slack)

    {:ok, state}
  end

  def handle_info(_, _, state), do: {:ok, state}

end