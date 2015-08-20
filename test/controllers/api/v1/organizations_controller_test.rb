require 'test_helper'

class OrganizationsControllerTest < ActionController::TestCase

  def setup
    @controller = Api::V1::OrganizationsController.new
  end

  test "should get index as json" do
    get :index, {format: :json}
    assert_response :success
  end

  test "should get index as xml" do
    get :index, {format: :xml}
    assert_response :success
  end

  test "should show a result" do
    get :show, :id => 1093062572, :format => :json
    assert_response :success
  end

  test "raises ActiveRecord::RecordNotFound when result not found" do
    assert_raises(ActiveRecord::RecordNotFound) do
      get :show, :id => 99, :format => :json
    end
  end

  test "should return the right number of organizations" do
    get :index, {format: :json}
    assert_equal 6, JSON.parse(response.body)['organizations'].length
  end
end
