require 'monitor'

module BroadcastReceiver

						@@receivers = []

		def start_receiver
				begin
						@@receivers << self
						@events = {}
						@handler_queue = []
						@handler_queue.extend(MonitorMixin)
						@handler_pending = @handler_queue.new_cond

						ObjectSpace.define_finalizer(self) {abort}

						@handler_thread = Thread.new do
								loop do
										task = nil
										@handler_queue.synchronize do
												@handler_pending.wait_while { @handler_queue.empty? }
												task = @handler_queue.shift
										end
										task[:code].call(*task[:args])
								end
						end
				rescue Exception => f
						puts "Fehler: #{f}"
				end
		end

		def abort
				@@cbm_all_managers.delete(self)
				@cbm_work_thread.kill
		end

		def add_event(event, source, &code)
				return unless code.class == Proc
				@events[event] = {} if @events[event].nil?
				@events[event][source] = code
		end

		def remove_event(event, source)
				@events[event].delete(source) if @events[event]
		end

		def do_event(event,*args)
				return if @events[event].nil? || @events[event].empty?
				@handler_queue.synchronize do
						@events[event].each do |source, code|
								@handler_queue << { :event => event, :source => source, :code => code, :args => args }
						end
						@handler_pending.signal
				end
		end

		def send_event(event, *args)
				BroadcastReceiver.send(event,*args)
		end

		# singleton accessor 
		def BroadcastReceiver.send_event(event, *args)
				@@receivers.each do |receiver|
						receiver.do_event(event,*args)
				end
		end
end
