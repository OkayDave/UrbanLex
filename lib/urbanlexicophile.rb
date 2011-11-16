require 'nokogiri'
require File.expand_path('../urbanlexicophile/definition', __FILE__)
require File.expand_path('../urbanlexicophile/reader', __FILE__)

class UrbanLexicophile
   module Version
    MAJOR = 0
    MINOR = 1
    PATCH = 0
    
    STRING = [MAJOR, MINOR, PATCH].compact.join('.')
  end
  
  def self.define(term)
    reader = UrbanLexicophile::Reader.new
    definitions = reader.lookup_term(term)
    return definitions
  end
  
end