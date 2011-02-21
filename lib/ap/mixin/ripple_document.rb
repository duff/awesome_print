module AwesomePrintRippleDocument

  def self.included(base)
    base.send :alias_method, :printable_without_ripple_document, :printable
    base.send :alias_method, :printable, :printable_with_ripple_document
  end

  def printable_with_ripple_document(object)
    printable = printable_without_ripple_document(object)
    return printable if !defined?(Ripple::Document)

    if printable == :self
      if object.is_a?(Ripple::Document)
        printable = :ripple_document_instance
      end
    elsif printable == :class and object.ancestors.include?(Ripple::Document)
      printable = :ripple_document_class
    end
    printable
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

AwesomePrint.send(:include, AwesomePrintRippleDocument)
