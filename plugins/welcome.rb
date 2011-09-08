class Welcome
		include BroadcastReceiver

		def initialize
				start_receiver
				welcome = lambda do |player|
						MCCon.whisper(player, "Welcome to holarse-linuxgaming.de.")
						MCCon.whisper(player, "Enjoy your stay.")
				end
				add_event(:login, :welcome, &welcome)
		end
end

Welcome.new

