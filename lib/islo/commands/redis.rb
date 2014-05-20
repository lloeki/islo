require 'islo/command'

module Islo
  # Redis support
  module Redis
    # Redis client
    class Client < Command
      def self.name
        :'redis-cli'
      end

      def args
        %w(-s redis.sock)
      end

      # Change working directory (makes for a nicer prompt)
      def wd
        super + 'tmp/sockets'
      end

      Islo.register(self)
    end

    # Redis server
    class Server < Command
      def self.name
        :'redis-server'
      end

      def args
        %W(#{wd}/db/redis/redis.conf)
      end

      Islo.register(self)
    end

    # Redis initializer
    #
    # Creates a minimal configuration because redis-server doesn't accept
    # arguments allowing for paths to be set.
    class Init < Command
      def self.name
        :'redis-init'
      end

      def exec
        FileUtils.mkdir_p(wd + 'db/redis')

        File.open(wd + 'db/redis/redis.conf', 'w') do |f|
          f << template.gsub('${WORKING_DIR}', wd.to_s)
        end
      rescue SystemCallError => e
        raise Command::Error, e.message
      end

      private

      # rubocop:disable MethodLength,LineLength
      def template
        <<-EOT.gsub(/^ +/, '')
          daemonize no
          pidfile ${WORKING_DIR}/pids/redis.pid
          port 0
          bind 127.0.0.1
          unixsocket ${WORKING_DIR}/tmp/sockets/redis.sock
          unixsocketperm 700
          timeout 0
          tcp-keepalive 0
          loglevel notice
          databases 1
          save 900 1
          save 300 10
          save 60 10000
          stop-writes-on-bgsave-error yes
          rdbcompression yes
          rdbchecksum yes
          dbfilename dump.rdb
          dir ${WORKING_DIR}/db/redis
          slave-serve-stale-data yes
          slave-read-only yes
          repl-disable-tcp-nodelay no
          slave-priority 100
          appendonly yes
          appendfsync everysec
          no-appendfsync-on-rewrite no
          auto-aof-rewrite-percentage 100
          auto-aof-rewrite-min-size 64mb
          lua-time-limit 5000
          slowlog-log-slower-than 10000
          slowlog-max-len 128
          hash-max-ziplist-entries 512
          hash-max-ziplist-value 64
          list-max-ziplist-entries 512
          list-max-ziplist-value 64
          set-max-intset-entries 512
          zset-max-ziplist-entries 128
          zset-max-ziplist-value 64
          activerehashing yes
          client-output-buffer-limit normal 0 0 0
          client-output-buffer-limit slave 256mb 64mb 60
          client-output-buffer-limit pubsub 32mb 8mb 60
        EOT
      end

      Islo.register(self)
    end
  end
end
