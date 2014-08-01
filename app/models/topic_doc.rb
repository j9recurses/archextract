class  TopicDoc < ActiveRecord::Base
  self.primary_key = :dcid
  serialize :topics
  serialize :topic_vals
  belongs_to :collection
  has_many :topics

  def self.get_original_text (topic_doc, extract_topic, collection)
   doc_name = TopicDocNames.find(topic_doc)
   file_name = doc_name[:name].split(".")
   file_name = file_name[0] + ".txt"
   file_path = Rails.root.join("public", "src_corpora", collection[:src_datadir], "input",  file_name)
   contents = ""
   file = File.open(file_path, "rb") do |file|
      file.readlines.each do |line|
          contents = contents + line
      end
  end
  return contents
  end

  def self.get_topic_names(topic_doc)
    preassoc_topics =  eval(topic_doc[:topics])
     preassoc_topics =  preassoc_topics[0..49]
    assoc_topics = Hash.new
      preassoc_topics.each do |p |
          topname = TopicNames.find(p)
           assoc_topics[p] =    topname[:name]
      end
      return assoc_topics
    end
  end


