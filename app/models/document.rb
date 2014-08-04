class Document < ActiveRecord::Base
  belongs_to :collection
   validates :name, uniqueness: true

   def self.line_break(string)
    string.gsub("\n", '<br/>')
   end

   def self.get_original_text (document, collection)
    file_name = document[:name]
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

end
