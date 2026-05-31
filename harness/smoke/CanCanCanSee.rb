# Test the constant defined directly in the module body
puts CanCanCanSee::MY_GLOBAL_HOLDER_OF_ABILITY.class

# Test read_file with a synthetic ability file string
# (no filesystem access - drive the pure string processing)
synthetic_ability = <<~RUBY
  def my_ability(user)
    user.roles.each do |role|
      case role
      when :admin do
        can :manage, :all
        cannot :destroy, Order
      when :editor do
        can :read, Article
        can :create, Article
      end
    end
  end
RUBY

CanCanCanSee.read_file(synthetic_ability)
roles = CanCanCanSee::MY_GLOBAL_HOLDER_OF_ABILITY.keys.sort
puts roles.inspect
puts CanCanCanSee::MY_GLOBAL_HOLDER_OF_ABILITY.is_a?(Hash)
