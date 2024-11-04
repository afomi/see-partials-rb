# frozen_string_literal: true

require_relative "version"

module SeePartials
  # class Error < StandardError; end

  # Patching ActionView::Base to add a wrapper around partials
  module ActionViewExtensions
    def render(*args, &block)
      # Detect if we're rendering a partial (string or hash form)
      partial_path = if args.first.is_a?(Hash) && args.first[:partial]
                        args.first[:partial]
                      elsif args.first.is_a?(String)
                        args.first
                      end

      if partial_path && $SEE_PARTIALS != false
        # Get the original rendered content of the partial
        content = super(*args, &block)

        # Wrap the content in a div with a red border and path display
        <<~HTML.html_safe
          <div style="border: 2px solid red; margin: 2px;">
            <span
              style="color: red; font-size: 12px; font-family: monospace; padding: 0 4px;">
              partial: #{partial_path}
            </span>
            #{content}
          </div>
        HTML
      else
        # Call the original render method for non-partial rendering
        super(*args, &block)
      end
    end
  end
end

ActionView::Base.prepend SeePartials::ActionViewExtensions
