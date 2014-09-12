module Ruy
  class Context < Hash
    def self.from_hash(hash)
       ctx = Context.new
       ctx.merge!(hash)

       ctx
    end
  end
end
