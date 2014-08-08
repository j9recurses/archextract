class ExtractNer < ActiveRecord::Base
  belongs_to :collection
  has_many :ners, :dependent => :destroy
end
