# -*- coding: utf-8 -*-
module Sablon
  module Statement
    class Insertion < Struct.new(:expr, :field)
      def evaluate(context)
        field.replace(Sablon::Content.wrap(expr.evaluate(context)))
      end
    end

    class Loop < Struct.new(:list_expr, :iterator_name, :block)
      def evaluate(context)
        value = list_expr.evaluate(context)
        value = value.to_ary if value.respond_to?(:to_ary)
        raise ContextError, "The expression #{list_expr.inspect} should evaluate to an enumerable but was: #{value.inspect}" unless value.is_a?(Enumerable)

        content = value.flat_map do |item|
          iteration_context = context.merge(iterator_name => item)
          block.process(iteration_context)
        end
        block.replace(content.reverse)
      end
    end

    class Condition < Struct.new(:conditon_expr, :block, :predicate)
      def evaluate(context)
        value = conditon_expr.evaluate(context)
        to_test = nil
        if predicate
          arg_matches = /(?<m>[^(]+)\s*\(\s*(?<args>[^(]+)\)\s*/.match(predicate)
          if arg_matches.nil?
            to_test = value.public_send(predicate)
          else
            m = arg_matches[:m].strip
            args = arg_matches[:args].split(",").map { |arg| arg.strip }
            to_test = value.public_send(m, *args)
          end
        else
          to_test = value
        end

        if truthy?(to_test)
          block.replace(block.process(context).reverse)
        else
          block.replace([])
        end
      end

      def truthy?(value)
        case value
        when Array;
          !value.empty?
        else
          !!value
        end
      end
    end
  end

  module Expression
    class Variable < Struct.new(:name)
      def evaluate(context)
        context[name]
      end

      def inspect
        "«#{name}»"
      end
    end

    class LookupOrMethodCall < Struct.new(:receiver_expr, :expression)
      def evaluate(context)
        if receiver = receiver_expr.evaluate(context)
          expression.split(".").inject(receiver) do |local, m|
            case local
            when Hash
              local[m]
            else
              local.public_send m if local.respond_to?(m)
            end
          end
        end
      end

      def inspect
        "«#{receiver_expr.name}.#{expression}»"
      end
    end

    def self.parse(expression)
      if expression.include?(".")
        parts = expression.split(".")
        LookupOrMethodCall.new(Variable.new(parts.shift), parts.join("."))
      else
        Variable.new(expression)
      end
    end
  end
end
