class Search < ActiveRecord::Base
  extend Textacular

  belongs_to :entity, polymorphic: true

  def self.basic(query, options={})
    options.reverse_merge! offset: 0, limit: 20
    self.basic_search(query).offset(options[:offset]).limit(options[:limit]).preload(:entity).map(&:entity)
  end

  def self.fuzzy(query, options={})
    options.reverse_merge! offset: 0, limit: 20
    self.fuzzy_search(query).offset(options[:offset]).limit(options[:limit]).preload(:entity).map(&:entity)
  end

end
