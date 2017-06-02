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

  def send_help_text(message, slack) do
    text = """ 
    This is a very simple bot :).
    @#{slack.me.name} /help - See this text.
    @#{slack.me.name} /short http://some.url - Make this url shorter using 3rd party service.
    """
    send_message(text, message.channel, slack)
  end

  def send_url_text(message, slack) do
    shortener = Process.whereis(:shortener)
    l = String.split(message.text)
    if Kernel.length(l) >= 3 do
      {e, _} = List.pop_at(l, 2)
      url = String.replace(e, ["<", ">"], "")
      url = if String.last(url) !== "/" do
        url <> "/"
      end
      case Shortbot.UriValidation.validate_uri(url) do
        {:error, _ } -> 
          send_message("Wrong url format!", message.channel, slack)
        {:ok, _ } ->
          short_url = Shortbot.Server.make_shorter(shortener, url)
          send_message(short_url, message.channel, slack)
      end
    else
      send_message("Wrong url format!", message.channel, slack)
    end
  end

  def handle_connect(slack, state) do
    IO.puts "Connected as #{slack.me.name}"
    send_message("I'm back!", "#iam", slack)
    {:ok, state}
  end

  @doc """
  Trap for non using messages
  """
  def handle_event(_message = %{type: "message", message: _}, _slack, state) do
    {:ok, state}
  end

  def handle_event(message = %{type: "message" }, slack, state) do
    if message.user !== slack.me.id and String.contains?(message.text, slack.me.id) do
      cond do
        String.contains?(message.text, "/help")  -> send_help_text(message, slack)
        String.contains?(message.text, "/short") -> send_url_text(message, slack)
      end
    end
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