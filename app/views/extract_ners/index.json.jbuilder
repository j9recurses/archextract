json.array!(@extract_ners) do |extract_ner|
  json.extract! extract_ner, :id, :status, :fname_base, :file_dir, :status
  json.url extract_ner_url(extract_ner, format: :json)
end
