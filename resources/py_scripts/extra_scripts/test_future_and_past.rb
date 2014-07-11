#looks for future words that might be connected to the entity
	def get_future_terms(sent_arry, counter)
		future_terms = Hash.new()
		if counter > 0
			new_counter = 0
			sent_arry_size = sent_arry.size
			new_sent_arry_future = sent_arry[counter+1, sent_arry_size]
			puts "********original********"
			print sent_arry
			puts
			puts "$$$$$$$FUTURE_WORDS$$$$$$$$$"
			print new_sent_arry_future
			puts
			if new_sent_arry_future.size > 1
				new_sent_arry_future.reverse_each do | wd |
					if wd[1].to_s == 'noun' and wd[3].size > 0 
						puts wd[0].to_s
						future_terms[wd[0].to_s] = [wd[2], wd[3]]
						new_counter = new_counter + 1 
					elsif wd[2].to_s == 'symbol' and wd[3].size > 0 
						puts wd[0].to_s
						future_terms[wd[0].to_s] = [wd[2], wd[3]]
						new_counter = new_counter +1 
					elsif wd[1].to_s == 'period' and new_sent_arry_future[new_counter+1][3].size > 0 
						puts wd[0].to_s
						future_terms[new_sent_arry_future[new_counter+1][0].to_s]  = [ new_sent_arry_future[new_counter+1][2],  new_sent_arry_future[new_counter+1][3]]
						new_counter = new_counter +1 
						#print new_sent_arry_future[new_counter]
						#puts
						#print new_sent_arry_future[new_counter+1]
					elsif wd[1].to_s == 'comma' and new_sent_arry_future[new_counter+1][3].size > 0 
						puts wd[0].to_s
						future_terms[new_sent_arry_future[new_counter+1][0].to_s]  = [new_sent_arry_future[new_counter+1][2],  new_sent_arry_future[new_counter+1][3]]
						new_counter = new_counter +1 
						#future_terms[ sent_arry[new_counter-1][0].to_s]  = [sent_arry[new_counter-1][2],  sent_arry[new_counter-1][3]]
					else 
						puts "##not matching##"
						puts wd
						break
					end
				end
			end
		end
		puts "$$$$$FINAL$$$$$$$$$$$"
		puts future_terms

		#looks for previous words that might be connected to the entity
	def get_past_terms(sent_arry, counter)
		prev_terms = Hash.new()
		if counter > 0
			new_counter = 0
			sent_arry_size = sent_arry.size
			puts sent_arry.to_s
			new_sent_arry_past = sent_arry[0, counter]
			new_sent_arry_past.reverse_each do | wd |
				if wd[1].to_s == 'noun' and wd[3].size > 0 
					puts wd[0].to_s
					prev_terms[wd[0].to_s] = [wd[2], wd[3]]
					new_counter = new_counter + 1 
				elsif wd[2].to_s == 'symbol' and wd[3].size > 0 
					puts wd[0].to_s
					prev_terms[wd[0].to_s] = [wd[2], wd[3]]
					new_counter = new_counter +1 
				elsif wd[1].to_s == 'comma' and sent_arry[new_counter-1][3].size > 0 
					prev_terms[ sent_arry[new_counter-1][0].to_s]  = [sent_arry[new_counter-1][2],  sent_arry[new_counter-1][3]]
				else 
					puts "breaking the loop"
					puts wd[0].to_s
					break
				end
			end
		end
		reversed_prev_terms = Hash[prev_terms.to_a.reverse]
		return reversed_prev_terms
	end


elsif wd[1].to_s == 'comma' and new_counter+1  < new_sent_arry_future.size
						if new_sent_arry_future[new_counter+1][3].size > 0 
							puts wd[0].to_s
							future_terms[new_sent_arry_future[new_counter+1][0].to_s]  = [new_sent_arry_future[new_counter+1][2],  new_sent_arry_future[new_counter+1][3]]
							new_counter = new_counter +1 
						end
	end