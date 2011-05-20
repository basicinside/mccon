#!/usr/bin/env ruby
#
#
#


class MCCon
	@@processServer = false

	# Load the configuration file
	# and start the Minecraft Server
	def initialize
		self.log "Loading MCCon..."
		
		self.start
		Thread.new do
			self.listen
		end
		loop do 
			sleep 10
		end
	end

	def listen
		loop do	
			load './command.rb'		
			begin
				@@processServer.readline
				Command.parseOutput(@@processServer.readline)
			rescue Exception => e
				log "Error #{e}"
				sleep 5
			end
		end
	end

	def MCCon.sendCommand(cmd)
		Thread.new do
			begin
				puts "processServer: #{@@processServer.inspect} #{cmd}"
				@@processServer.puts cmd 
			rescue Exception => e 
				puts e
			end
		end
	end


	def start
		@@processServer= IO.popen('java -jar minecraft_server.jar nogui 2>&1', 'w+')
		loop do
			break if @@processServer.readline =~ /Done/
		end
		self.log "Minecraft Server erfolgreich gestartet."
	end

	def log(msg)
		puts msg
	end
end

$console = MCCon.new
