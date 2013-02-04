studip-to-filesystem
====================

This project was created as a preparation of the AWE13 course of the university of Bremen.

This tool is able to copy all files of your courses in the elearning plattform "StudIp" to a folder on your local hard
drive. If the initial copy has finished the tool will fetch the new files and download them.

On the initial copy the tool will create a folder for each course and save the files there. If you doesn't like the
simplified names, simply rename the folders to something you like more. On the next run of the script it will recognize
the rename and update the renamed folders.

### Dependencies


- Ruby >= 1.9
- Nokogiri
- Mechanize
- Highline

### Preparation
    $> gem install highline mechanize nokogiri

### Example
    cd <Studip DL Folder>
    $> ruby ./studip init http://elearning.uni-bremen.de
    Username:
    <Enter your Studip username here>
    Password:
    <Enter your studip username here>
    $> ruby ./studip sync
    <The data of your courses are copied now to this dir>

