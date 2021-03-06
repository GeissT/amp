##################################################################
#                  Licensing Information                         #
#                                                                #
#  The following code is licensed, as standalone code, under     #
#  the Ruby License, unless otherwise directed within the code.  #
#                                                                #
#  For information on the license of this code when distributed  #
#  with and used in conjunction with the other modules in the    #
#  Amp project, please see the root-level LICENSE file.          #
#                                                                #
#  © Michael J. Edgar and Ari Brown, 2009-2010                   #
#                                                                #
##################################################################

module Amp; end
# The root directory of this application
Amp::CODE_ROOT = File.expand_path File.dirname(__FILE__)
Amp::EXT_ROOT = File.expand_path File.join(File.dirname(__FILE__), "..", "ext")
$:.unshift Amp::CODE_ROOT # now we don't need to do `require "#{curdir}..."
$:.unshift Amp::EXT_ROOT
# Timing variable
$start    ||= Time.now
# Should we display anything?
$display  ||= false
# Should we use pure ruby? Default to no.
$USE_RUBY ||= false
# Are we a command-line app? Default to no.
$cl ||= false



require "amp/support/loaders.rb"

need { 'amp/profiling_hacks' }

#require 'profile'
require 'fileutils'
require 'stringio'

local_start = Time.now

###############
# The Amp Magic
###############
module Amp
  
  autoload :Hook,                      "amp/commands/hooks.rb"
  autoload :Generator,                 "amp/support/generator.rb"
  autoload :Opener,                    "amp/support/openers.rb"
  autoload :Match,                     "amp/support/match.rb"
  autoload :AmpConfig,                 "amp/support/amp_config.rb"
  autoload :UI,                        "amp/support/amp_ui.rb"
  autoload :Statistics,                "amp/support/statistics.rb"
  
  module Git
    autoload :Changeset,                 "amp/repository/git/repo_format/changeset.rb"
    autoload :WorkingDirectoryChangeset, "amp/repository/git/repo_format/changeset.rb"
    autoload :VersionedFile,             "amp/repository/git/repo_format/versioned_file.rb"
    autoload :VersionedWorkingFile,      "amp/repository/git/repo_format/versioned_file.rb"
  end
  
  module Mercurial
    autoload :Ignore,                    "amp/support/mercurial/ignore.rb"
    
    autoload :Journal,                   "amp/repository/mercurial/repo_format/journal.rb"
    autoload :VersionedFile,             "amp/repository/mercurial/revlogs/versioned_file.rb"
    autoload :VersionedWorkingFile,      "amp/repository/mercurial/revlogs/versioned_file.rb"
    
    autoload :Revlog,                    "amp/repository/mercurial/revlogs/revlog.rb"      
    autoload :Manifest,                  "amp/repository/mercurial/revlogs/manifest.rb"
    autoload :FileLog,                   "amp/repository/mercurial/revlogs/file_log.rb"
    autoload :ChangeLog,                 "amp/repository/mercurial/revlogs/changelog.rb"
    autoload :ChangeGroup,               "amp/repository/mercurial/revlogs/changegroup.rb"
    autoload :Changeset,                 "amp/repository/mercurial/repo_format/changeset.rb"
    autoload :WorkingDirectoryChangeset, "amp/repository/mercurial/repo_format/changeset.rb"
  end
  
  module Mercurial
    module RevlogSupport
      autoload :ChangeGroup,             "amp/repository/mercurial/revlogs/changegroup.rb"
      autoload :Index,                   "amp/repository/mercurial/revlogs/index.rb"
      autoload :IndexInlineNG,           "amp/repository/mercurial/revlogs/index.rb"
      autoload :IndexVersion0,           "amp/repository/mercurial/revlogs/index.rb"
      autoload :LazyIndex,               "amp/repository/mercurial/revlogs/index.rb"
      autoload :IndexVersionNG,          "amp/repository/mercurial/revlogs/index.rb"
      autoload :Node,                    "amp/repository/mercurial/revlogs/node.rb"
      autoload :Support,                 "amp/repository/mercurial/revlogs/revlog_support.rb"
    end
  end
  
  module Bundles
    module Mercurial
      autoload :BundleChangeLog,         "amp/repository/mercurial/revlogs/bundle_revlogs.rb"
      autoload :BundleFileLog,           "amp/repository/mercurial/revlogs/bundle_revlogs.rb"
      autoload :BundleManifest,          "amp/repository/mercurial/revlogs/bundle_revlogs.rb"
      autoload :BundleRevlog,            "amp/repository/mercurial/revlogs/bundle_revlogs.rb"
    end
  end
  
  module Encoding
    autoload :Base85,                  "amp/encoding/base85.rb"
  end                                      
                                           
  module Diffs
    autoload :BinaryDiff,              "amp/encoding/binary_diff.rb"
    autoload :SequenceMatcher,         "amp/encoding/difflib.rb"
    
    module Mercurial
      autoload :MercurialDiff,           "amp/repository/mercurial/encoding/mercurial_diff.rb"
      autoload :MercurialPatch,          "amp/repository/mercurial/encoding/mercurial_patch.rb"
    end
  end
  
  module Graphs
    autoload :AncestorCalculator,        "amp/graphs/ancestor.rb"
    module Mercurial
      autoload :CopyCalculator,          "amp/graphs/copies.rb"
    end
  end                                      
  
  module Help
    autoload :HelpUI,                   "amp/help/help.rb"
    autoload :HelpEntry,                "amp/help/help.rb"
    autoload :HelpRegistry,             "amp/help/help.rb"
    autoload :CommandHelpEntry,         "amp/help/help.rb"
    autoload :FileHelpEntry,            "amp/help/help.rb"
  end
                                       
  module Merges
    module Mercurial                      
      autoload :MergeState,              "amp/repository/mercurial/repo_format/merge_state.rb"
      autoload :MergeUI,                 "amp/repository/mercurial/merging/merge_ui.rb"
      autoload :ThreeWayMerger,          "amp/repository/mercurial/merging/simple_merge.rb"
    end
  end                                      
  
  module Repositories
    autoload :GenericRepoPicker,         "amp/repository/generic_repo_picker.rb"
    autoload :AbstractLocalRepository,   "amp/repository/abstract/abstract_local_repo.rb"
    autoload :AbstractStagingArea,       "amp/repository/abstract/abstract_staging_area.rb"
    autoload :AbstractChangeset,         "amp/repository/abstract/abstract_changeset.rb"
    autoload :AbstractVersionedFile,     "amp/repository/abstract/abstract_versioned_file.rb"
    autoload :CommonChangesetMethods,    "amp/repository/abstract/common_methods/changeset.rb"
    autoload :CommonLocalRepoMethods,    "amp/repository/abstract/common_methods/local_repo.rb"
    autoload :CommonStagingAreaMethods,  "amp/repository/abstract/common_methods/staging_area.rb"
    autoload :CommonChangesetMethods,    "amp/repository/abstract/common_methods/changeset.rb"
    autoload :CommonVersionedFileMethods,"amp/repository/abstract/common_methods/versioned_file.rb"
    
    module Git
      autoload :LocalRepository,         "amp/repository/git/repositories/local_repository.rb"
      autoload :GitPicker,               "amp/repository/git/repository.rb"
      autoload :StagingArea,             "amp/repository/git/repo_format/staging_area.rb"
    end
    
    module Mercurial
      autoload :BranchManager,           "amp/repository/mercurial/repo_format/branch_manager.rb"
      autoload :BundleRepository,        "amp/repository/mercurial/repositories/bundle_repository.rb"
      autoload :DirState,                "amp/repository/mercurial/repo_format/dir_state.rb"
      autoload :HTTPRepository,          "amp/repository/mercurial/repositories/http_repository.rb"
      autoload :HTTPSRepository,         "amp/repository/mercurial/repositories/http_repository.rb"
      autoload :LocalRepository,         "amp/repository/mercurial/repositories/local_repository.rb"
      autoload :Lock,                    "amp/repository/mercurial/repo_format/lock.rb"
      autoload :MercurialPicker,         "amp/repository/mercurial/repository.rb"
      autoload :Repository,              "amp/repository/mercurial/repository.rb"
      autoload :StagingArea,             "amp/repository/mercurial/repo_format/staging_area.rb"
      autoload :Stores,                  "amp/repository/mercurial/repo_format/store.rb"
      autoload :TagManager,              "amp/repository/mercurial/repo_format/tag_manager.rb"
      autoload :Updatable,               "amp/repository/mercurial/repo_format/updatable.rb"
      autoload :Verification,            "amp/repository/mercurial/repo_format/verification.rb"
    end
  end
  

  
  module Servers
    autoload :FancyHTTPServer,           "amp/server/fancy_http_server.rb"
    autoload :HTTPServer,                "amp/server/http_server.rb"
    autoload :HTTPAuthorizedServer,      "amp/server/http_server.rb"
    autoload :RepoUserManagement,        "amp/server/repo_user_management.rb"
    autoload :User,                      "amp/server/amp_user.rb"
  end                                    
                                         
  module Support                         
    autoload :Logger,                    "amp/support/logger.rb"
    autoload :MultiIO,                   "amp/support/multi_io.rb"
    autoload :Template,                  "amp/templates/template.rb"
  end
