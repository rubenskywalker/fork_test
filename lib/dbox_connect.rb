module DboxCinect
    class Options

      # How to format the response [:object, :body, :parse_body]
      attr_accessor :response

      # HTTP headers to include in the request
      attr_accessor :headers

      # Query string params to add to the url
      attr_accessor :params

      # Form data to embed in the request
      attr_accessor :form

      # Explicit request body of the request
      attr_accessor :body

      # HTTP proxy to route request
      attr_accessor :proxy

      # Before callbacks
      attr_accessor :callbacks

      # Socket classes
      attr_accessor :socket_class, :ssl_socket_class

      # SSL context
      attr_accessor :ssl_context

      # Follow redirects
      attr_accessor :follow

      protected :response=, :headers=, :proxy=, :params=, :form=,  :callbacks=, :follow=

      @default_socket_class     = TCPSocket
      @default_ssl_socket_class = OpenSSL::SSL::SSLSocket

      class << self
        attr_accessor :default_socket_class, :default_ssl_socket_class

        def new(options = {})
          return options if options.is_a?(self)
          super
        end
      end

      def initialize(options = {})
        @response  = options[:response]  || :auto
        @headers   = options[:headers]   || {}
        @proxy     = options[:proxy]     || {}
        @callbacks = options[:callbacks] || {:request => [], :response => []}
        @body      = options[:body]
        @params      = options[:params]
        @form      = options[:form]
        @follow    = options[:follow]

        @socket_class     = options[:socket_class]     || self.class.default_socket_class
        @ssl_socket_class = options[:ssl_socket_class] || self.class.default_ssl_socket_class
        @ssl_context      = options[:ssl_context]

        @headers["User-Agent"] ||= "RubyHTTPGem/#{HTTP::VERSION}"
      end

      def with_response(response)
        unless [:auto, :object, :body, :parsed_body].include?(response)
          argument_error! "invalid response type: #{response}"
        end
        dup do |opts|
          opts.response = response
        end
      end

      def with_headers(headers)
        unless headers.respond_to?(:to_hash)
          argument_error! "invalid headers: #{headers}"
        end
        dup do |opts|
          opts.headers = self.headers.merge(headers.to_hash)
        end
      end

      def with_proxy(proxy_hash)
        dup do |opts|
          opts.proxy = proxy_hash
        end
      end

      def with_params(params)
        dup do |opts|
          opts.params = params
        end
      end

      def with_form(form)
        dup do |opts|
          opts.form = form
        end
      end

      def with_body(body)
        dup do |opts|
          opts.body = body
        end
      end

      def with_follow(follow)
        dup do |opts|
          opts.follow = follow
        end
      end

      def with_callback(event, callback)
        unless callback.respond_to?(:call)
          argument_error! "invalid callback: #{callback}"
        end
        unless callback.respond_to?(:arity) and callback.arity == 1
          argument_error! "callback must accept only one argument"
        end
        unless [:request, :response].include?(event)
          argument_error! "invalid callback event: #{event}"
        end
        dup do |opts|
          opts.callbacks = callbacks.dup
          opts.callbacks[event] = (callbacks[event].dup << callback)
        end
      end

      def [](option)
        send(option) rescue nil
      end

      def merge(other)
        h1, h2 = to_hash, other.to_hash
        merged = h1.merge(h2) do |k,v1,v2|
          case k
          when :headers
            v1.merge(v2)
          when :callbacks
            v1.merge(v2){|event,l,r| (l+r).uniq}
          else
            v2
          end
        end

        self.class.new(merged)
      end

      def to_hash
        # FIXME: hardcoding these fields blows! We should have a declarative
        # way of specifying all the options fields, and ensure they *all*
        # get serialized here, rather than manually having to add them each time
        {
          :response         => response,
          :headers          => headers,
          :proxy            => proxy,
          :params           => params,
          :form             => form,
          :body             => body,
          :callbacks        => callbacks,
          :follow           => follow,
          :socket_class     => socket_class,
          :ssl_socket_class => ssl_socket_class,
          :ssl_context      => ssl_context
       }
      end

      def dup
        dupped = super
        yield(dupped) if block_given?
        dupped
      end

      private

      def argument_error!(message)
        raise ArgumentError, message, caller[1..-1]
      end

    end
  
  module Chainable
    def head(uri, options = {})
      request :head, uri, options
    end

    # Get a resource
    def get(uri, options = {})
      request :get, uri, options
    end

    # Post to a resource
    def post(uri, options = {})
      request :post, uri, options
    end

    # Put to a resource
    def put(uri, options = {})
      request :put, uri, options
    end

    # Delete a resource
    def delete(uri, options = {})
      request :delete, uri, options
    end

    # Echo the request back to the client
    def trace(uri, options = {})
      request :trace, uri, options
    end

    # Return the methods supported on the given URI
    def options(uri, options = {})
      request :options, uri, options
    end

    # Convert to a transparent TCP/IP tunnel
    def connect(uri, options = {})
      request :connect, uri, options
    end

    # Apply partial modifications to a resource
    def patch(uri, options = {})
      request :patch, uri, options
    end

    # Make an HTTP request with the given verb
    def request(verb, uri, options = {})
      branch(options).request verb, uri
    end

    # Make a request invoking the given event callbacks
    def on(event, &block)
      branch default_options.with_callback(event, block)
    end

    # Make a request through an HTTP proxy
    def via(*proxy)
      proxy_hash = {}
      proxy_hash[:proxy_address] = proxy[0] if proxy[0].is_a? String
      proxy_hash[:proxy_port]    = proxy[1] if proxy[1].is_a? Integer
      proxy_hash[:proxy_username]= proxy[2] if proxy[2].is_a? String
      proxy_hash[:proxy_password]= proxy[3] if proxy[3].is_a? String

      if proxy_hash.keys.size >=2
        branch default_options.with_proxy(proxy_hash)
      else
        raise ArgumentError, "invalid HTTP proxy: #{proxy_hash}"
      end
    end
    alias_method :through, :via

    # Specify the kind of response to return (:auto, :object, :body, :parsed_body)
    def with_response(response_type)
      branch default_options.with_response(response_type)
    end

    # Alias for with_response(:object)
    def stream; with_response(:object); end

    def with_follow(follow)
      branch default_options.with_follow(follow)
    end

    # Make a request with the given headers
    def with_headers(headers)
      branch default_options.with_headers(headers)
    end
    alias_method :with, :with_headers

    # Accept the given MIME type(s)
    def accept(type)
      if type.is_a? String
        with :accept => type
      else
        mime_type = HTTP::MimeType[type]
        raise ArgumentError, "unknown MIME type: #{type}" unless mime_type
        with :accept => mime_type.type
      end
    end

    def default_options
      @default_options ||= HTTP::Options.new
    end

    def default_options=(opts)
      @default_options = HTTP::Options.new(opts)
    end

    def default_headers
      default_options.headers
    end

    def default_headers=(headers)
      @default_options = default_options.dup do |opts|
        opts.headers = headers
      end
    end

    def default_callbacks
      default_options.callbacks
    end

    def default_callbacks=(callbacks)
      @default_options = default_options.dup do |opts|
        opts.callbacks = callbacks
      end
    end

    private

    def branch(options)
      HTTP::Client.new(options)
    end
  end
end