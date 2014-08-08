class Topic < ActiveRecord::Base
  self.primary_key = :tid
  serialize :docs
  serialize :doc_vals
  belongs_to :extract_ner
  has_one :topic_name, :dependent => :destroy
  self.per_page = 10
end
