require 'test_helper'

class PractitionersControllerTest < ActionController::TestCase

  def setup
    @mailingaddress = MailingAddress.new()
    @practiceaddress = PracticeLocationAddress.new()
    @provider = Provider.new(npi: 123, mailing_address: @mailingaddress, practice_location_address: @practiceaddress)
    @provider.save!
    @controller = Fhir::PractitionersController.new
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
    get :show, :id => 123, :format => :json
    assert_response :success
  end

  test "raises ActiveRecord::RecordNotFound when result not found" do
    assert_raises(ActiveRecord::RecordNotFound) do
      get :show, :id => 99, :format => :json
    end
  end

  test "should return the right number of providers" do
    @mailingaddress = MailingAddress.new()
    @practiceaddress = PracticeLocationAddress.new()

    5.times do |i|
      provider = Provider.new(npi: i, mailing_address: @mailingaddress, practice_location_address: @practiceaddress)
      provider.save!
    end

    get :index, {format: :json}
    assert_equal 6, JSON.parse(response.body)['entry'].length
  end

end
