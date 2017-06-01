defmodule Shortbot.Server do
  
  @moduledoc """
  Documentation for Shortbot.
  """

  use GenServer
  
  @shortener_api Application.get_env(:shortbot, :shortener_api)
  
  # API
  def start_link do
    GenServer.start_link(__MODULE__, [], name: :shortener)
  end
  
  @doc ~S"""
  Send url in the async way

  ## Example
      iex> pid = Process.whereis(:shortener)
      iex> Shortbot.Server.send_shorter(pid, "http://some.url")
      :ok
  """
  def send_shorter(pid, url) do
    GenServer.cast(pid, {:send_shorter, url})
  end

  @doc ~S"""
  Send url in the async way

  ## Example
      iex> pid = Process.whereis(:shortener)
      iex> Shortbot.Server.send_shorter(pid, "http://some.url")
      iex> Shortbot.Server.get_shorts(pid)
      ["http://some.url"]
  """
  def get_shorts(pid) do
    GenServer.call(pid, :get_shorts)
  end

  @doc ~S"""
  Make short version in sync way

  ## Example
      iex> pid = Process.whereis(:shortener)
      iex> Shortbot.Server.make_shorter(pid, "http://some.url")
      "http://some.url"
  """
  def make_shorter(pid, url) do
    GenServer.call(pid, {:make_shorter, url})
  end

  # Server
  @doc ~S"""
  Init server.

  ## Examples

      iex> Shortbot.Server.init("Test")
      {:ok, "Test"}
  """
  def init(state) do
    {:ok, state}
  end

  @doc ~S"""
  Return short url in the sync way

  ## Example
      iex> pid = Process.whereis(:shortener)
      iex> Shortbot.Server.handle_call({:make_shorter, "http://some.url"}, pid, [])
      {:reply, "http://some.url", []}
  """
  def handle_call({:make_shorter, url}, _from, _state) do
    {:reply, @shortener_api.get_short(url), []}
  end

  @doc ~S"""
  Return short url from the state

  ## Example
      iex> pid = Process.whereis(:shortener)
      iex> Shortbot.Server.handle_call(:get_shorts, pid, ["http://some.url"])
      {:reply, ["http://some.url"], ["http://some.url"]}
  """
  def handle_call(:get_shorts, _from, state) do
    {:reply, state, state}
  end

  @doc ~S"""
  set short url to the state

  ## Example
      iex> Shortbot.Server.handle_cast({:send_shorter, "http://some.url"}, [])
      {:noreply, ["http://some.url"]}
  """
  def handle_cast({:send_shorter, url}, _state) do
    {:noreply, [@shortener_api.get_short(url)]}
  end

end
