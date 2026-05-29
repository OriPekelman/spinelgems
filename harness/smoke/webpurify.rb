# WebPurify::Constants — pure static methods, no network, no external gems
puts WebPurify::Constants.text_endpoints[:us]
puts WebPurify::Constants.text_endpoints[:eu]
puts WebPurify::Constants.text_endpoints[:ap]
puts WebPurify::Constants.image_endpoint
puts WebPurify::Constants.rest_path
puts WebPurify::Constants.format
puts WebPurify::Constants.scheme(false)
puts WebPurify::Constants.scheme(true)
puts WebPurify::Constants.methods[:check]
puts WebPurify::Constants.methods[:replace]
