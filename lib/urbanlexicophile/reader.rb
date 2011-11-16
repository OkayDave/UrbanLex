require 'open-uri'

class UrbanLexicophile
  class Reader
    
    def lookup_term(term)
      @address = "http://www.urbandictionary.com/define.php?term="
      url = @address + term.gsub(" ", "+")
     
      definitions = []
      
      # perform the search
       @ng = Nokogiri::HTML(open(url+"&page=1"))

      #determine if search has a defined term
      if self.term_defined?
        #get definitions from first page of definitions
        
        definitions = get_all_definitions
        
        # same again for check for more pages
        page = 1
        while @ng.css("a.next_page").count > 0
          page += 1
          @ng = Nokogiri::HTML(open(url+"&page=#{page.to_s}"))
          definitions += get_all_definitions
        end
      end     
      

      
      return definitions
    end
    
    def get_all_definitions

      table = @ng.css("#entries")
      
      # a definition takes up at least 2 <tr> and has no semantic separator between definitions
      # to make it even harder, some definitions have more than 2 <tr>s
      # this is a best attempt at discovering definitions, and passing them to get_one_definition for parsing
      
      finished_definitions = []
      definition_in_progress = []
      
      table.css("tr").each do |row|
        
        # check if the row is an index. If it is, clear out the in_progress definition and parese the first line
        if is_index_row? row
          definition_in_progress = []
          definition_in_progress << parse_title_row(row)

        elsif is_definition_row? row
          definition_in_progress << parse_definition_row(row)
          finished_definitions << build_definition_object(definition_in_progress)

        end
        
      end
      
      return finished_definitions # should be an array of complete Definition objects
       
    end
    
    
    def term_defined?
      if @ng.css("#not_defined_yet").count > 1
        return false 
      else
        return true
      end
    end
    
    def is_index_row?(row)
      if row.css("td.index").count > 0
        return true 
      else
        return false
      end
    end
    
    def is_definition_row?(row)
      if row.css("div.definition").count > 0
        return true
      else
        return false
      end
    end
    
    def parse_title_row(row)
      
      title = row.css(".word").first.content.to_s.strip
      return {:title => title}
    end
    
    def parse_definition_row(row)
      
      definition = row.css(".definition").first.content.to_s.strip
      example = row.css(".example").first.content.to_s.strip
      author = row.css(".greenery a.author").first.content.to_s.strip
      
      return {:definition => definition, :example => example, :author => author}
    end
    
    def build_definition_object(def_array)
      title_details = def_array.first
      definition_details = def_array.last
      
      definition = Definition.new
      definition.title = title_details[:title]
      definition.author = definition_details[:author]
      definition.definition = definition_details[:definition]
      definition.example = definition_details[:example]
      
      return definition
    end
    
  end
end