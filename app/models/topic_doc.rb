class  TopicDoc < ActiveRecord::Base
  self.primary_key = :dcid
  serialize :topics
  serialize :topic_vals

  def self.get_original_text (topic_doc, extract_topic, collection)
   file_name = topic_doc[:name].split(".")
   file_name = file_name[0] + ".txt"
   file_path = Rails.root.join("public", "src_corpora", collection[:src_datadir], file_name)
   contents = ""
   file = File.open(file_path, "rb") do |file|
      file.readlines.each do |line|
          contents = contents + line
      end
  end
  return contents
  end

end
