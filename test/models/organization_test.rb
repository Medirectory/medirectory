require 'test_helper'

class OrganizationTest < ActiveSupport::TestCase

  test "Organization cannot be created without an NPI" do
    bad_organization = assert_raises ActiveRecord::StatementInvalid do
      o = Organization.new()
      o.save!
    end
    assert bad_organization.message.include? 'value in column "npi" violates not-null constraint'
  end

  test "Organization can be created with an NPI" do
    assert_equal 0, Organization.count
    @organization = Organization.new(npi: '123')
    @organization.save!
    assert_equal 1, Organization.count
  end

  test "Organization tries to find an associated providers" do
    assert_respond_to Organization.new(npi: '1'), :likely_providers
  end

  test "Organization can have a searchable language" do
    assert_respond_to Organization, :searchable_language
  end

end
