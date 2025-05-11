# frozen_string_literal: true

require "test_helper"

class TestStringToCamelCase < Minitest::Test
  def setup
    @input = "Please WAIT while your AOL_MAIL are being dialed-up. LOADING... 56k▓▓▓▒▒▒░░░"
  end

  def test_it_converts_to_upper_camelcase
    assert_equal(
      "PleaseWaitWhileYourAolMailAreBeingDialedUpLoading56k",
      @input.to_camelcase
    )
  end

  def test_it_converts_to_lower_camelcase
    assert_equal(
      "pleaseWaitWhileYourAolMailAreBeingDialedUpLoading56k",
      @input.to_camelcase(:lower)
    )
  end
end
