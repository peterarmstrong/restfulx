require 'yaml'
require 'rubygems'
require 'active_support'
require 'active_support/inflector'

# Usage:
# 1. Create a new Rails 3 project: rails new foo
# 2. Copy this script into the project's root directory
# 3. Copy the db/model.yml file into the project's db directory
# 4. Run this script ./rails3yamlscaffold
# 5. Copy the view code (and any other Rails scaffold-generated code you want) into your RestfulX app.
#
# This script would not be necessary if RestfulX ran the Rails scaffolds.

def extract_attrs(line, attrs)
  attrs.each do |key,value|
    if value.class == Array
      if key =~ /^belongs_to/ # belongs_to: [arg1, arg2]
        value.each do |thing|
          line << " #{thing}_id:integer"
        end
      end
    else
      line << " #{key}:#{value}"
    end    
  end
  line
end
  
models = YAML.load(File.open('db/model.yml', 'r'))
models.each do |model|
  line = ""
  attrs = model[1]
  if attrs.class == Array
    attrs.each do |elm|
      line = extract_attrs(line, elm)
    end
  else
    line = extract_attrs(line, attrs)
  end
  line = model[0].camelize + line
  puts 'rails generate scaffold ' + line
  system("rails generate scaffold #{line}")
  sleep 1
end

