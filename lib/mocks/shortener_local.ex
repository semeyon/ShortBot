defmodule Shortbot.ShortenerLocal do
  @moduledoc """
  This a mock module for the url shortener
  """

  @doc ~S"""
  Make a short version from the url. But this is a mock, so its return the same url.

  ## Example
      iex> Shortbot.ShortenerLocal.get_short("http://some.url")
      "http://some.url"
  """
  @spec get_short(String) :: String
  def get_short(url) do
    url
  end
  
end