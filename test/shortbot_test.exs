defmodule ShortbotTest do
  use ExUnit.Case
  doctest Shortbot
  doctest Shortbot.Server
  doctest Shortbot.Shortener
  doctest Shortbot.ShortenerLocal
  # doctest Shortbot.UriValidation
  #doctest Shortbot.SlackRtm

  test "the truth" do
    assert 1 + 1 == 2
  end
end
