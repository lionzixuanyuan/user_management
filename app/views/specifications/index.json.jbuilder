json.array!(@specifications) do |specification|
  json.extract! specification, :id, :creater_id, :brand, :model, :pdf
  json.url specification_url(specification, format: :json)
end
