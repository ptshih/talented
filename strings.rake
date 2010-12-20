# strings.rake
# Extracts strings from the LinkedIn iPhone application for use by translators
# 
# Created by Matt Pelletier 2009-10-14
# 

LANGUAGES = ["English"]
# LANGUAGES = ["English", "French", "German", "Spanish", "Russian", "Korean"]

# Invoke via "rake -f strings.rake extract_strings from the base LinkedIn directory"
desc "Extract all strings from source code so they can be sent over for translation"
task :extract_strings do
  LANGUAGES.each do |lang|
    # delete the old file
    if File.exist?("#{lang}.lproj/Localizable.strings")
      system("rm -rf " + "#{lang}.lproj/Localizable.strings")
    end
    
    files = `find . -path \"./Classes/Vendor/three20\" -prune -o \\( -name \\*.m -o -name \\*.h \\)`.split("\n")
    puts "Got files #{files}"
    
    files.each { |file|
      #escape any spaces
      escapedFile = file.gsub(' ', '\ ')
      command = "genstrings -a -q -o #{lang}.lproj #{escapedFile}"
      puts "Run gen string command #{command}"
      system(command)
    }
  end
end
