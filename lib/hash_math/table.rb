# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module HashMath
  # The main data structure for a virtual table that can be treated as a key-value builder.
  # Basically, it is a hash with a default 'prototype' assigned to it, which serves as the
  # base record.  Then, #add is called over and over passing in row_id, field_id, and value,
  # which gives it enough information to pinpoint where to insert the data (memory-wise.)
  # Imagine a two-dimensional table where X is the field_id axis and row is the Y axis.
  # Since it is essentially backed by a hash, the row_id and field_id can be anything that
  # implements #hash, #eql? and #== properly.
  class Table
    extend Forwardable
    include Enumerable

    Row = Struct.new(:row_id, :fields)

    attr_reader :lookup, :record

    def_delegators :record, :keys, :key?

    def initialize(record)
      raise ArgumentError, 'record is required' unless record

      @lookup = {}
      @record = record

      freeze
    end

    def add(row_id, field_id, value)
      raise KeyOutOfBoundsError, "field_id: #{field_id} not allowed." unless key?(field_id)

      tap { set(row_id, field_id, value) }
    end

    def each
      return enum_for(:each) unless block_given?

      lookup.map do |row_id, fields|
        Row.new(row_id, record.make!(fields)).tap { |row| yield(row) }
      end
    end

    private

    def row(row_id)
      lookup[row_id] ||= {}
    end

    def set(row_id, field_id, value)
      row(row_id)[field_id] = value
    end
  end
end
