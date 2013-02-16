require 'highline/import'
require_relative 'lib/studip'
require_relative 'lib/project_dir_mananger'

puts "Studip Files Download"
user = ask("Username:") {|q| q.echo = true}
pw = ask("Password:") {|q| q.echo = false}

puts "Trying login..."
studip = Studip.new("http://elearning.uni-bremen.de", user, pw)

#Loading dir structure
pm = ProjectDirManager.new
pm.import_dirs(".")

studip.list_courses.each do |course|
  puts " * #{course.name}"

  dlDir = pm.dir_for(course.name, course.cid)

  if course.files != nil
    course.files.each do |file|
      filepath = "#{dlDir}/#{file.name}"
      if not File::exists? filepath
        puts " - Downloading file #{file.name} to #{filepath}"
        file.download_to "#{filepath}"
      end
    end
  end
end
