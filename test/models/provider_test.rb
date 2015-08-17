require 'test_helper'

class ProviderTest < ActiveSupport::TestCase

  test "Provider cannot be created without an NPI" do
    bad_provider = assert_raises ActiveRecord::StatementInvalid do
      p = Provider.new()
      p.save!
    end
    assert bad_provider.message.include? 'value in column "npi" violates not-null constraint'
  end

  test "Provider can be created with an NPI" do
    assert_equal 0, Provider.count
    @provider = Provider.new(npi: '123')
    @provider.save!
    assert_equal 1, Provider.count
  end

  test "Provider tries to find an associated organization" do
    assert_respond_to Provider.new(npi: '1'), :likely_organization
  end

  test "Provider can have a searchable language" do
    assert_respond_to Provider, :searchable_language
  end

  test "Provider can have a complex search" do
    assert_respond_to Provider, :complex_search
  end

end
