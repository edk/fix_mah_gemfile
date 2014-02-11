# FixMahGemfile

This gem provides a script that modifies the Gemfile and runs bundler in one step.  This
came about because I needed to regularly make local modifications to a shared project, but
didn't or couldn't push my locally needed changes upstream.

## Installation

    $ gem install fix_mah_gemfile

## Usage

Change your directory to the project, where the Gemfile is available.  First generate a sample
.fixgemfile_rc in the current directory with:

   $ fix_mah_gemfile --generate_rc

Then edit the .fixgemfile_rc with the local changes you'd like to apply when running the fix_mah_gemfile
script.

```ruby
   $ fix_mah_gemfile
   changing gem: args ["libxml-ruby", {:to=>"~> 2.6"}]... found at 147
   gem 'libxml-ruby', '~> 2.6', :require => nil
   removing therubyracer... found at 
   Not found
   removing guard-less... found at 
   Not found
   bundle
   Using rake (10.0.4) 
   Using Ascii85 (1.0.2) 
   ...
```

Then before checking-in any changes, either do a git checkout Gemfile* or simply avoid commiting these
local changes to your gemfile.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
