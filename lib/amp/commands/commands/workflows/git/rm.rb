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

command :rm do |c|
  c.workflow :git
  c.desc "Removes files from the repository on next commit"
  c.opt :force, "Forces removal of files", :short => "-f", :default => false
  c.opt :quiet, "Doesn't print which files are removed", :short => "-q"
  c.opt :"dry-run", "Doesn't actually remove files - just prints output", :short => "-n"
  c.opt :cached, "Removes the file only from the staging area (doesn't unlink file)"
  c.opt :recursive, "Recursively remove named directories", :short => "-r"
  c.opt :"no-unlink", "Don't remove the file - just forget it", :short => '-s'
  
  c.on_run do |opts, args|
    repo = opts[:repository]
    working_changeset = repo[nil]
    
    args     = args.map    {|p| repo.relative_join(p) }
    files    = args.reject {|p| p.include?("*") }
    patterns = args.select {|p| p.include?("*") }
    # 
    # files.select {|f| File.directory?(repo.working_join(f))}.each do |folder|
    #   patterns += 
    
    match = Amp::Match.create(:files => files, :includer => (["syntax: glob"] + patterns)) { false }
    
    s = repo.status :match => match, :clean => true
    modified, added, deleted, clean = s[:modified], s[:added], s[:deleted], s[:clean]
    
    remove, forget = [], []
    
    remove += clean
    remove += deleted
    remove += modified if opts[:force]
    
    if opts[:cached]
      forget += added
    elsif opts[:force]
      remove += added
    end
    
    unless opts[:force]
      modified.each {|p| Amp::UI.warn "not removing #{p} - file is modified (use --force)"        }
    end
    
    unless opts[:cached] || opts[:force]
      added.each    {|p| Amp::UI.warn "not removing #{p} - file is marked for add (use --cached)" }
    end
    
    unless opts[:quiet]
      (remove + forget).sort.each {|f| Amp::UI.say "removing #{f}" }
    end
    
    repo.staging_area.remove remove, :unlink => opts[:"no-unlink"] unless opts[:"dry-run"] # forgetting occurs here
    repo.forget forget unless opts[:"dry-run"]
    repo.staging_area.save    
    
    remove += forget

    if remove.size == 1
      Amp::UI.say "File #{remove.first.red} removed at #{Time.now}"
    else
      Amp::UI.say "#{remove.size.to_s.red} files removed at #{Time.now}"
    end


  end
end
