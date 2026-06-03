# frozen_string_literal: true

# chemlab-library-www-gitlab-com: GitLab handbook Chemlab page-object library.
# Provides GitlabHandbook::Page::About and GitlabHandbook::Page::FreeTrial.
# Both classes inherit from Chemlab::Page (a browser DSL); all real methods
# require a live browser. We stub Chemlab::Page to exercise the DSL metadata
# (path, public_elements) which is the pure-Ruby part of the library.

module Chemlab
  class Page
    @path = nil

    class << self
      def path(value = nil)
        value ? @path = value : @path
      end

      def public_elements
        @public_elements ||= []
      end

      # Stub the link DSL macro — records link metadata without browser calls
      def link(name, **opts)
        public_elements << { type: :link, name: name, args: [opts] }
      end
    end
  end
end

require 'gitlab_handbook/page/about'
require 'gitlab_handbook/page/free_trial'

# Exercise class-level metadata set by the DSL macros
puts GitlabHandbook::Page::About.path
puts GitlabHandbook::Page::FreeTrial.path

about_elements = GitlabHandbook::Page::About.public_elements
puts about_elements.length
puts about_elements.first[:name]
puts about_elements.first[:args].first[:text]
puts about_elements.first[:args].first[:href]

ft_elements = GitlabHandbook::Page::FreeTrial.public_elements
puts ft_elements.length
puts ft_elements.first[:name]
puts ft_elements.last[:name]
