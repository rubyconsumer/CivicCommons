# -*- coding: utf-8 -*-

# Ingester is a tool for ingesting the transcript of a Conversation
#
# Ingester.build takes in a transcript text in a mini DSL which is 
# parsed and returns a collection of Ingester::Dialogs representing
# the parsed Contribution to the Conversation
#
# Example transcript
# speaker "John Foo"
# dialog <<-enddialog
# Hello my name is John Foo. Today I will be discussing the case for private wells with home owner Betty Bar.
# enddialog
# 
# speaker "Betty Bar"
# dialog <<-enddialog
# Hi John, thanks for allowing me to a be a part of this discussion.
# enddialog
#
#
# The above transcript would be parsed into 2 Dialog structs:
# [ #<struct Ingester::Dialog speaker="John Foo", time=nil,
#   content="Hello my name is John Foo. Today I will be discussing the case for private wells with home owner Betty Bar.">,
#   #<struct Ingester::Dialog speaker="Betty Bar", time=nil,
#   content="Hi John, thanks for allowing me to a be a part of this discussion."> ]
#
#
# When Ingester.ingest encounters an error it wraps the original exception so
# it can be accessed later and raises an Ingester::Error with info regarding
# the error encountered.
#
class Ingester

  # Represents an ingest error. Used for identifying errors
  # coming from Ingester.
  #
  class Error < RuntimeError
    def initialize(message, wrapped_exception)
      @wrapped_exception = wrapped_exception
      super(message)
    end
  end

  # Takes in a string of text and returns an Array of Dialog
  # Structs representing the dialogs parsed in string
  #
  # raises a wrapped IngesterError when an error occurs
  # parsing or building the Dialogs
  #
  def self.ingest(string)
    begin
      string = munge(string)
      DSL.build(string)
    rescue => e
      friendly_exception_info = parse_exception(e)
      raise Error.new(friendly_exception_info, e)
    end
  end

  protected

  # Handles problems from Copying and Pasting from Microsoft Word into plain
  # text editors
  #
  def self.munge(string)
    # Replace all ISO-8859-1 or CP1252 characters by their UTF-8 equivalent
    # resulting in a valid UTF-8 string
    chars = ActiveSupport::Multibyte::Chars.new(string).tidy_bytes
    
    # Replace \r and \r\n with \n
    chars = chars.gsub("\r\n", "\r").gsub("\r", "\n\n")

    # Replace “smart quotes” with "normal quotes"
    chars = chars.gsub(/[”“]/, '"').gsub(/[‘’]/, "'")

    # Convert back to a string
    chars.to_s
  end

  # Helper method that takes an exception and makes a friendlier
  # error containing the approximate line number in the string of
  # text to Ingest
  #
  # example exception format:
  # NameError: undefined local variable or method `foo' for #<Ingester::DSL:0x000001032c6060>
  # becomes
  #
  # Error ingesting transcript; NameError: undefined local variable or method `foo'
  #
  def self.parse_exception(exception)
    message = exception.message
    
    if exception.backtrace.detect{|l| l =~/IngesterTranscript:(\d+)/}
      line_info = "Error ingesting transcript around line #{$1}"
    else
      line_info = "Error ingesting transcript"
    end

    # Remove info regarding instance of DSL class
    # <Ingester::DSL:0x000001032c6060>
    line_info + "; " + message.gsub(/ for #<.*?>/, "")
  end
  
  # Simple struct for holding a particular "Contribution" of an
  # ingested transcript
  class Dialog < Struct.new(:speaker, :time, :content)
    def partial_dialog?
      (speaker || time) && !content
    end
  end
  
  # Mini DSL for parsing the conversation text. Extends BasicObject
  # to help protect against injection like Kernel#exit
  class DSL < BasicObject
    # 
    def self.build(string)
      builder = new
      builder.instance_eval(string, "IngesterTranscript", 1)
      if builder.current_dialog.partial_dialog?
        builder.raise_illegal_state "Expected a dialog."
      end
      builder.dialogs
    end
    

    # represents the current dialog being read/parsed by DSL
    attr_reader :current_dialog

    # represents an Array of Dialogs that have been read/parsed.
    # Dialogs is oredered earliest parsed to latest.
    attr_reader :dialogs
    
    # Initalize the DSL
    #
    def initialize
      @dialogs = []
      @current_dialog = Dialog.new
    end

    # Sets teh speaker of the current dialog.
    # Raises an error if name is nil or blank or if the
    # current dialog already has a speaker.
    #
    def speaker(name=nil)
      if name.nil? || name.blank?
        raise_illegal_state "You must provide a speaker." 
      elsif @current_dialog.speaker
        raise_illegal_state "Expected a dialog or time."
      end
      @current_dialog.speaker = name.strip
    end

    # Sets the time for the current dialog.
    # Raises an error if time is nil or blank or if the
    # current dialog already has a time.
    #
    def time(_time=nil)
      if _time.nil? || _time.blank?
        raise_illegal_state "You must provide a time."
      elsif @current_dialog.time
        raise_illegal_state "Time has already been set."
      end
      @current_dialog.time = _time
    end

    # sets the content for the dialog.
    # Raises an error if content is nil or blnak or if
    # the current dialog does not have a speaker or
    # already has content.
    #
    def dialog(content=nil)
      if content.nil? || content.blank?
        raise_illegal_state "You must provide a dialog."
      elsif @current_dialog.speaker.nil? || @current_dialog.content
        raise_illegal_state "Expected a speaker before dialog."
      end
      @current_dialog.content = content.strip
      @dialogs << @current_dialog
      @current_dialog = Dialog.new
    end

    # Raise an error prefixed with "illegal state." which can be used to
    # identify DSL based exceptions
    def raise_illegal_state(message)
      raise "illegal state. #{message}"
    end
    
    def raise(*args)
      ::Object.send(:raise, *args)
    end
  end
  
end
