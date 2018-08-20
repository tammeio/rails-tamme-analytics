require "tamme/analytics/version"
require 'json'
require 'net/http'

module Tamme
  class Analytics
    @base_params = {
      :version => '1.0.0',
      :library => 'tamme-gem-analytics'
    }

    def initialize(writekey, options)
      @write_key = writekey
      if options == nil 
        options = {}
      end
      @batch = []
      @batch_size = options[:batch_size].present? ? options[:batch_size] : 5
      @debug = options[:debug].present? ? options[:debug] : false
      @flushing = false
    end

    def track(identity_id, event_name, traits)
      base_event = {}
      base_event[:event_type] = "track"
      base_event[:identity_id] = identity_id
      base_event[:name] = event_name
      base_event[:traits] = merge(@base_params, traits)
      base_event[:write_key] = @write_key

      if @debug
        puts 'adding event to batch: ', base_event
      end
      @batch.push(base_event)

      if @batch.count >= @batch_size
        flush
      end

      return "Completed"
    end

    def identify(identity_id, traits)
      base_event = {}
      traits = {}

      base_event[:identity_id] = identity_id
        traits = traits
      base_event[:write_key] = @write_key
      base_event[:event_type] = "identify"
      base_event[:traits] = merge(@base_params, traits)
      @batch.push(base_event)

      if @batch.count >= @batch_size
        flush
      end
    end

    def alias(new_id, previous_id)
      base_event = {
        new_id: new_id,
        previous_id: previous_id,
      }
      base_event[:event_type] = "alias"
      base_event[:write_key] = @write_key
      @batch.push(base_event)

      if @batch.count >= @batch_size
        flush
      end
      return "Completed"
    end

    def flush
      return unless !@flushing
      @flushing = true
      events = @batch
      params = {
        :events => events,
        :account_id => @write_key,
        :write_key => @write_key,
      }
      @batch = []
      self.postToTamme(params)
      @flushing = false
      if @batch.count >= @batch_size
        self.flush
      end
      return "Queued"
    end

    def postToTamme(params)
      postData = params.to_json
      options = {
        :hostname => 'anl.tamme.io',
        :port => 443,
        :path => '/stream',
        :method => 'POST',
        :headers => {
            'Content-Type' => 'application/json',
            'Content-Length' => postData.length.to_s
        }
      }
      http = Net::HTTP.new(options[:hostname], options[:port])
      http.use_ssl = true
      request = Net::HTTP::Post.new(options[:path], options[:headers])
      request.body = postData
      response = http.request(request)
      http.finish if http.started?
    end

    def merge(*arguments)
      obj = {}
      arguments.each do |arg|
        if arg.present?
          arg.each do |key, value|
            obj[key] = value
          end
        end
        
      end
      return obj
    end
  end
end
