# frozen_string_literal: true
# Smoke test for eh-openai gem
# Exercises data model classes and constants without network calls

require 'openai'

# 1. SortOrder constants
puts OpenAI::SortOrder::ASC
puts OpenAI::SortOrder::DESC

# 2. Assistant model - constructed from a hash (simulating API response)
assistant_data = {
  'id' => 'asst_abc123',
  'object' => 'assistant',
  'created_at' => 1700000000,
  'name' => 'Test Assistant',
  'description' => 'A helper',
  'model' => 'gpt-4o',
  'instructions' => 'You are helpful.',
  'tools' => [],
  'tool_resources' => nil,
  'metadata' => {},
  'temperature' => 1.0,
  'top_p' => 1.0,
  'response_format' => 'auto'
}
asst = OpenAI::Model::Assistant.new(assistant_data)
puts asst.id
puts asst.name
puts asst.model
puts asst.temperature

# 3. Run model - constructed from a hash
run_data = {
  'id' => 'run_xyz789',
  'object' => 'thread.run',
  'created_at' => 1700000100,
  'thread_id' => 'thread_t1',
  'assistant_id' => 'asst_abc123',
  'status' => 'completed',
  'model' => 'gpt-4o',
  'temperature' => 0.7,
  'top_p' => 0.9,
  'tools' => [],
  'metadata' => {},
  'usage' => nil
}
run = OpenAI::Model::Run.new(run_data)
puts run.id
puts run.status
puts run.thread_id
puts run.temperature

# 4. Message model
msg_data = {
  'id' => 'msg_m1',
  'object' => 'thread.message',
  'created_at' => 1700000200,
  'thread_id' => 'thread_t1',
  'role' => 'assistant',
  'status' => 'completed',
  'content' => [{'type' => 'text', 'text' => {'value' => 'Hello!'}}],
  'assistant_id' => 'asst_abc123',
  'metadata' => {}
}
msg = OpenAI::Model::Message.new(msg_data)
puts msg.id
puts msg.role

# 5. ListAssistants model wrapping a list
list_data = {
  'object' => 'list',
  'data' => [assistant_data],
  'first_id' => 'asst_abc123',
  'last_id' => 'asst_abc123',
  'has_more' => false
}
list = OpenAI::Model::ListAssistants.new(list_data)
puts list.data.length
puts list.data.first.name
puts list.has_more

# 6. Error class exists and inherits from StandardError
puts OpenAI::Error.ancestors.include?(StandardError)

# 7. OpenAPIException attributes
ex = OpenAI::OpenAPIException.new({'message' => 'bad request', 'type' => 'invalid_request_error', 'param' => nil, 'code' => nil})
puts ex.message
puts ex.type
