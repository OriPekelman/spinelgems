# frozen_string_literal: true

require 'video2gif'

# --- Utils.duration_to_seconds ---
puts Video2gif::Utils.duration_to_seconds('01:23:45')       # 5025
puts Video2gif::Utils.duration_to_seconds('10:30')          # 630
puts Video2gif::Utils.duration_to_seconds('01:02:03.500')   # 3723.500
puts Video2gif::Utils.duration_to_seconds('42')             # 42 (no colon, passthrough)

# --- FFmpeg filter helpers ---
opts_plain = { fps: 15, width: 320 }
puts Video2gif::FFmpeg.fps(opts_plain)        # fps=15
puts Video2gif::FFmpeg.scale(opts_plain)      # scale=flags:...:width=320:...

opts_crop = { wregion: '640', hregion: '360', xoffset: '0', yoffset: '0' }
puts Video2gif::FFmpeg.crop(opts_crop)        # crop=w=640:h=360:x=0:y=0

opts_eq = { contrast: '1.2', brightness: '0.1', saturation: '1.5' }
puts Video2gif::FFmpeg.eq(opts_eq)            # eq=contrast=...:brightness=...:saturation=...

# --- FFmpeg.text (smart-quote substitution) ---
puts Video2gif::FFmpeg.text({ text: 'Hello "world"' })   # curly-quoted version
puts Video2gif::FFmpeg.text({ text: "it's a test" })     # right-curly apostrophe

# --- FFmpeg.palettegen / paletteuse ---
puts Video2gif::FFmpeg.palettegen({ palette: 128, palettemode: 'full' })
puts Video2gif::FFmpeg.paletteuse({ dither: 'bayer', palettemode: 'diff' })

# --- FFmpeg.filtergraph (no subtitles, no rate, no tonemap) ---
opts_fg = { fps: 10, width: 400, text: 'Test GIF',
            input_filename: 'in.mp4', output_filename: 'out.gif' }
fg = Video2gif::FFmpeg.filtergraph(opts_fg)
puts fg.is_a?(Array)   # true
puts fg.first          # fps=10
puts fg.include?(Video2gif::FFmpeg.scale(opts_fg))   # true