end

#######################
# Sinatra modifications
#######################
module Sinatra
  autoload :Amp, "amp/server/extension/amp_extension.rb"
end                  


###########################
# Globally accessible tools
###########################
autoload :Archive,       "amp/dependencies/minitar.rb"
autoload :Zip,           "amp/dependencies/zip/zip.rb"
autoload :PriorityQueue, "amp/dependencies/priority_queue.rb"
autoload :Maruku,        "amp/dependencies/maruku.rb"

#############################
# Files we need to just *run*
#############################                 
require "amp/dependencies/trollop.rb"         
require "amp/dependencies/python_config.rb"   
require "amp/dependencies/amp_support.rb"     
require "amp/support/ruby_19_compatibility.rb"
require "amp/support/support.rb"              
require "amp/dependencies/highline_extensions.rb"
require "amp/templates/template.rb"
require "amp/repository/mercurial/repository.rb" # we're just loading in
require 'amp/repository/git/repository.rb'       # all of the base repositories

if $cl # if it's a command line app
  include Amp::KernelMethods
  require       "amp/commands/command.rb"
  require_dir { "amp/commands/*.rb"              }
  require_dir { "amp/commands/commands/*.rb"     }
else
  # it's not a command line app
 require     'amp/support/docs.rb' # live documentation access
