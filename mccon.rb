#!/usr/bin/env ruby
#
#
#
require 'yaml'
require './command'
require './broadcast_receiver'
require './plugins/logout_notifier'
require './plugins/player_list'
require './plugins/teleport'

class MCCon
		@@processServer = false

		include BroadcastReceiver
		# Load the configuration file
		# and start the Minecraft Server
		def initialize
				self.log "Loading MCCon..."

				self.log "Loading config"
				self.load_config

				self.start
				start_receiver

				Thread.new do
						self.listen
				end
				loop do 
						sleep 10
				end
		end

		def load_config
				@config = YAML::load(File.open("config"))
				if @config["run"].nil?
						self.log "No Run Command!"
				else
						self.log "\tRun command: #{@config["run"]}"
				end
		end

		def listen
				loop do	
						begin
								while(line = @@processServer.readline)
										Command.parseOutput(line)
								end
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
								@@processServer.puts cmd + "\n"
								@@processServer.flush
						rescue Exception => e 
								puts e
						end
				end
		end

		def MCCon.whisper(player, msg)
				MCCon.sendCommand("tell #{player} #{msg}")
		end

		def MCCon.port(target, destination)
				MCCon.sendCommand("tp #{target} #{destination}")
		end


		def start
				@@processServer= IO.popen(@config["run"] + " 2>&1", 'w+')
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
