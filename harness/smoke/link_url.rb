puts LinkUrl.convert("Visit http://www.example.com for more info.")
puts LinkUrl.convert("Contact us at info@example.com please.")
puts LinkUrl.convert_image("See www.example.com/photo.png for the image.")
puts LinkUrl.convert_all("Go to www.example.com or see www.example.com/logo.png")
puts LinkUrl.convert(nil).inspect
puts LinkUrl.tlds['com']
puts LinkUrl.tlds['org']
