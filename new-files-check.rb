require 'highline/import'

require_relative 'lib/studip'

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
