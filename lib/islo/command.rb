module Islo
  # Generic command execution
  class Command
    class Error < StandardError; end

    attr_reader :title, :wd
    attr_reader :command, :args

    def initialize(args, title: nil, wd: nil)
      @command = args.shift
      @args = args
      @title = title unless title.nil? || title.empty?
      @wd = Pathname.new(wd || Dir.pwd)
    end

    def title?
      !title.nil?
    end

    def exec
      Dir.chdir(wd.to_s)
      Kernel.exec(*args_for_exec)
    rescue SystemCallError => e
      raise Command::Error, e.message
    end

    private

    def args_for_exec
      command = (title? ? [@command, title] : @command)
      args = self.args

      [command] + args
    end
  end
end
