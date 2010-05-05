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

module Amp
  module Servers
    
    ##
    # = User
    # A single user within an Amp's server system. Just a simple struct -
    # though they do offer a convenient constructor, taking a hash.
    class User < Struct.new(:username, :password)
      
      ##
      # Generates a public user - i.e., somebody who has been granted no explicit rights.
      # @return [User] a public user with no explicit rights
      def self.public_user
        @@public_user ||= new('public', "")
      end
      
      ##
      # Extra constructor - takes a hash to create a new User, instead of
      # the Struct class's ordered parameters for its constructor.
      #
      # @raise [RuntimeError] raised if the user doesn't supply :password or
      #   :password_hashed
      # @param [Hash] input the hash representing the values for the struct
      # @option input [String] :username The username for the user
      # @option input [String] :password The cleartext (unencrypted) password.
      # @option input [String] :can_read Can the user read the repository?
      # @option input [String] :can_write Can the user write to the repository?
      def self.from_hash(input={})
        # input checking
        unless input[:password]
          raise "User must have a password attribute"
        end
        
        # public is reserved as the username of the public user
        if input[:username].to_s == 'public'
          raise "User cannot have username 'public' -- reserved by Amp system"
        end
        
        new input[:username], input[:password]
      end
      
    end
  end
end
