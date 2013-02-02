require 'nokogiri'
require 'mechanize'
require 'highline/import'
require 'debugger'

class Course
	attr_reader :name, :files_new
	def initialize(node)
		@name = node.content.strip
		@files_new = false
		node.parent.parent.css("img").each do |img|
			attribute = img.attribute("src").value
			if attribute.index("red") and attribute.index("file")
				@files_new = true
			end
		end
	end
end

class Studip
	def initialize(username, password)
		@fake_browser = Mechanize.new
		p = @fake_browser.get "http://elearning.uni-bremen.de/"
		login_form = p.form_with :name => "login"
		login_form.field_with(:name => "loginname").value = username
		login_form.field_with(:name => "password").value = password
		@fake_browser.submit login_form
	end
	def list_courses()
		veranstaltungen = @fake_browser.get "http://elearning.uni-bremen.de/meine_seminare.php"
		doc = Nokogiri::HTML(veranstaltungen.body)

		res = Array.new

		doc.css('a[href*="seminar_main.php"]').each do |link| 
			c = link.content.strip
			if c != ""
				res << Course.new(link)
			end
		end
		res
	end
end



puts "Studip Notifications download"
user = ask("Username:") {|q| q.echo = true}
pw = ask("Password:") {|q| q.echo = false}

puts "Trying login..."
studip = Studip.new(user, pw)

puts "Downloading courses list..."
res = studip.list_courses.group_by(&:files_new)

puts "Kurse mit neuen Dateien:"
res[true].each do |course|
	puts "- #{course.name}"
end

puts ""
puts "Kurse ohne neue Dateien:"
res[false].each do |course|
	puts "- #{course.name}"
end
