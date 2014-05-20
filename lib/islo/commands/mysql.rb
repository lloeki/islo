require 'islo/command'

module Islo
  # MySQL support
  module Mysql
    # MySQL client
    class Client < Command
      def self.name
        :mysql
      end

      def args
        %W(
          --socket=#{wd}/tmp/sockets/mysql.sock
          -uroot
        ) + super
      end

      Islo.register(self)
    end

    # MySQL server
    class Server < Command
      def self.name
        :mysqld
      end

      def args
        %W(
          --no-defaults
          --datadir=#{wd}/db/mysql
          --pid-file=#{wd}/tmp/pids/mysqld.pid
          --socket=#{wd}/tmp/sockets/mysql.sock
          --skip-networking
        ) + super
      end

      Islo.register(self)
    end

    # MySQL initializer
    class Init < Command
      def self.name
        :mysql_install_db
      end

      def args
        %W(
          --no-defaults
          --basedir=#{Mysql.basedir}
          --datadir=#{wd}/db/mysql
          --pid-file=#{wd}/tmp/pids/mysqld.pid
        ) + super
      end

      Islo.register(self)
    end

    def self.basedir
      path = %x(which mysql)

      fail Command::Error, 'could not find mysql' if path.empty?

      path = File.dirname(path)
      path = File.dirname(path)

      path
    end
  end
end
