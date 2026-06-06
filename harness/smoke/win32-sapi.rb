# win32-sapi smoke — Windows SAPI5 TTS/ASR COM automation wrapper.
# The gem requires 'win32ole' (Windows-only C extension); fails on Linux.
# Smoke exercises the require and class constant structure only.

require 'win32/sapi5'

# SpVoice flag constants (pure Ruby, no COM instantiation needed)
puts Win32::SAPI5::VERSION
puts Win32::SpVoice::SPF_DEFAULT
puts Win32::SpVoice::SPF_ASYNC
puts Win32::SpVoice::SPF_PURGEBEFORESPEAK
puts Win32::SpVoice::SPF_IS_FILENAME
puts Win32::SpVoice::SPF_IS_XML
puts Win32::SpVoice::SPF_IS_NOT_XML

# Class ancestry
puts Win32::SpVoice.superclass.name
puts Win32::SpAudioFormat.superclass.name
