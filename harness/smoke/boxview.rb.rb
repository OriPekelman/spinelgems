# Smoke test for boxview.rb (BoxView API client)
# httmultiparty is not available; stub it so we can load the gem's pure logic.
module HTTMultiParty
  def self.included(base); end
  def self.extended(base); end
end

# Stub base_uri / post / get / put / delete so BoxView module can be extended
module HTTMultiParty
  def base_uri(uri = nil); @_base_uri = uri if uri; @_base_uri; end
end

require_relative '/home/oripekelman/.cache/spinel-compat/gems/boxview.rb-0.1.3/lib/boxview/errors'
require_relative '/home/oripekelman/.cache/spinel-compat/gems/boxview.rb-0.1.3/lib/boxview/document'
require_relative '/home/oripekelman/.cache/spinel-compat/gems/boxview.rb-0.1.3/lib/boxview/session'

module BoxView
  include HTTMultiParty
  extend HTTMultiParty

  BASE_URI = 'https://view-api.box.com'
  MULTIPART_URI = 'https://upload.view-api.box.com'
  BASE_PATH = '/1'

  class << self
    attr_accessor :api_key, :document_id, :session_id

    def headers
      {
        'Authorization' => "Token #{api_key}",
        'Content-type'  => 'application/json'
      }
    end

    def api_key
      raise BoxView::Errors::ApiKeyNotFound if @api_key.nil?
      @api_key
    end

    def document_id
      raise BoxView::Errors::DocumentIdNotFound if @document_id.nil?
      @document_id
    end

    def session_id
      raise BoxView::Errors::SessionIdNotFound if @session_id.nil?
      @session_id
    end

    def base_uri(uri = nil)
      @_base_uri = uri if uri
      @_base_uri || BASE_URI
    end
  end
end

# --- exercise error classes ---
begin
  BoxView.api_key
rescue BoxView::Errors::ApiKeyNotFound => e
  puts "ApiKeyNotFound: #{e.message}"
end

begin
  BoxView.document_id
rescue BoxView::Errors::DocumentIdNotFound => e
  puts "DocumentIdNotFound: #{e.message}"
end

begin
  BoxView.session_id
rescue BoxView::Errors::SessionIdNotFound => e
  puts "SessionIdNotFound: #{e.message}"
end

# --- exercise constants ---
puts "BASE_URI: #{BoxView::BASE_URI}"
puts "BASE_PATH: #{BoxView::BASE_PATH}"
puts "Document::PATH: #{BoxView::Document::PATH}"
puts "Session::PATH: #{BoxView::Session::PATH}"
puts "ZIP: #{BoxView::Document::ZIP}"
puts "PDF: #{BoxView::Document::PDF}"

# --- exercise path helpers ---
puts "document_path: #{BoxView::Document.document_path}"
puts "session_path: #{BoxView::Session.session_path}"

# --- exercise headers after setting api_key ---
BoxView.api_key = 'test' + 'key123'
h = BoxView.headers
puts "Authorization header: #{h['Authorization']}"
puts "Content-type header: #{h['Content-type']}"

# --- exercise supported_mimetypes and supported_file_extensions ---
puts "supported_mimetypes count: #{BoxView::Document.supported_mimetypes.length}"
puts "supported_file_extensions: #{BoxView::Document.supported_file_extensions.join(',')}"

# --- exercise URL builders (document_id + dimensions required) ---
BoxView.document_id = 'doc' + 'abc123'
BoxView::Document.instance_variable_set(:@width, 320)
BoxView::Document.instance_variable_set(:@height, 240)
puts "dimensions: #{BoxView::Document.dimensions}"
puts "thumbnail_params: #{BoxView::Document.thumbnail_params}"
puts "thumbnail_url: #{BoxView::Document.thumbnail_url}"
puts "asset_url (default zip): #{BoxView::Document.asset_url}"

BoxView::Document.type = 'pdf'
puts "asset_url (pdf): #{BoxView::Document.asset_url}"

# --- exercise session URL helpers ---
BoxView.session_id = 'sess' + 'xyz456'
puts "viewer_url: #{BoxView::Session.viewer_url}"
puts "viewerjs_url: #{BoxView::Session.viewerjs_url}"

# --- exercise Errors base class ---
err = BoxView::Errors.new("test error")
puts "Errors base: #{err.message}"

err400 = BoxView::Errors.new("base msg", 400)
puts "Errors with 400: #{err400.message}"

# --- never_expire sets a far-future date ---
BoxView::Session.never_expire
puts "never_expire set: #{BoxView::Session.instance_variable_get(:@expiration_date) > Time.now}"
