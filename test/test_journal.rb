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

require File.join(File.expand_path(File.dirname(__FILE__)), 'testutilities')
require File.expand_path(File.join(File.dirname(__FILE__), "../lib/amp"))

class TestJournal < AmpTestCase
  def test_journal
    tfile = "tempjournal"
    j = Amp::Mercurial::Journal.new(:reporter => Amp::StandardErrorReporter, :journal => tfile, :opener => simple_opener)
    j << {:file => "file", :offset => 12345}
    
    open(tfile) do |input|
      assert_equal("file\0#{12345}\n", input.read)
    end
    j.close
    
    assert !File.exists?(tfile)
  end
  
  def test_journal_start_mode
    tfile = "tempjournal"
    Amp::Mercurial::Journal.start(tfile, :opener => simple_opener) do |j|
      j << {:file => "file", :offset => 12345}
      open(tfile) do |input|
        assert_equal("file\0#{12345}\n", input.read)
      end
    end
    assert !File.exists?(tfile)
  end
  
  def simple_opener
    opener = Amp::Opener.new(Dir.pwd)
    opener.default = :open_file
    opener
  end
end