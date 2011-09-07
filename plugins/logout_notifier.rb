class LogoutNotifier
		include BroadcastReceiver

		def initialize
				start_receiver
				logout_notify = lambda do |player, reason|
						puts "#{player} logged out."
				end
				add_event(:logout, :logout_notify, &logout_notify)
		end
end

LogoutNotifier.new

