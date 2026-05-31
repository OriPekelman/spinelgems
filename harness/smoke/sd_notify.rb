# Smoke test for sd_notify gem
# Constants
puts SdNotify::READY
puts SdNotify::RELOADING
puts SdNotify::STOPPING
puts SdNotify::WATCHDOG
puts SdNotify::FDSTORE
puts SdNotify::STATUS
puts SdNotify::ERRNO
puts SdNotify::MAINPID
# watchdog? with no env vars set should return false
puts SdNotify.watchdog?.inspect
# notify returns nil when NOTIFY_SOCKET is not set
puts SdNotify.notify("READY=1").inspect
