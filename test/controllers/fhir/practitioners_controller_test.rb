require 'test_helper'

class PractitionersControllerTest < ActionController::TestCase

  def setup
    @controller = Fhir::PractitionersController.new
  end

  test "should get index as fhir prov json" do
    get :index, {_format: :json}
    assert_response :success
  end

  test "should get index as fhir prov xml" do
    get :index, {_format: :xml}
    assert_response :success
  end

  test "should show a fhir prov" do
    get :show, :id => 1891031548, :_format => :json
    assert_response :success
  end

  test "raises ActiveRecord::RecordNotFound when fhir prov not found" do
    assert_raises(ActiveRecord::RecordNotFound) do
      get :show, :id => 99, :_format => :json
    end
  end

  test "should return a single fhir prov" do
    get :index, {_format: :json, given: "WILL"}
    assert_equal 1, JSON.parse(response.body)['entry'].length
  end

  test "should return 0 fhir provs" do
    get :index, {_format: :json, name: "asdf"}
    assert_equal 0, JSON.parse(response.body)['entry'].length
  end

  test "should return the right number of fhir provs" do
    get :index, {_format: :json}
    assert_equal 6, JSON.parse(response.body)['entry'].length
  end

  test "should return a single fhir prov with id" do
    get :index, {_format: :json, _id: "1891031548"}
    assert_equal 1, JSON.parse(response.body)['entry'].length
  end

  test "should return a no fhir prov (non exist)" do
    get :index, {_format: :json, _id: "0091031548"}
    assert_equal 0, JSON.parse(response.body)['entry'].length
  end

  test "should return the right number of fhir provs with a name" do

    get :index, {_format: :json, name:"T"}
    assert_equal 2, JSON.parse(response.body)['entry'].length
  end

end
