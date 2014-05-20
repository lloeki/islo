require 'islo/command'

module Islo
  # PostgreSQL support
  module Postgres
    # PostgreSQL client
    class Client < Command
      def self.name
        :psql
      end

      def args
        %W(--host=#{wd}/tmp/sockets) + super
      end

      Islo.register(self)
    end

    # PostgreSQL server
    class Server < Command
      def self.name
        :postgres
      end

      def args
        %W(
          -D #{wd}/db/postgres
          -k #{wd}/tmp/sockets
        ) + ['-h', ''] + super
      end

      Islo.register(self)
    end

    # PostgreSQL initializer
    class Init < Command
      def self.name
        :initdb
      end

      def args
        %W(
          -D #{wd}/db/postgres
        ) + super
      end

      Islo.register(self)
    end
  end
end
