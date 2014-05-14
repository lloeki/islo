require 'slop'
require 'islo'
require 'rainbow/ext/string'

module Islo
  # Handle and run the command line interface
  class CLI
    NAME = File.basename($PROGRAM_NAME)

    # See sysexits(3)
    RC = { ok:           0,
           error:        1,
           usage:       64,
           data:        65,
           noinput:     66,
           nouser:      67,
           nohost:      68,
           unavailable: 69,
           software:    70,
           oserr:       71,
           osfile:      72,
           cantcreat:   73,
           ioerr:       74,
           tempfail:    75,
           protocol:    76,
           noperm:      77,
           config:      78 }

    # Shortcut for Islo::CLI.new.start
    def self.start
      new.start
    end

    attr_reader :args

    def opts
      @opts.to_hash
    end

    def initialize(args = ARGV)
      @args, @opts = parse(args)
    rescue Slop::InvalidOptionError => e
      die(:usage, e.message)
    rescue Slop::MissingArgumentError => e
      die(:usage, e.message)
    end

    # Start execution based on options
    def start
      Islo.command(args, title: opts[:title]).exec
    rescue Islo::Command::Error => e
      die(:oserr, e.message)
    end

    private

    # Stop with a popping message and exit with a return code
    def die(rc, message)
      $stderr.puts('Error: '.color(:red) << message)
      exit(rc.is_a?(Symbol) ? RC[rc] : rc)
    end

    # Stop with a nice message
    def bye(message)
      $stdout.puts message
      exit
    end

    def version_string
      "#{NAME} v#{Islo::VERSION}"
    end

    # Parse arguments and set options
    # rubocop:disable MethodLength
    def parse(args)
      args = args.dup

      opts = Slop.parse!(args, strict: true, help: true) do
        banner "Usage: #{NAME} [options] [--] command arguments"

        on 't', 'title=', 'String displayed in process list', argument: true
        on 'd', 'directory=', 'Change working directory', argument: true
        on 'v', 'version', 'Print the version', -> { bye(version_string) }
      end

      fail Slop::MissingArgumentError, 'missing an argument' if args.empty?

      [args, opts]
    end
  end
end
