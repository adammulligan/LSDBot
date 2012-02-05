class LSDBot
  def initialize(server, port, channel)
    @channel = channel
    @socket  = TCPSocket.open(server, port)

    # Connect to the server
    say "NICK LSDBot"
    say "USER lsdbot 0 * LSDBot"
    say "JOIN ##{@channel}"

    # Load the plugins in to Plugins
    Dir['plugins/*'].each { |object| require object }
    self.class.send(:include, Plugins)
  end

  def say(msg)
    # Output to console unless PING msg
    puts msg unless msg =~ /^(P.NG)/

    @socket.puts msg
    sleep 2 # flood control
  end

  def say_to_chan(msg)
    say "PRIVMSG ##{@channel} :#{msg.gsub("\x93", '"').gsub("\x94", '"')}" rescue nil
  end

  def run
    until @socket.eof? do
      msg = @socket.gets

      # Once again, don't output any ping msgs
      puts msg unless msg =~ /^(P.NG)/

      # Reply to any pings
      if msg.match(/^PING :(.*)$/)
        say "PONG #{$~[1]}"
        next
      end

      # If the msg is sent to the channel
      if msg.match(/PRIVMSG ##{@channel} :(.*)$/)
        content = $~[1]

        begin
          # Check for a command
          if content.match(/^(\.|\!)(\w+)(\ )?(.*)/)
            method = $2.to_s
            args   = $4.to_s.strip

            if Plugins.instance_methods.include? method
              send(method, args.split(' ').push(msg.match(/\:([^\!]+)\!/)[1]))
            end
          end
        rescue
          puts $!
          say_to_chan "Invalid request."
        end
      end
    end
  end
end
