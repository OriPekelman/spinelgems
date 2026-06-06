# frozen_string_literal: true

# Smoke: capybara_active_admin — exercises pure selector methods
# (Layout, Table, AttributesTable, Form) and Util module functions.
# No browser/Capybara session needed; all methods return plain strings.

require 'capybara/active_admin'

# ---- Layout selectors ----
include Capybara::ActiveAdmin::Selectors::Layout

puts action_items_container_selector
puts action_item_selector
puts flash_message_selector
puts flash_message_selector('notice')
puts flash_message_selector('alert')
puts page_title_selector
puts footer_selector
puts sidebar_selector
puts panel_selector
puts panel_title_selector
puts panel_content_selector
puts batch_actions_button_selector
puts dropdown_list_selector
puts batch_action_selector
puts modal_dialog_selector
puts tab_header_link_selector
puts tab_content_selector

# ---- Table selectors ----
include Capybara::ActiveAdmin::Selectors::Table

puts table_selector
puts table_row_selector
puts table_row_selector(42)
puts table_row_selector('99')
puts table_cell_selector
puts table_cell_selector('Name')
puts table_cell_selector('First Name')
puts table_cell_selector('Status/Type')
puts table_header_selector
puts table_scopes_container_selector
puts table_scope_selector

# ---- AttributesTable selectors ----
include Capybara::ActiveAdmin::Selectors::AttributesTable

puts attributes_table_selector
puts attributes_row_selector
puts attributes_row_selector('Name')
puts attributes_row_selector('Created At')
puts attributes_row_selector('First/Last Name')

# ---- Form selectors ----
include Capybara::ActiveAdmin::Selectors::Form

puts form_selector
puts label_selector
puts inline_error_selector
puts semantic_error_selector
puts has_many_fields_selector('comments')
puts has_many_fields_selector('tags')
puts has_many_container_selector('images')
puts form_submit_selector
puts form_submit_selector('Save')
puts form_submit_selector('Create User')
puts filter_form_selector

# ---- Util functions ----
puts Capybara::ActiveAdmin::Util.options_with_text('Login').inspect
puts Capybara::ActiveAdmin::Util.options_with_text('Search', exact: true).inspect
puts Capybara::ActiveAdmin::Util.options_with_text('Filter', exact: false).inspect
