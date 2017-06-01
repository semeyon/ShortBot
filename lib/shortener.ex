defmodule Shortbot.Shortener do
  
  @moduledoc """
  Module to make a short url.
  """

  @doc ~S"""
  Make a short version from the url. But this is a mock, so its return the same url.

  ## Example
      iex> body = Shortbot.Shortener.get_short("http://some.url")
      iex> String.contains?(body, "http://thelink.la/")
      true
  """
  @spec get_short(String) :: String
  def get_short(url) do
    case HTTPoison.get("http://thelink.la/api-shorten.php?url=?" <> url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
      {:error, %HTTPoison.Error{reason: reason}} ->
        reason
    end
  end
  
end