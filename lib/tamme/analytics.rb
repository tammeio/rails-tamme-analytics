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
      @batch = []
      @batch_size = options[:batch_size] ? options[:batch_size] : 5
      @debug = options[:debug] ? options[:debug] : false
      @flushing = false
    end

    def track(identity_id, event_name, traits)
      base_event = {}
      base_event[:event_type] = "track"
      base_event[:identity_id] = identity_id
      base_event[:name] = event_name
      base_event[:traits] = merge(base_params, traits)

      if @debug
        puts 'adding event to batch: ', base_event
      end
      @batch.push(base_event)

      if @batch.length >= @batch_size
        # flush this immediately
        flush
      end

      return "Completed"
    end

    def identify(p1, p2)
      base_event = {}
      traits = {}

      if type(p1) === "string"
        base_event[identity_id] = p1
        traits = p2
      else
        traits = p1
      end

      base_event[:event_type] = "identify"
      base_event[:traits] = merge(base_params, traits)
      @batch.push(base_event)

      if @batch.length >= @batch_size
        # flush this immediately
        flush
      end
    end

    def alias(p1, p2)
      base_event = {
        new_id: p1
      }
      if p2
        base_event[:previous_id] = p2
      end
      base_event[:event_type] = "alias"
      @batch.push(base_event)

      if @batch.length >= @batch_size
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
        :account_id => @write_key
      }
      @batch = []
      postToTamme(self, params) { |client|
        @flushing = false
        if @batch.length >= @batch_size
          flush
        end
        if @debug
          puts 'post to tamme completed'
        end
      }
      return "Queued"
    end

    def postToTamme(analytics, params, callback)
      postData = params.to_json
      # puts 'post to tamem data: ', postData
      options = {
        :hostname => 'analytics.tamme.io',
        :port => 443,
        :path => '/test/batch-upload',
        :method => 'POST',
        :headers => {
            'Content-Type' => 'application/json',
            'Content-Length' => Buffer.byteLength(postData)
        }
      }

      http = Net::HTTP.new(options[:hostname], options[:port])
      http.use_ssl = true
      request = Net::HTTP:Post.new(options[:path], options[:headers])

      http.request(request) { |response|
        case response.code
        when 200
            # puts "STATUS: #{res.statusCode}"
            # puts "HEADERS: #{(res.headers).to_json}"
          response.force_encoding('utf-8')
          response.read_body { |chunk|
            # puts 'BODY: #{chunk}'
            # puts 'response data: ', chunk
          }
          response.finish do
            # puts 'No more data in response.'
            callback
          end
          # puts 'request to flush: ', req
        else
          response { |e|
          # puts 'problem with request: #{e.message}''
          # puts 'error: ', e
          }
        end
      }

      # write data to request body
      request.body = postData
      request.finish
    end

    def merge
      obj = {}
      for i in arguments
        for key in arguments[i]
          if arguments[i].hasKey? key
            obj[key] = arguments[i][key]
          end
        end
      end
      return obj
    end
  end
end
