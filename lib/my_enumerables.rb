# frozen_string_literal: true

# This is an extension for the module 'Enumerable'
module Enumerable
  # Your code goes here
  def my_each_with_index
    unless is_a?(Hash)
      0.upto(length - 1) { |index| yield(self[index], index) }
      return self
    end

    0.upto(keys.length - 1) { |index| yield(keys[index], self[keys[index]], index) }
    self
  end
end

# You will first have to define my_each
# on the Array class. Methods defined in
# your enumerable module will have access
# to this method
class Array
  # Define my_each here
  def my_each
    length.times { |index| yield(self[index]) }
    self
  end
end

# Custom methods for 'Hash' class
class Hash
  def my_each
    keys.length.times { |index| yield(keys[index], self[keys[index]]) }
    self
  end
end
