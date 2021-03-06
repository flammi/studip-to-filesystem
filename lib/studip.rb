require 'nokogiri'
require 'mechanize'

class Course
  attr_reader :name, :files_new, :cid

  def initialize(browser, node, cid)
    @browser = browser
    @name = node.content.strip
    @files_new = false
    @cid = cid
    node.parent.parent.css("img").each do |img|
      attribute = img.attribute("src").value
      if attribute.index("red") and attribute.index("file")
        @files_new = true
      end
    end
  end

  def files()
    begin
      filepage = @browser.get "http://elearning.uni-bremen.de/folder.php?cid=#{@cid}&cmd=all"
    rescue
      puts "Couldn't get files"
      return
    end
    doc = Nokogiri::HTML(filepage.body)

    doc.css('a.extern').map do |x|
      filename = /.*[&?]file_name=([^&?]+).*/.match(x.attribute("href").value)[1]
      link = x.attribute("href").value
      StudipFile.new @browser, filename, link
    end
  end
end

class StudipFile
  attr_reader :name, :link

  def initialize(browser, file_name, link)
    @browser = browser
    @name = file_name
    @link = link
  end

  def download_to(location)
    file = @browser.get(@link)
    if file.respond_to?("save_as")
      file.save_as location
    else
      puts "Error: Skipping file #{file}"
    end
  end

end

class LoginFailed < StandardError
end

class Studip

  def initialize(url, username, password)
    @fake_browser = Mechanize.new
    p = @fake_browser.get url
    login_form = p.form_with :name => "login"
    login_form.field_with(:name => "loginname").value = username
    login_form.field_with(:name => "password").value = password
    result_page = @fake_browser.submit login_form

    #Check for successful login
    html_result = result_page.body
    if html_result.index("Bei der Anmeldung trat ein Fehler auf") != nil
	    raise LoginFailed
    end
  end

  def list_courses()
    veranstaltungen = @fake_browser.get "http://elearning.uni-bremen.de/meine_seminare.php"
    doc = Nokogiri::HTML(veranstaltungen.body)

    res = Array.new

    doc.css('a[href*="seminar_main.php"]').each do |link| 
      c = link.content.strip
      link_href = link.attribute("href").value
      cid = /.*[?&]auswahl=([^&?]+).*/.match(link_href)[1]
      if c != ""
        res << Course.new(@fake_browser, link, cid)
      end
    end
    res
  end
end

