puts FacebookUsernameExtractor.extract("https://www.facebook.com/johndoe")
puts FacebookUsernameExtractor.extract("https://www.facebook.com/people/John-Doe/123456789").inspect
puts FacebookUsernameExtractor.extract("https://www.facebook.com/pages/My-Page/123456").inspect
puts FacebookUsernameExtractor.extract("https://www.facebook.com/#!/johndoe")
puts FacebookUsernameExtractor.extract("https://www.facebook.com/profile.php?id=123456789")
puts FacebookUsernameExtractor.extract("").inspect
puts FacebookUsernameExtractor.extract("https://www.facebook.com/search/people/?q=test").inspect
