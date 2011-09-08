class Help
		include BroadcastReceiver

		def initialize
				start_receiver
				help = lambda do |player, command|
						MCCon.whisper(player, "/help - Shows this message")
						MCCon.whisper(player, "/kill - Kill yourself")
						MCCon.whisper(player, "/me <msg> - Write a third person message")
						MCCon.whisper(player, "/port <player> - Teleport to <player>")
						MCCon.whisper(player, "/tell <player> <msg> - whisper to <player>")
				end
				add_event(:custom_help, :help, &help)
		end
end

Help.new

