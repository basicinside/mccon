class PlayerList
		include BroadcastReceiver

		def initialize
				@@players = []
				start_receiver

				login_player = lambda do |player|
						@@players << player unless @@players.include?(player)
				end
				add_event(:login, :player_list, &login_player)

				logout_player = lambda do |player, reason|
						@@players.delete(player) if @@players.include?(player)
				end
				add_event(:logout, :player_list, &logout_player)

				list_players = lambda do |player, command|
						begin
							puts "List command"
							MCCon.whisper(player, @@players.join(", "))
						rescue Excception => f
								puts "Fehler bei /list: #{f}"
						end
				end
				add_event(:custom_list, :player_list, &list_players)
		end

		def PlayerList.get
				@@players
		end

end
PlayerList.new
