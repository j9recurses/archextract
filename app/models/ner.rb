class Ner < ActiveRecord::Base
belongs_to :collection
belongs_to :extract_ner
self.per_page = 10

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

  def self.ner_documents(ner)
    @documents = eval(ner[:docs])
    @mydocs = {}
    @documents.each do |d|
    @doc = Document.find(d)
    if  @mydocs.has_key?(@doc[:id])
      vlist = @mydocs[@doc[:id]]
      countv = vlist[1] + 1
      vlist[1] = countv
       @mydocs[@doc[:id]] =vlist
    else
       vlist = [@doc[:name], 1]
       @mydocs[@doc[:id]]= vlist
    end
  end
  @mydocs = @mydocs.sort_by{|k,v| v[1]}.reverse
  return @mydocs
  end

  def self.ner_similar_items(ner)
    @items = []
    if not ner[:sm_items].nil?
      similar_items = ner[:sm_items]
      item_list =  similar_items.split("[")
      item_list. each do | item|
        item  = item.gsub(']', '')
        if item.size() > 0
          stuff = item.split(",")
          @items << stuff
        end
      end
      return @items
    else
      return nil
    end
  end


end
