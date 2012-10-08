module Support
  module Xml

    def to_ruby_type(element)
      # 子要素が取得できない場合は nil を返す
      return nil if element.nil?

      # 要素が無い場合、属性に nil が付くので、値が true であれば nil を返す
      if element.attributes['nil']
        return nil if element.attributes['nil'] == 'true'
      end

      val = nil
      element_type = element.attributes['type']
      element_type = element_type.downcase if element_type
      case element_type
      when 'integer'
        val = element.text.to_i
      when 'decimal'
        val = element.text.to_f
      when 'datetime'
        val = Time.parse(element.text)
      else
        val = element.text
      end
      return val
    end

  end
end
