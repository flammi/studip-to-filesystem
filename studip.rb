require 'nokogiri'
require 'mechanize'
require 'highline/import'

puts "Studip Notifications download"

#From stackoverflow...
def get_password(prompt="Enter password:")
	ask(prompt) {|q| q.echo = false}
end

def get_username()
	ask("Username:")
end

fake_browser = Mechanize.new
p = fake_browser.get "http://elearning.uni-bremen.de/"
login_form = p.form_with :name => "login"
login_form.field_with(:name => "loginname").value = get_username()
login_form.field_with(:name => "password").value = get_password()

puts "Trying login..."

fake_browser.submit login_form

puts "Downloading courses list..."
veranstaltungen = fake_browser.get "http://elearning.uni-bremen.de/meine_seminare.php"

doc = Nokogiri::HTML(veranstaltungen.body)

doc.css('a[href*="seminar_main.php"]').each do |link| 
	c = link.content.strip
	if c != ""
		puts c
	end
end
