class Preprocess < ActiveRecord::Base
  belongs_to :collection
  validates :tfidf_score, numericality: {
    greater_than_or_equal_to: 0, less_than_or_equal_to: 1
  }

end
