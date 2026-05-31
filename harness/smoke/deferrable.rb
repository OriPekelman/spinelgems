class MyTask
  include Deferrable

  def run
    deferred { puts "deferred block 1" }
    deferred { puts "deferred block 2" }
    puts "immediate"
    complete_deferred
  end

  def with_now_and_later
    now_and_later { puts "both" }
    complete_deferred
  end

  def skip_when_disabled
    deferred(false) { puts "not deferred" }
  end
end

t = MyTask.new
t.skip_when_disabled
t.run
t.with_now_and_later
