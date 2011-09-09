class Mailbox
		include BroadcastReceiver

		def initialize
				start_receiver

				mail = lambda do |player, command|
						d = command.split
						destination = d[1]
						msg = d[2..-1].join(" ")
						if PlayerList.get.include?(destination)
								MCCon.whisper(player, "#{destination} is online. Message whispered.")
								MCCon.whisper(destination, "Message from #{player}: #{msg}")
						else
								Mailbox.store(destination, player, msg)
						end
				end
				add_event(:custom_mail, :voicemail, &mail)

				read = lambda do |player, command|
						if File.exists?("#{player}.mail")
								Mailbox.read(player)
						else
								MCCon.whisper(player, "Mailbox empty")
						end
				end
				add_event(:custom_read, :voicemail, &read)

				clear = lambda do |player, command|
						if File.exists?("#{player}.mail")
								Mailbox.clear(player)
								MCCon.whisper(player, "Mailbox cleared.")
						else
								MCCon.whisper(player, "Mailbox empty.")
						end
				end
				add_event(:custom_clear, :voicemail, &clear)

				check = lambda do |player|
						if File.exists?("#{player}.mail")
								MCCon.whisper(player, "You have mail.")
								MCCon.whisper(player, "Type /read to read.")
								MCCon.whisper(player, "Type /clear to clear mailbox.")
						end
				end
				add_event(:login, :voicemail, &check)

		end

		def Mailbox.store(receiver, sender, msg)
				begin
						open("#{receiver}.mail", 'a') { |f|

								f << "Message from #{sender} at #{Time.now}:\n"
								f << "#{msg}\n"
						}
				rescue Exception => f
						puts "Fehler in /mail: #{f}"
				end
		end

		def Mailbox.clear(player)
				if File.exists?("#{player}.mail")
						File.delete("#{player}.mail")
				end
		end

		def Mailbox.read(player)
				if File.exists?("#{player}.mail")
						begin
								file = File.new("#{player}.mail", "r")
								while (line = file.gets)
										MCCon.whisper(player, line)
								end
								file.close
						rescue Exception => f
								return rt
						end
				end
		end
end
Mailbox.new
