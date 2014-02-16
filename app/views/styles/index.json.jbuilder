json.array!(@styles) do |style|
  json.extract! style, :id, :name, :desc
  json.url style_url(style, format: :json)
end
