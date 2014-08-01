json.array!(@documents) do |document|
  json.extract! document, :id, :name, :collection_id, :file_dir
  json.url document_url(document, format: :json)
end
