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

require File.join(File.expand_path(File.dirname(__FILE__)), '../testutilities')
require File.expand_path(File.join(File.dirname(__FILE__), "../../lib/amp"))

class TestManifest < AmpTestCase
  
  def setup
    opener = Amp::Opener.new(File.dirname(__FILE__))
    opener.default = :open_file
    @manifest = Amp::Mercurial::Manifest.new(opener)
  end
  
  def test_load_manifest
    assert_not_nil @manifest
  end
  
  def test_manifest_read_delta
    result = @manifest.read_delta(@manifest.node(8))
    expected = {"test/test_bdiff.rb" => "P\xa1\x85\x8b\xe6\xc6N\xb6\xf3\x92MuIv\xe1|u\x03\xadM", 
                "test/test_mpatch.rb"=> "\xd2c\xcf\x03\xea\x86\x9b:\xa7\xba\xd8\x80\xcf\xad\x7f\xed\xfc\x07\xd9\xd6"}
    assert_equal expected, result
    result = @manifest.read_delta(@manifest.node(21))
    expected = {"lib/revlogs/revlog.rb" => ".\x9e~-\xa6y~\xb8\xd9\xb3\xd5\xe8\xd2tB\xb6\x1d\xbc\x9f:", 
                "lib/revlogs/index.rb" => "\xaa.4\x97\x874g\xb9\xeb\\\x93\x96\x0c\xf8\x9f<\xea\xe9\xae\x16", 
                "lib/commands/command.rb" => "\xf4,\xaa\xf6\xcb\xb1\t\x88\x89\x0f\xd3d\x9d\xb2rQ\x9c!\xf1\x9a", 
                "lib/revlogs/node.rb" => "$&gv\x82{g\xe8Q\xcc$\x0f\x0eh\xdd\x1e\xf5\xba\xc66", 
                "lib/revlogs/revlog_support.rb" => "\xf2\x8b\xe7\xfa\xd4\x04l\xae\xb6\xdf\x82h\xeaW\xc3XLY\xbc/"}
    assert_equal expected, result
  end
  
  def test_manifest_read
    result = @manifest.read(@manifest.node(8))
    expected = {"lib/encoding/bdiff.rb" => "\x8c:\xc9\x1e\xd3\xdaa\xc3'\xbd\xfbF\xd4\xcfs\r\xe4\x936`", 
      "test/test_bdiff.rb" => "P\xa1\x85\x8b\xe6\xc6N\xb6\xf3\x92MuIv\xe1|u\x03\xadM",
      "test/test_amp.rb" => "\x02\xf9k_3\xfe\xf7\x8b\x0e\x96\x99\xcd\xc4\xac\xa0\xee\x9e\xd5{\x10",
      "Manifest.txt" => "\xf0H4jr\x1eS\x13u\x89,\xa1d\x92\xee*\x87z\x97\xf8",
      "test/test_difflib.rb" => "\xba\x96\xa4r\x0b\xc0@\x16.\xc9!\xe8\x90s\x9c\x97\\\xd2c\xc7",
      "lib/commands/dispatch.rb" => "~\x04\xe7H\xc4\xfc\x1b@\xee\xde\xe6\xdd\x04\x00\xde\x12\\,$\xfb",
      "lib/encoding/difflib.rb" => "\xf8\x0b\x08\xf2!\x13\x81#\x87\x94\x1e/\x11\xcf\x05\x95K7\xf2\x05",
      "lib/repository/repository.rb" => "\x7f\xac\xdc\x9e$\x8b\x1f\xba\xb9\xc9'\xa2\x0c$h\x8d2\xe6/\xc0",
      "README.txt" => "\n0\xba\xf2\x99\x9c\xe8\n\xa7Wee\xc7\x9c\x8a\x11\x98\xc3\x7f\xa8",
      "lib/commands/command.rb" => "\x84\x92\xae6Dsd\x10\x8b`\x90\x17\xcc\x07\xe0\x06\x0f\xb6L\xe6",
      "History.txt" => "\xe1\x1e\x1f\x90\x96\x10\x0e\x8c\xc0X\x07`\x19\xbcf\x96\x96\x91\x84<",
      "test/test_base85.rb" => "\xf5\x12\xce4C\x08pd;\x13s\xfcub!\xd7\xb0\xff\xc3\xe2",
      "bin/amp" => "\xebG\xef\x04^y\xaa\xd8\xdc\x1ex\xbe\xb2\xc5\x8c\x01\x87\x84(~",
      "lib/encoding/base85.rb" => "\x89\xda\xc14\x9f\x9b\x84\xad\xcf'\xd4\xe0|-\xf3\x04\x97\xebz\xdf",
      "Rakefile" => "h\xf3\xab\x8e\xf2pu\xff\xa9\x9e\x94\x8et\xb7E\x1f\xb8\xee2\xfa",
      "lib/commands/builtin_commands.rb" => "e\xe1\rR@sq\xcd\xf5\xd0\xde'\x99\xd01E\x04V\x9e1",
      "jolts.rb" => "\xce\x96yL\x06J\xd8\xba\x93g=o\xf8P\x88-I\x1d\xb7\xc9",
      "test/test_mpatch.rb" => "\xd2c\xcf\x03\xea\x86\x9b:\xa7\xba\xd8\x80\xcf\xad\x7f\xed\xfc\x07\xd9\xd6",
      "lib/encoding/mpatch.rb" => "~\xadi\x7f\xb7i[\x17s\xa0\xa3\xd7E\x1c\xf0L4]\xb44",
      "lib/amp.rb" => "\xfe\xf3\xcd\x96C\xca\\9\n\xb7\xfcE\xd0\xb8f\x14\rC*\xc6",
      "lib/support/support.rb" => "A\x90\x8a\xe9\xdb3M\xbb\xaa\x15G\xdf \xfe\xee\xc8\xfdw\xdds",
      ".hgignore" => "~^\xb1WH\xf1\x9f\xee\xde\xb0@\xf3\xdc\xf3\xe57\xab\xaa\xc4\x9d"}
    assert_equal expected, result
  end
  
  def test_manifest_find
    result = @manifest.find(@manifest.node(8), "lib/encoding/bdiff.rb")
    expected = ["\x8c:\xc9\x1e\xd3\xdaa\xc3'\xbd\xfbF\xd4\xcfs\r\xe4\x936`", '']
    assert_equal expected, result
    
    result = @manifest.find(@manifest.node(21), "lib/support/support.rb")
    expected = ["\x14|~9\xad\x1c\x1a5\xbe\xff\xcb\x81\x11J\xd6\x89g\xe2EK", '']
    assert_equal expected, result
    
    result = @manifest.find(@manifest.node(44), "lib/support/ruby_19_compatibility.rb")
    expected = ["\xa3d\xd7?g\xb4p\xa6\xe2\xbd\xf9\x97P\x97.\xbb\x8f{\xd4\x05", '']
    assert_equal expected, result
  end
end