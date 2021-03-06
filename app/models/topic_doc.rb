class  TopicDoc < ActiveRecord::Base
  self.primary_key = :dcid
  serialize :topics
  serialize :topic_vals
  belongs_to :extract_ner
  has_one :topic_doc_name, :dependent => :destroy
  self.per_page = 10

  def self.get_original_text (topic_doc_id, extract_topic, collection)
   doc_name = TopicDocNames.find(topic_doc_id)
   file_name = doc_name[:name].split(".")
   file_name = file_name[0] + ".txt"
   file_path = Rails.root.join("public", "src_corpora", collection[:src_datadir], "input",  file_name)
   contents = ""
   file = File.open(file_path, "rb") do |file|
      file.readlines.each do |line|
          line = line_break(line)
          contents = contents + line
      end
  end
  return contents
  end

  def self.get_chopped_text(topic_doc)
    doc_name = TopicDocNames.find(topic_doc[:id])
    file_name = doc_name[:name]
    ppid = topic_doc[:preprocess_id]
    preprocess  = Preprocess.find(ppid)
    file_path = Rails.root.join("public", "src_corpora",  preprocess[:file_dir],  file_name)
   contents = ""
   file = File.open(file_path, "rb") do |file|
      file.readlines.each do |line|
          line = line_break(line)
          contents = contents + line
      end
  end
  puts contents
  return contents,  preprocess [:routine_name]
  end


  def self.get_topic_names(topic_doc)
    puts "******"
    puts "*********"
    puts topic_doc.inspect
    preassoc_topics =  eval(topic_doc[:topics])
    topics_scores =  eval(topic_doc[:topic_vals])
     preassoc_topics =  preassoc_topics[0..49]
     topics_scores  =  topics_scores[0..49]
    assoc_topics = Hash.new
      preassoc_topics.each do |p |
          topname = TopicNames.find(p)
           assoc_topics[p] =    topname[:name]
      end
      return assoc_topics,  topics_scores
    end

   def self.line_break(string)
    string.gsub("\n", '<br/>')
   end
  end
