# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'hash_math/matrix'
require_relative 'hash_math/record'
require_relative 'hash_math/table'

# Top-level namespace
module HashMath
  class KeyOutOfBoundsError < StandardError; end
end
