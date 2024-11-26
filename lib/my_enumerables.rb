# frozen_string_literal: true

# This is an extension for the module 'Enumerable'
module Enumerable
  # Your code goes here
  def my_each_with_index
    return to_enum(:each_with_index) unless block_given?

    length.times { |index| yield(self[index], index) } if is_a?(Array)
    length.times { |index| yield([keys[index], self[keys[index]]], index) } if is_a?(Hash)
    self
  end

  def my_select
    return to_enum(:select) unless block_given?

    filtered_items = self.class.new
    my_each { |element| filtered_items << element if yield(element) } if is_a?(Array)
    my_each { |key, value| filtered_items[key] = value if yield(key, value) } if is_a?(Hash)
    filtered_items
  end

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

  def my_inject(args)
    accumulator = args.nil? ? first : args
    length.times do |index|
      accumulator = yield(accumulator, self[index])
    end
    accumulator
  end
end

# You will first have to define my_each
# on the Array class. Methods defined in
# your enumerable module will have access
# to this method
class Array
  # Define my_each here
  def my_each
    return to_enum unless block_given?

    length.times { |index| yield(self[index]) }
    self
  end
end

# Custom methods for 'Hash' class
class Hash
  def my_each
    return to_enum unless block_given?

    keys.length.times { |index| yield(keys[index], self[keys[index]]) }
    self
  end
end

# puts 'my_each vs each'
# numbers = [1, 2, 3, 4, 5]
# p(numbers.my_each { |item| p item })
# p(numbers.each { |item| p item })
# p numbers.my_each
# p numbers.each
# puts "\n"
# hashes = { a: 'a', b: 'b', c: 'c' }
# p(hashes.my_each { |key, value| puts "#{key}: #{value}" })
# p(hashes.each { |key, value| puts "#{key}: #{value}" })
# p hashes.my_each
# p hashes.each
# puts "\n\n"
#
# puts 'my_each_with_index vs each_with_index'
# numbers = [1, 2, 3, 4, 5]
# p(numbers.my_each_with_index { |value, index| p "#{index}: #{value}" })
# p(numbers.each_with_index { |value, index| p "#{index}: #{value}" })
# p numbers.my_each_with_index
# p numbers.each_with_index
# puts "\n"
# hashes = { a: 'a', b: 'b', c: 'c' }
# p(hashes.my_each_with_index { |value, index| p "#{index}: #{value}" })
# p(hashes.each_with_index { |value, index| p "#{index}: #{value}" })
# p hashes.my_each_with_index
# p hashes.each_with_index
# puts "\n\n"

# puts 'my_select vs select'
# numbers = [1, 2, 3, 4, 5]
# p(numbers.my_select(&:even?))
# p(numbers.select(&:even?))
# p(numbers.my_select(&:odd?))
# p(numbers.select(&:odd?))
# p numbers.my_select
# p numbers.select
# puts "\n"
# hashes = { a: 1, b: 2, c: 3, d: 4, e: 5 }
# p(hashes.my_select { |_key, value| value.even? })
# p(hashes.select { |_key, value| value.even? })
# p(hashes.my_select { |_key, value| value.odd? })
# p(hashes.select { |_key, value| value.odd? })
# p hashes.my_select
# p hashes.select
