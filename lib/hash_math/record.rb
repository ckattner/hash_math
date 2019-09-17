# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module HashMath
  # A Record serves as a prototype for a Hash.  It will allow the output of hashes
  # conforming to a strict (#make!) or non-strict (#make) shape.
  class Record
    extend Forwardable

    def_delegators :prototype, :key?, :keys

    def initialize(keys = [], base_value = nil)
      @prototype = keys.map { |key| [key, base_value] }.to_h

      freeze
    end

    def make!(hash = {})
      make(hash, true)
    end

    def make(hash = {}, bound = false)
      hash.each_with_object(shallow_copy_prototype) do |(key, value), memo|
        next unless assert_key_in_bounds(key, bound)

        memo[key] = value
      end
    end

    private

    attr_reader :prototype

    # raise error if key is not in key set and bound is true
    # return true if key is in key set and bound is false
    # return false if key is not in key set and bound is false
    def assert_key_in_bounds(key, bound)
      raise KeyOutOfBoundsError, "[#{key}] for: #{keys}" if not_key?(key) && bound

      key?(key)
    end

    def not_key?(key)
      !key?(key)
    end

    def shallow_copy_prototype
      {}.merge(prototype)
    end
  end
end
