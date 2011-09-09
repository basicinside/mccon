class Whitelist
		def initialize
				Thread.new do
						sleep 30
						loop do
								begin
										json = `wget -q -O - http://api.holarse-linuxgaming.de/minecraft/allowedusers.php`
										d = json.scan(/\{"allowed_users":\[(.*)\]\}/)
										players = d[0][0].gsub(/"/,'').split(',')
										puts players
										open("white-list.txt", 'w') { |f|
												players.each { |player|
														f << "#{player.strip}\n"
												}
										}
								rescue Exception => f
										puts "Whitelist: #{f}"
								end
								MCCon.sendCommand("whitelist reload")
								sleep 60
						end
				end
		end
end

Whitelist.new

