require 'highline/import'

require_relative 'studip'

puts "Studip Files Download"
user = ask("Username:") {|q| q.echo = true}
pw = ask("Password:") {|q| q.echo = false}

puts "Trying login..."
studip = Studip.new(user, pw)

#Part Download new files
studip.list_courses.each do |course|
	puts " - #{course.name}"
	course.files.each do |file|
		puts file.name
	end
	#file.download_to "test/#{file.name}"
end
