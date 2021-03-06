require "fix_mah_gemfile/version"
require 'pathname'

module FixMahGemfile

  class Processor
    attr_accessor :gemfile

    def initialize &block
      @gemfile      = File.readlines("Gemfile")
      @gemfile_orig = @gemfile.dup
      instance_eval &block if block_given?
      write_to_file
    end
    def log str, color_code=32
      # green = 32 , red 31, yellow = 33
      print "\e[#{color_code}m#{str}\e[0m"
    end
    def add_gem gemname, *args
      log "adding #{gemname} #{args.inspect}... "
      where = args[1].keys.first rescue 'end_of_gemfile'
      #puts "where #{where} #{args[1][where] rescue 'error'}"
      newline = ([" gem '#{gemname}'", args[0]].join(", ")) << "\n"
      case where.to_s
      when 'above_gem'
        linenum = gem_at_line(args[1][where])
        gemfile.insert(linenum, newline)
      when 'below_gem'
        linenum = gem_at_line(args[1][where])
      when 'end_of_gemfile'
        str=["gem '#{gemname}'", "#{args.first.to_s.gsub(/^{|}$/,'')}".strip].reject{|s|s.nil? || s.size==0 }.join(', ')
        gemfile << "#{str}\n"
      else
        puts "don't know how to handle directive #{where}"
        exit 1
      end
    end

    def remove_gem gemname
      log "removing #{gemname}... "
      if linenum = gem_at_line(gemname)
        line = gemfile[linenum]
        line = "##{line}"
        gemfile[linenum] = line
      else
        puts "Not found"
      end
    end
    def change_gem_version *args
      log "changing gem: args #{args.inspect}... "
      gemname = args[0]
      options = args[1]
      if linenum = gem_at_line(gemname)
        line = gemfile[linenum]
        lineparts = line.split(',')
        if lineparts[1] # replace
          lineparts[1] = " '#{options[:to]}'"
        else # append
          lineparts << " '#{options[:to]}'"
        end
        gemfile[linenum] = lineparts.join(",")
      else
        puts "cant find gem to modify"
      end
    end
    def gem_at_line gemname
      found = gemfile.index { |line| line =~ /^\s*gem ['|"]#{gemname}/ }
      puts "found at #{found}"
      if found
        puts gemfile[found]
      end
      found
    end
    def write_to_file filename = 'Gemfile'
      # write out original to backup, overwrite Gemfile with modified version
      File.open("Gemfile.orig",'w') { |f| f.write(@gemfile_orig.join("")) }
      File.open("Gemfile",'w') { |f| f.write(@gemfile.join("")) }
    end
    def self.usage
      puts "Usage: #{Pathname.new($0).basename} [--help] [--generate_rc] [path/to/rc_file]"
      puts "   --help          : this help"
      puts "   --generate_rc   : creates a sample .fixgemfile_rc in the current directory"
      puts "   path/to/rc_file : [optional]\n"
      puts "This utility will look for a .fixgemfile_rc which consists of directives to modify the Gemfile"
      puts "in the current directory.  An option argument can specify the path to an alternate rc file.\n\n"
    end
    def self.generate_sample_rc
      outfile = "./.fixgemfile_rc"
      file = <<-END
# example .fixgemfile_rc
FixMahGemfile::Processor.new do
  remove_gem 'looksee'
  change_gem_version 'libxml-ruby', :to => '~> 2.7'
  #add_gem 'therubyracer', "'~> 0.12', :require=>false", :above_gem => "guard"
  remove_gem 'therubyracer'
  remove_gem 'guard-less'
end

FixMahGemfile::Processor.run "bundle"
#FixMahGemfile::Processor.run "bundle update libxml-ruby"
#FixMahGemfile::Processor.run "bundle update guard guard-less therubyracer"
END
      File.open(outfile, "w") { |f| f.write(file) }
    end
    def self.run str
      puts str
      system str
    end
  end
end

