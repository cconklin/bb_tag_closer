require "bb_tag_closer/version"
require "bb_tag_closer/railtie" if defined? Rails
module BBTagCloser
  require 'active_support/configurable'

  attr_accessor :font_size
  attr_accessor :font_color


  def self.included(base)
    base.attr_accessible :font_size, :font_color
    base.extend ClassMethods
  end

  module ClassMethods

    # ActiveRecord text attributes are considered taggable by default.
    # Using auto_close_bb_tags_for overrides default attributes with custom attributes.

    def taggable_fields
      columns.map {|c| {c.name.to_sym => c.type}}.delete_if {|i| not i.value? :text}.map(&:keys).flatten
    end

    # Closes tags on text attributes.
    # Closes tags before save by default, but can be overridden by passing :on;
    # the :on paramater accepts :save, :create, :update, :validation.
    # Alternatively, pass :no_callback => true to prevent tags from being closed automatically
    # (you will have to close them in the controller).
    # If custom mass_assignment is used such as attr_accessible :foo, :as => :bar
    # pass :mass_assignment_keys => :bar or :mass_assignment_keys => [:bar, :baz].
    
    def auto_close_bb_tags(options = {})
      unless options[:no_callback]
        target = [:create, :update, :validation].include?(options[:on]) ? "before_#{options[:on]}" : "before_save"
        send(target, :close_tags)
      end
      mass_assignment_keys = Array options[:mass_assignment_keys]
      mass_assignment_keys.each do |key|
        attr_accessible :font_size, :font_color, :as => key
      end
    end

    # Specify which attributes to close tags on. Accepts the same options as auto_close_bb_tags.

    def auto_close_bb_tags_for(*args)
      options = args.extract_options!
      auto_close_bb_tags(options)
      self.singleton_class.class_eval do
        define_method :taggable_fields do
          args.delete_if {|i| not i.is_a? Symbol}
        end
      end
    end

  end

  # Sets configuration options. Currently supports setting of custom bb_tags through BBTagCloser.configure 
  # {|config| config.bb_tags = ["u", "b", "s", "i", "quote", "url", "img", "email", "youtube", "size", "color", # additional tags ]}

  def self.configure(&block)
    yield BBTagCloser::Configuration
  end

  # Called during a callback specified in the :on paramater in close_tags or close_tags_for. Closes forum tags in the opposite order they were added by the user.

  def close_bb_tags
    text_attributes = self.class.taggable_fields
    text_attributes.each do |attribute|
      tags = send(attribute).scan(Regexp.new "\\[(.*?)\\]").flatten.delete_if {|c| c.include? "/"}.map {|i| i.include?("=") ? i.slice(Regexp.new "(.*)\\=").chomp("=") : i}.reverse.map(&:downcase).delete_if { |x| not Configuration.bb_tags.include? x } 
      tags.each do |tag|
        open_tags = send(attribute).downcase.scan(Regexp.new "\\[#{tag}=").length + send(attribute).downcase.scan(Regexp.new "\\[#{tag}\\]").length
        closed_tags = send(attribute).downcase.scan(Regexp.new "\\[\\/#{tag}\\]").length
        difference = open_tags - closed_tags
        if open_tags > closed_tags
          send(attribute) << "[/#{tag}]"
        end
      end
    end
  end

  class Configuration
    include ActiveSupport::Configurable
    config_accessor :bb_tags
  end

  configure do |config|
    config.bb_tags = ["u", "b", "s", "i", "quote", "url", "img", "email", "youtube", "size", "color"]
  end
  
end
