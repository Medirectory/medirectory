require 'test_helper'

class TaxonomiesControllerTest < ActionController::TestCase

  def setup
    5.times do |i|
      taxonomy = TaxonomyCode.new()
      taxonomy.save!
    end
    @controller = Api::V1::TaxonomiesController.new
  end

  test "should get index as json" do
    get :index, {format: :json}
    assert_response :success
  end

  test "should get index as xml" do
    get :index, {format: :xml}
    assert_response :success
  end

  test "should return the right number of taxonomies" do
    get :index, {format: :json}
    assert_equal 5, JSON.parse(response.body)['taxonomies'].length
  end
end
