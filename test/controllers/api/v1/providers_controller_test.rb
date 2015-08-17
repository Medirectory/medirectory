require 'test_helper'

class ProvidersControllerTest < ActionController::TestCase

  def setup
    @controller = Api::V1::ProvidersController.new
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
    get :show, :id => 1891031548, :format => :json
    assert_response :success
  end

  test "raises ActiveRecord::RecordNotFound when result not found" do
    assert_raises(ActiveRecord::RecordNotFound) do
      get :show, :id => 99, :format => :json
    end
  end

  test "should return the right number of providers" do
    get :index, {format: :json}
    assert_equal 6, JSON.parse(response.body)['providers'].length
  end

  
end
