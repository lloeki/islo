# Islo - application isolator
module Islo
  class << self
    def commands
      @commands ||= {}
    end

    def register(command)
      commands[command.name.to_sym] = command
    end

    def command(args, options = {})
      name = File.basename(args[0]).to_sym
      (commands[name] || Command).new(args, options)
    end
  end
end

[:mysql, :postgres, :redis].each do |c|
  require "islo/commands/#{c}"
end