end

require      "amp/repository/repository.rb"

module Amp
  VERSION = '0.5.3'
  VERSION_TITLE = "John Locke" # the next one should totally be "Suomalaisen Susijengi"
  
  def self.new_irb_session(bndng)
    require 'irb'
    
    # Alter IRB appropriately
    # http://jameskilton.com/2009/04/02/embedding-irb-into-your-ruby-application/
    ::IRB.class_eval do
      def self.start_session(binding)
        unless @__initialized
          args = ARGV
          ARGV.replace(ARGV.dup)
          IRB.setup(nil)
          ARGV.replace(args)
          @__initialized = true
        end

        workspace = WorkSpace.new(binding)

        irb = Irb.new(workspace)

        @CONF[:IRB_RC].call(irb.context) if @CONF[:IRB_RC]
        @CONF[:MAIN_CONTEXT] = irb.context

        catch(:IRB_EXIT) do
          irb.eval_input
        end
      end
    end
    
    IRB::start_session bndng
  end
  
end

if ENV["TESTING"] == "true"
  paused = Time.now
  Amp::UI.debug "Time taken to load all files: #{paused - $start} seconds"
  Amp::UI.debug "\t\t local files: #{paused - local_start} seconds"
  Amp::UI.debug
  Amp::UI.debug
end

# Benchmarking stuff

