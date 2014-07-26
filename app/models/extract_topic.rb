class ExtractTopic < ActiveRecord::Base
  belongs_to :collection
  validates_uniqueness_of :preprocess_id, message: "Can not have more than pre-process"
end
