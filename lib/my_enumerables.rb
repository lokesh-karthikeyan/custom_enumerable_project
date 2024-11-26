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

  def my_all?(pattern = nil, &block)
    my_each { |element| return false unless block.call(element) } if block_given?
    my_each { |element| return false unless element } unless block_given?
    my_each { |element| return false unless element.is_a?(pattern) } unless pattern.nil?
    true
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  def my_any?(pattern = nil, &block)
    my_each { |element| return true if block.call(element) } if block_given?
    my_each { |element| return true if element } unless block_given? || pattern
    my_each { |element| return true if element.is_a?(pattern) } unless pattern.nil?
    false
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  def my_none?(pattern = nil, &block)
    my_each { |element| return false if element.is_a?(pattern) } if pattern
    my_each { |element| return false if block.call(element) } if block_given?
    my_each { |element| return false if element } unless block_given?
    true
  end

  def my_count(item = nil, &block)
    return length unless block_given? || !item.nil?

    count = 0
    my_each { |element| count += 1 if element.eql?(item) } if item
    my_each { |element| count += 1 if block.call(element) } if block_given?
    count
  end

  def my_map(arg = nil, &block)
    return to_enum(:map) unless block_given? && arg.nil?

    modified_data = self.class.new

    my_each { |element| modified_data << yield(element) } if is_a?(Array)
    my_each { |key, value| modified_data[key] = block.call(key, value) } if is_a?(Hash)
    modified_data
  end

  # rubocop:disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
  def my_inject(initial = nil, second = nil)
    array = is_a?(Array) ? self : to_a

    symbol = initial if initial.is_a?(Symbol)
    symbol = second if second.is_a?(Symbol)

    accumulator = initial if initial.is_a?(Integer)

    array.my_each { |item| accumulator = accumulator ? accumulator.send(symbol, item) : item } if symbol
    array.my_each { |item| accumulator = accumulator ? yield(accumulator, item) : item } if block_given?
    accumulator
  end
  # rubocop:enable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
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

# puts 'my_all? vs all?'
# numbers = [1, 2, 3, 4, 5]
# correct_numbers = [2, 4, 6, 8, 10]
# p(numbers.my_all?(&:even?))
# p(numbers.all?(&:even?))
# puts "\n"
# p(correct_numbers.my_all?(&:even?))
# p(correct_numbers.all?(&:even?))
# puts "\n"
# p numbers.my_all?(Numeric)
# p numbers.all?(Numeric)
# puts "\n"
# p numbers.my_all?
# p numbers.all?
# puts "\n\n"

# puts 'my_any? vs any?'
# numbers = [1, 2, 3, 4, 5]
# wrong_numbers = [1, 3, 5, 7, 9]
# p(numbers.my_any?(&:even?))
# p(numbers.any?(&:even?))
# p(wrong_numbers.my_any?(&:even?))
# p(wrong_numbers.any?(&:even?))
# puts "\n"
# p numbers.my_any?
# p numbers.any?
# p numbers.my_any?(Integer)
# p numbers.any?(Integer)
# p numbers.my_any?(String)
# p numbers.any?(String)
# puts "\n\n"

# puts 'my_none? vs none?'
# numbers = [1, 2, 3, 4, 5]
# wrong_numbers = [1, 3, 5, 7, 9]
# p(numbers.my_none?(&:even?))
# p(numbers.none?(&:even?))
# p(wrong_numbers.my_none?(&:even?))
# p(wrong_numbers.none?(&:even?))
# p [].my_none?
# p [].none?
# p [nil, true].my_none?
# p [nil, true].none?
# p [].my_none?(Float)
# p [].none?(Float)
# puts "\n\n"

# puts 'my_count vs count'
# ary = [1, 2, 4, 2]
# p ary.count
# p ary.my_count
# p ary.count(2)
# p ary.my_count(2)
# p(ary.count(&:even?))
# p(ary.my_count(&:even?))
# puts "\n\n"

# puts 'my_map vs map'
# numbers = [1, 2, 3, 4, 5]
# p(numbers.my_map { |value| value })
# p(numbers.map { |value| value })
# p(numbers.my_map { |value| value if value.even? })
# p(numbers.map { |value| value if value.even? })
# p numbers.my_map
# p numbers.map
# my_proc = proc { |value| value }
# p numbers.my_map(my_proc)
# my_proc = proc { |value| value if value.even? }
# p numbers.my_map(my_proc)
# puts "\n\n"

# puts 'my_inject vs inject'
# numbers = [1, 2, 3, 4, 5]
# p(numbers.my_inject { |sum, n| sum * n })
# p(numbers.inject { |sum, n| sum * n })
#
# def multiply_els(arr)
#   arr.my_inject { |sum, n| sum * n }
# end
#
# p multiply_els([2, 4, 5])
# p (5..10).inject(1) { |product, n| product * n }
# p (5..10).my_inject(1) { |product, n| product * n }
#
# p (5..10).inject(1, :*)
# p (5..10).my_inject(1, :*)
#
# p (5..10).inject(:+)
# p (5..10).my_inject(:+)
