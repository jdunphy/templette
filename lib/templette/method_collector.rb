require 'erb'

module Templette
  # Loads a template and evaluates it with ERB.  When a missing method is found, 
  # MethodColletor loads that method into a hash, to be rendered as yaml.
  class MethodCollector
    include Templette::DataAccessors
  
    def initialize(template = nil)
      @methods = {}
      if template
        include_helpers(template.helpers)
        ERB.new(template.to_html, 0, "%<>").result(binding)
      end
    end    
  
    def method_missing(symbol)
      @methods[symbol.to_s] = MethodCollector.new
    end
  
    def to_hash
      return nil if @methods.empty?
      hash = {}
      @methods.each_pair do |k, v|
        hash[k] = v.to_hash
      end
      hash
    end
  end
end