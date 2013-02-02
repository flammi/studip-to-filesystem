require 'nokogiri'
require 'mechanize'
require 'highline/import'

class Course
	attr_reader :name
	def initialize(name)
		@name = name
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
				res << Course.new(c)
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
(studip.list_courses).each do |course|
	puts course.name
end
