class UrbanLexicophile
  class Definition
    attr_accessor :upvotes, :downvotes, :title, :definition, :example, :author
    
    def score
      return upvotes-downvotes
    end
    
    
  end
end