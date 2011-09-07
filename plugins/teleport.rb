class Teleport
		include BroadcastReceiver

		def initialize
				@requests = {}
				start_receiver

				request = lambda do |player, command|
						begin
								destination = command.split[1]

								if !destination.nil?
										@requests[destination] = player
										MCCon.whisper(player, "Request send to #{destination}")
										MCCon.whisper(destination, "Teleportrequest from #{player}. Type /accept to start teleport.")
								end
						rescue Exception => f
								puts "Fehler bei /port: #{f}"
						end
				end
				add_event(:custom_port, :teleport, &request)

				accept = lambda do |player, command|
						begin
								if !@requests[player].nil?
										MCCon.port(@requests[player] , player)
										puts "Port #{@requests[player]} #{player}"
										@requests[player] = nil
								end
						rescue Exception => f
								puts "Fehler bei /accept: #{f}"
						end
				end
				add_event(:custom_accept, :teleport, &accept)
		end
end
Teleport.new
