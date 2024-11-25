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

  # rubocop:disable Metrics/AbcSize
  def my_select
    filtered_items = self.class.new
    length.times do |index|
      filtered_items << self[index] if filtered_items.is_a?(Array) && yield(self[index])
      if filtered_items.is_a?(Hash) && yield(keys[index], self[keys[index]])
        filtered_items[keys[index]] = self[keys[index]]
      end
    end
    filtered_items
  end
  # rubocop:enable Metrics/AbcSize

  def my_all?
    result = true
    length.times do |index|
      (result = yield(self[index]) ? true : false) if is_a?(Array)
      (result = yield(keys[index], self[keys[index]]) ? true : false) if is_a?(Hash)
      break if result.eql?(false)
    end
    result
  end

  def my_any?
    result = false
    length.times do |index|
      (result = yield(self[index]) ? true : false) if is_a?(Array)
      (result = yield(keys[index], self[keys[index]]) ? true : false) if is_a?(Hash)
      break if result.eql?(true)
    end
    result
  end

  def my_none?
    result = true
    length.times do |index|
      (result = yield(self[index]) ? false : true) if is_a?(Array)
      (result = yield(keys[index], self[keys[index]]) ? false : true) if is_a?(Hash)
      break if result.eql?(false)
    end
    result
  end

  def my_count
    return length unless block_given?

    count = 0
    length.times do |index|
      (count += 1 if yield(self[index])) if is_a?(Array)
      (count += 1 if yield(keys[index], self[keys[index]])) if is_a?(Hash)
    end
    count
  end

  def my_map
    modified_data = self.class.new

    length.times do |index|
      (modified_data << yield(self[index])) if is_a?(Array)
      (modified_data[keys[index]] = yield(self[keys[index]])) if is_a?(Hash)
    end
    modified_data
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
