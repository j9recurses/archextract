json.array!(@extracts) do |extract|
  json.extract! extract, :id, :lda, :num_of_topics, :ner_people, :ner_organizations, :ner_places, :ner_dates
  json.url extract_url(extract, format: :json)
end
