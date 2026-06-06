# Smoke test for ros-apartment-activejob
# Stubs ActiveSupport::Concern and Apartment::Tenant (plain requires are ignored by Spinel)

# Minimal ActiveSupport::Concern stub
module ActiveSupport
  module Concern
    def self.extended(base)
      base.instance_variable_set(:@_class_methods, Module.new)
    end

    def class_methods(&block)
      @_class_methods ||= Module.new
      @_class_methods.module_eval(&block)
    end

    def included(base)
      cm = @_class_methods
      if cm
        base.extend(cm)
      end
    end
  end
end

# Minimal Apartment::Tenant stub
module Apartment
  module Tenant
    @current = 'public'

    def self.current
      @current
    end

    def self.switch(tenant)
      prev = @current
      @current = tenant
      result = yield
      @current = prev
      result
    end
  end
end

require 'apartment/active_job'
require 'apartment/active_job/version'

# A base job class to include the mixin into
class BaseJob
  def self.execute(job_data)
    new.perform(job_data)
  end

  def serialize
    { 'job_class' => self.class.name }
  end

  def perform(job_data)
    "performed with #{job_data.inspect}"
  end
end

class MyJob < BaseJob
  include Apartment::ActiveJob
end

# Test 1: serialize merges tenant
job = MyJob.new
Apartment::Tenant.instance_variable_set(:@current, 'acme')
result = job.serialize
puts "serialize tenant: #{result['tenant']}"
puts "serialize job_class: #{result['job_class']}"

# Test 2: execute switches tenant context
executed_in = nil
original_execute = BaseJob.method(:execute)
BaseJob.define_singleton_method(:execute) do |job_data|
  executed_in = Apartment::Tenant.current
  "base_executed"
end

# Reset current to public before execute test
Apartment::Tenant.instance_variable_set(:@current, 'public')

MyJob.execute({ 'tenant' => 'beta_corp', 'job_class' => 'MyJob' })
puts "execute switched tenant to: #{executed_in}"
puts "tenant restored after execute: #{Apartment::Tenant.current}"

# Test 3: serialize uses current tenant
Apartment::Tenant.instance_variable_set(:@current, 'gamma')
job2 = MyJob.new
s2 = job2.serialize
puts "serialize tenant gamma: #{s2['tenant']}"

puts "VERSION: #{Apartment::ActiveJob::VERSION}"
