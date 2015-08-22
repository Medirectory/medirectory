class ElectronicService < ActiveRecord::Base
  belongs_to :provider
  belongs_to :organization
end
