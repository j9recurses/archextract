require 'test_helper'

class PreprocessesTest < ActionMailer::TestCase
  test "preprocess_complete" do
    mail = Preprocesses.preprocess_complete
    assert_equal "Preprocess complete", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end




end
