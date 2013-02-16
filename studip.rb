# coding: utf-8

require 'highline/import'
require_relative 'lib/studip'
require_relative 'lib/project_dir_mananger'

def init url
  puts "Preparing this dir for downloads from #{url}"
  #Create settings file
  if File.exists? ".studipdlsettings"
    puts "Error: Settings file already existing!"
  else
    File.open ".studipdlsettings", "w"  do |f|
      user = ask("Username:") {|q| q.echo = true}
      puts "Warning: Your password gets stored in cleartext on your disk!"
      pw = ask("Password:") {|q| q.echo = false}
      f.puts url
      f.puts user
      f.puts pw
    end
    puts "Settings file created!"
    puts "Run ./studip.rb sync to download your files from studip!"
  end
end

def sync
  if not File.exists? ".studipdlsettings"
    puts "Error: No Settings file in current dir!"
    return
  end

  url, user, pw = ""

  File.open ".studipdlsettings", "r" do |f|
    url = f.gets.chomp
    user = f.gets.chomp
    pw = f.gets.chomp
  end

  puts "Connecting to Studip - URL: #{url}"
  studip = Studip.new url, user, pw

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
end

command = ARGV[0]
ARGV.shift

case command
when "init"
  if ARGV.size != 1
    puts "Error: Please specify a Studip-URL"
  else
    url = ARGV[0]
    ARGV.shift
    init url
  end
when "sync"
  sync
when "help"
  puts "Usage: ./studip <Command>\n" <<
  "Folgende Kommandos sind verfügbar:\n" <<
  "    init - Ein Verzeichnis für den Download von Studip Daten vorbereiten\n" <<
  "    sync - StudIP nach neuen Dateien durchsuchen und herunterladen\n" <<
  "    help - Diese Hilfe anzeigen"
end

