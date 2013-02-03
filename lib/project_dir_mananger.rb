class ProjectDirManager
	def initialize()
		@project_dirs = Hash.new
	end
	def import_dirs(wd)
		Dir.glob("#{wd}/**/.studipdl").each do |file|
			f = File.new(file, "r")
			cid = f.readline
			course_dir = File.dirname(file)
			@project_dirs[cid] = course_dir
		end
		@project_dirs.size
	end
	def clear()
		@project_dirs.clear
	end
	def clean_up_course_name(course_name)
		#Klammern aus dem Namen entfernen
		clean_up_name = course_name.gsub(/\([^\)]*\)/, "").strip
		#Slashes entfernen
		clean_up_name.gsub("/", " ")
	end
	def dir_for(course_name, cid)
		if not @project_dirs[cid]
			#Create dir
			newDir = clean_up_course_name(course_name)
			if not File.directory? newDir
				Dir::mkdir(newDir)
			end

			#Create info file
			File.open("#{newDir}/.studipdl", "w") do |f|
				f.write(cid)
			end
			@project_dirs[cid] = newDir
		end
		@project_dirs[cid]
	end
end
