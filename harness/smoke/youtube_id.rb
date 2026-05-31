puts YoutubeID.from("https://youtu.be/dQw4w9WgXcQ")
puts YoutubeID.from("https://www.youtube.com/watch?v=dQw4w9WgXcQ")
puts YoutubeID.from("https://www.youtube.com/watch?v=dQw4w9WgXcQ&feature=related")
puts YoutubeID.from("https://www.youtube.com/embed/dQw4w9WgXcQ")
puts YoutubeID.from("https://www.youtube.com/v/dQw4w9WgXcQ")
puts YoutubeID.from("youtu.be/dQw4w9WgXcQ").inspect
puts YoutubeID.from("not_a_youtube_url").inspect
