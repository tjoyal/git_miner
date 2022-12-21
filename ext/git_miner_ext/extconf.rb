# Loads mkmf which is used to make makefiles for Ruby extensions
require 'mkmf'

# Give it a name
extension_name = 'git_miner_ext'

# The destination
dir_config(extension_name)

# Requirement for SHA1
have_library("crypto")

# Do the work
create_makefile(extension_name)
