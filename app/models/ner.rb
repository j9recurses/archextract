class Ner < ActiveRecord::Base

  def self.get_types(collection)
        @ner_peeps = Ner.where(nertype: "PERSON",  collection_id: collection[:id])
        @ner_places = Ner.where(nertype: "LOCATION", collection_id: collection[:id])
        @ner_orgs = Ner.where(nertype: "ORGANIZATION", collection_id: collection[:id])
        @ner_dates = Ner.where(nertype: "DATE", collection_id: collection[:id] )
        @ner_peeps = @ner_peeps[0...50]
        @ner_places = @ner_places[0...50]
        @ner_orgs = @ner_orgs[0...50]
        @ner_dates = @ner_dates[0...50]
        return @ner_dates, @ner_orgs, @ner_peeps, @ner_places
  end

def self.get_documents(ner)
  @documents = eval(ner[:docs])
  @mydocs = {}
  @documents.each do |d|
    @doc = Document.find(d)
    @mydocs[@doc[:id]]= @doc[:name]
  end
  return @mydocs
end

end
