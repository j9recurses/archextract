class ExtractTopic < ActiveRecord::Base
  belongs_to :collection
  belongs_to :preprocess
  validates :preprocess_id, presence: { message:  "Please enter a pre-process to create a topic model"}
  validates :preprocess_id, uniqueness:  {  scope: :num_of_topics , message:  "A topic model cannot be generated from more than one pre-process"}
  validates :num_of_topics, presence: true, numericality: {
    greater_than_or_equal_to: 1, less_than_or_equal_to: 100
  } , :allow_nil => false
  has_many :topic_docs,  :dependent => :destroy
  has_many :topics ,   :dependent => :destroy
end
