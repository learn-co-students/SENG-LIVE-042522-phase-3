# require is like an import statement except it loads all methods from the required file (not just the default export)
require "bundler/setup"
# Here we're calling a method that requires all of the ruby gems in the default environment (not in a group like development or test) For our purposes, this will load require_all and pry so that we can use `require_all` and `binding.pry` within our code
Bundler.require(:default)
require "date"
require "active_support/core_ext/integer/time"
require "active_support/core_ext/date/calculations"
# One of our dependencies that we loaded in the previous expression was the require_all gem. It allows us to require all of the files within a directory. The path we pass to it will be relative to the root path of the project (where the Gemfile is). In our case, we're loading all of the files inside of the lib directory, so if we write code in there (like a method) it will be accessible to us after the require_all below

require_all "lib"

# the reload method is used so that we can reload all of our code in the lib directory from a pry session (usually started from the console) We do this so we won't have to redefine any variables that we've defined during the pry session for debugging purposes. As we make changes to our coee in our text editor, we can run reload from the pry session to pull those changes into our session.
def reload
  load "lib/dog_walker_cli.rb"
  load "lib/dog.rb"
  load "lib/dogs_data.rb"
end