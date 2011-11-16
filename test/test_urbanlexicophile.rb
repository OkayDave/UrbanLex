require 'helper'

class TestUrbanLexicophile < Test::Unit::TestCase
  should "define() should return an array of definitions" do
    a = UrbanLexicophile.define("lol")
    unless a.is_a?(Array) && a.first.is_a?(UrbanLexicophile::Definition)
      flunk "Returned value is not an array"
    end
  end
  
  should "non existing definitions should be handled gracefully" do
    begin 
      UrbanLexicophile.define("dfgsf nwe ask2j 9")
    rescue
      flunk "Yeah, that's broke"
    end
  end
  
  should "everything should just work " do
    begin
      a = UrbanLexicophile.define("okay")
      puts "Definition for #{a.first.title}:"
      puts "\t #{a.first.definition}"
      puts "\t Usage: #{a.first.example}"
      puts "\t Author: #{a.first.author}"
    rescue
      flunk "Something is broken :("
    end
  end
end
