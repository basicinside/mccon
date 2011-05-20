class Command
	def Command.parseOutput(out)
		if out =~ /\[INFO\] <.*>/
			puts "Chat: #{out}"
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
	end

	def Command.getPlayer(out)
	end
end

