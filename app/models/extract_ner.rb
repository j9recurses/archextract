class ExtractNer < ActiveRecord::Base
  belongs_to :collection,  :foreign_key => 'collection_id',  :primary_key => 'id'
  has_many :ners, :dependent => :destroy
end
