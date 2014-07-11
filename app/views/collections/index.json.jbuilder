json.array!(@collections) do |collection|
  json.extract! collection, :id, :collectin_id, :collection_name, :acquisition_date, :acquisition_source, :start_date, :end_date, :src_datadir, :notes
  json.url collection_url(collection, format: :json)
end
