# frozen_string_literal: true
# Smoke: google-apps-chat-v1
# Exercises the Paths helper module (pure string interpolation, no network/FS)
require "google/apps/chat/v1/chat_service/paths"

P = Google::Apps::Chat::V1::ChatService::Paths

# space_path
puts P.space_path(space: "AAAAbc123")

# message_path
puts P.message_path(space: "AAAAbc123", message: "msg456")

# attachment_path
puts P.attachment_path(space: "AAAAbc123", message: "msg456", attachment: "att789")

# membership_path
puts P.membership_path(space: "AAAAbc123", member: "users/me")

# reaction_path
puts P.reaction_path(space: "AAAAbc123", message: "msg456", reaction: "thumbsup")

# thread_path
puts P.thread_path(space: "AAAAbc123", thread: "thr001")

# thread_read_state_path
puts P.thread_read_state_path(space: "AAAAbc123", user: "user99", thread: "thr001")

# space_read_state_path
puts P.space_read_state_path(user: "user99", space: "AAAAbc123")

# space_event_path
puts P.space_event_path(space: "AAAAbc123", space_event: "evt007")

# custom_emoji_path
puts P.custom_emoji_path(custom_emoji: "party-parrot")

# user_path
puts P.user_path(user: "user99")

# space_path has NO slash guard (by design) — just interpolates
puts P.space_path(space: "with/slash")

# Verify that slash-guard raises on methods that DO guard
begin
  P.message_path(space: "bad/space", message: "msg")
  puts "ERROR: should have raised"
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

begin
  P.thread_read_state_path(user: "u1", space: "bad/space", thread: "t1")
  puts "ERROR: should have raised"
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

puts "done"
