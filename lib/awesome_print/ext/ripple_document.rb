module AwesomePrint
  module RippleDocument
    def self.included(base)
      base.send :alias_method, :cast_without_ripple_document, :cast
      base.send :alias_method, :cast, :cast_with_ripple_document
    end

    def cast_with_ripple_document(object, type)
      cast = cast_without_active_record(object, type)
      return cast if !defined?(Ripple::Document)

      if object.is_a?(Ripple::Document)
        cast = :ripple_document_instance
      elsif object.is_a?(Class) && object.ancestors.include?(Ripple::Document)
        cast = :ripple_document_class
      end
      cast
    end

    def awesome_ripple_document_instance(object)
      "#{object} " + awesome_hash(object.attributes.merge(:key => object.key))
    end

    def awesome_ripple_document_class(object)
      data = object.properties.inject(ActiveSupport::OrderedHash.new) do |hash, p|
        hash[p.first.to_sym] = p.last.type.to_s
        hash
      end
      "class #{object} < #{object.superclass} " << awesome_hash(data)
    end
  end
end

AwesomePrint::Formatter.send(:include, AwesomePrint::RippleDocument)
