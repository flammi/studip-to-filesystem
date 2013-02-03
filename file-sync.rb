require 'highline/import'

require_relative 'studip'

puts "Studip Files Download"
user = ask("Username:") {|q| q.echo = true}
pw = ask("Password:") {|q| q.echo = false}

puts "Trying login..."
studip = Studip.new(user, pw)

studip.list_courses.each do |course|
	puts " * #{course.name}"
	#Klammern aus dem Namen entfernen
	clean_up_name = course.name.gsub(/\([^\)]*\)/, "").strip
	#Slashes entfernen
	clean_up_name = clean_up_name.gsub("/", "")
	if not File.directory? clean_up_name
		Dir::mkdir(clean_up_name)
		puts " - Creating dir #{clean_up_name}"
	end

	course.files.each do |file|
		filepath = "#{clean_up_name}/#{file.name}"
		if not File::exists? filepath
			puts " - Downloading file #{file.name} to #{filepath}"
			file.download_to "#{filepath}"
		end
	end
end
