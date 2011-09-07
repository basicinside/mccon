class Command
		def Command.parseOutput(out)
				begin
						if out =~ /\[INFO\] .* \[.*\] logged in with entity id/
								d = out.scan(/(\[INFO\] )(.*) \[.*\] logged in with entity id/)
								player = d[0][1]
								BroadcastReceiver.send_event(:login, player)
						end

						if out =~ /(\[INFO\] <)(.*)(> )(.*)/
								d= out.scan(/(\[INFO\] <)(.*)(> )(.*)/)
								player = d[0][1]
								msg = d[0][3]
								BroadcastReceiver.send_event(:chat, player, msg)
						end

						if out =~ /\[INFO\] .* lost connection/
								d = out.scan(/(\[INFO\] )(.*)( lost connection: )(.*)/)
								player = d[0][1]
								reason = d[0][3]
								BroadcastReceiver.send_event(:logout, player, reason)
						end

						if out =~ /\[INFO\] \* /
								puts "Emote: #{out}"
						end

						if out =~ /\[INFO\] .* tried command:/
								d = out.scan(/\[INFO\] (.*) tried command: (.*)/) 
								puts "Playercommand: #{d[0][1]} by #{d[0][0]}"
						end

						if out =~ /kickme/
								puts MCCon.sendCommand "help"
						end
				rescue Exception => f
						puts "Fehler #{f}"
				end
		end

		def Command.getPlayer(out)
		end
end

