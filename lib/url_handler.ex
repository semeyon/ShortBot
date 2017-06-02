defmodule Shortbot.UriHandler do

  @moduledoc """
  Url validation module
  """

  @doc ~S"""
  Validate uri

  ## Example
      iex> Shortbot.UriHandler.validate_uri("http://right.url/")
      {:ok, %URI{authority: "right.url", fragment: nil, host: "right.url", path: "/", port: 80, query: nil, scheme: "http", userinfo: nil}}
      iex> Shortbot.UriHandler.validate_uri("wrongurl")
      {:error, %URI{authority: nil, fragment: nil, host: nil, path: "wrongurl", port: nil, query: nil, scheme: nil, userinfo: nil}}
  """
  def validate_uri(str) do
    uri = URI.parse(str)
    case uri do
      %URI{scheme: nil} -> {:error, uri}
      %URI{host: nil} -> {:error, uri}
      %URI{path: nil} -> {:error, uri}
      uri -> {:ok, uri}
    end 
  end

  @doc ~S"""
  Extract url from the message text.

  ## Example
      iex> Shortbot.UriHandler.parse_out_url("<@someuser> /short")
      :error
      iex> Shortbot.UriHandler.parse_out_url("<@someuser> /short http://some.url/")
      {:ok, "http://some.url/"}
      iex> Shortbot.UriHandler.parse_out_url("<@someuser> /short http://some.url")
      {:ok, "http://some.url/"}
  """
  def parse_out_url(text) do
    l = String.split(text)
    if Kernel.length(l) >= 3 do
      {e, _} = List.pop_at(l, 2)
      url = e |> String.replace(["<", ">"], "")
      url = if String.last(url) !== "/" do
              url <> "/"
            else
              url
            end
      {:ok, url}
    else
      :error
    end
  end

end