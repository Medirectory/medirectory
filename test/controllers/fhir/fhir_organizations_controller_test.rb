require 'test_helper'

class FhirOrganizationsControllerTest < ActionController::TestCase

  def setup
    @controller = Fhir::OrganizationsController.new
  end

  test "should get index as fhir org json" do
    get :index, {_format: :json}
    assert_response :success
  end

  test "should get index as fhir org xml" do
    get :index, {_format: :xml}
    assert_response :success
  end

  test "should show a fhir org" do
    get :show, :id => 1093062572, :_format => :json
    assert_response :success
  end

  test "should return a single fhir org with id" do
    get :index, {_format: :json, _id: "1093062572"}
    assert_equal 1, JSON.parse(response.body)['entry'].length
  end

  test "should return a no fhir org (non exist)" do
    get :index, {_format: :json, _id: "0091031548"}
    assert_equal 0, JSON.parse(response.body)['entry'].length
  end

  test "raises ActiveRecord::RecordNotFound when fhir org not found" do
    assert_raises(ActiveRecord::RecordNotFound) do
      get :show, :id => 99, :_format => :json
    end
  end

  test "should return the right number of fhir orgs" do
    get :index, {_format: :json}
    assert_equal 6, JSON.parse(response.body)['entry'].length
  end

end
