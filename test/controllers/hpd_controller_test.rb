require 'test_helper'

class HpdControllerTest < ActionController::TestCase

  def setup
    @controller = HpdController.new
  end

  test "should get response" do
    file = File.read("test/fixtures/soap_requests/provider_search_firstname.xml")
    raw_post 'endpoint', {format: :soap}, file
    assert_response :success
  end
end
