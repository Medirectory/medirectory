require 'test_helper'

class SearchTest < ActiveSupport::TestCase

  test "Search can be basic" do
    assert_respond_to Search, :basic
  end

  test "Search can be fuzzy" do
    assert_respond_to Search, :fuzzy
  end

end
