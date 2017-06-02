defmodule Shortbot.UriValidation do

  @moduledoc """
  Url validation module
  """

  @doc ~S"""
  Validate uri

  ## Example
      iex> Shortbot.UriValidation.validate_uri("http://right.url/")
      {:ok, %URI{authority: "right.url", fragment: nil, host: "right.url", path: "/", port: 80, query: nil, scheme: "http", userinfo: nil}}
      iex> Shortbot.UriValidation.validate_uri("wrongurl")
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

end