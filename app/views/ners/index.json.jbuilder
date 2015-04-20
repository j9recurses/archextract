json.array!(@ners) do |ner|
  json.extract! ner, :id, :nertype, :name, :docs, :count
  json.url ner_url(ner, format: :json)
end
