defmodule Shortbot.Shortener do
  
  @moduledoc """
  Module to make a short url.
  """

  def get_short(url) do
    case HTTPoison.get("http://thelink.la/api-shorten.php?url=?" <> url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
      {:error, %HTTPoison.Error{reason: reason}} ->
        reason
    end
  end
  
end