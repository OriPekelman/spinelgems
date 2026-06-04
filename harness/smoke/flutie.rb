# Smoke test for flutie — exercises core logic classes without Rails
require 'flutie/version'
require 'flutie/body_class'
require 'flutie/page_title'
require 'flutie/page_title_presenter'

# 1. VERSION constant
puts Flutie::VERSION

# 2. BodyClass — build a minimal controller stub
ControllerStub = Struct.new(:controller_path, :action_name)

stub = ControllerStub.new('admin/users', 'index')
bc = Flutie::BodyClass.new({}, stub)
puts bc.basic_body_class
puts bc.extra_body_classes_symbol

stub2 = ControllerStub.new('posts', 'show')
bc2 = Flutie::BodyClass.new({ extra_body_classes_symbol: :custom_classes }, stub2)
puts bc2.basic_body_class
puts bc2.extra_body_classes_symbol

# 3. PageTitle — options-driven separator and app_name
pt = Flutie::PageTitle.new(app_name: 'MyApp', separator: ' | ')
puts pt.app_name
puts pt.separator
puts pt.page_title_symbol

# 4. PageTitlePresenter — default order and reversed order
ptp1 = Flutie::PageTitlePresenter.new('MyApp', 'Dashboard', ' : ')
puts ptp1.to_s

ptp2 = Flutie::PageTitlePresenter.new('MyApp', 'Dashboard', ' : ', true)
puts ptp2.to_s

ptp_nil = Flutie::PageTitlePresenter.new('MyApp', nil, ' - ')
puts ptp_nil.to_s
