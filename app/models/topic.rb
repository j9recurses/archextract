class Topic < ActiveRecord::Base
  self.primary_key = :tid
  serialize :docs
  serialize :doc_vals
  belongs_to :collection
end
