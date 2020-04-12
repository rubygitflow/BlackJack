# frozen_string_literal: true

module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_reader :validations
    def validate(name, type, *args)
      @validations ||= []
      @validations << { name: name, type: type, args: args }
    end
  end

  module InstanceMethods
    def valid?
      validate!
      true
    rescue StandardError
      false
    end

    private

    def validate!
      validations =
        if self.class.validations.nil?
          self.class.superclass.validations
        else
          self.class.validations
        end
      validations.each do |validation|
        validation[:attr] = instance_variable_get("@#{validation[:name]}")
        send "validate_#{validation[:type]}", validation
      end
    end

    def validate_presence(options)
      raise "Attribute can't be blank!" if options[:attr].to_s.empty?
    end

    def validate_name_format(options)
      raise 'Wrong format attribute!' if options[:attr] !~ options[:args].first
      raise 'Wrong attribute length!' if options[:args][1] &&
                                         options[:attr].size < options[:args][1]
    end

    def validate_kind(options)
      return if options[:attr].is_a?(options[:args].first)

      raise 'Wrong class of attribute!'
    end

    def validate_unique(options)
      raise 'Attribute already exists!' if options[:args]
                                           .first.include?(options[:attr])
    end
  end
end
