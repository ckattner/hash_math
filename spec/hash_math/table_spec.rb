# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe HashMath::Table do
  RowId   = Struct.new(:id1, :id2)
  FieldId = Struct.new(:name1, :name2)

  let(:base_value) { 'NOT_ADDED' }

  context 'with simple row and field id types' do
    let(:prototype) do
      HashMath::Record.new(%i[name age location], base_value)
    end

    subject { described_class.new(prototype) }

    it 'works for integer row_id and symbol field_id' do
      subject.add(1, :name, 'matt')
      subject.add(2, :age, 990)
      subject.add(3, :location, 'earth')

      rows = subject.to_a

      expected = [
        described_class::Row.new(1, name: 'matt', age: base_value, location: base_value),
        described_class::Row.new(2, name: base_value, age: 990, location: base_value),
        described_class::Row.new(3, name: base_value, age: base_value, location: 'earth')
      ]

      expect(rows).to eq(expected)
    end

    it 'raises KeyOutOfBoundsError if field_id is not defined in the record' do
      expect { subject.add(4, 'name', '') }.to          raise_error(HashMath::KeyOutOfBoundsError)
      expect { subject.add(4, :something_else, '') }.to raise_error(HashMath::KeyOutOfBoundsError)
    end
  end

  context 'with more complex object subclass row and field id types' do
    let(:prototype) do
      HashMath::Record.new(
        [
          FieldId.new(:name, :first),
          FieldId.new(:address, :st1)
        ],
        base_value
      )
    end

    subject { described_class.new(prototype) }

    it 'works for more complex row_id and field_id' do
      subject.add(RowId.new(1, 2), FieldId.new(:name, :first), 'matt')
      subject.add(RowId.new(3, 4), FieldId.new(:name, :first), 'nick')
      subject.add(RowId.new(5, 6), FieldId.new(:name, :first), 'sam')

      subject.add(RowId.new(1, 2), FieldId.new(:address, :st1), 'mag mile')
      subject.add(RowId.new(3, 4), FieldId.new(:address, :st1), 'saturn ln.')

      rows = subject.to_a

      expected = [
        described_class::Row.new(
          RowId.new(1, 2),
          FieldId.new(:name, :first) => 'matt',
          FieldId.new(:address, :st1) => 'mag mile'
        ),
        described_class::Row.new(
          RowId.new(3, 4),
          FieldId.new(:name, :first) => 'nick',
          FieldId.new(:address, :st1) => 'saturn ln.'
        ),
        described_class::Row.new(
          RowId.new(5, 6),
          FieldId.new(:name, :first) => 'sam',
          FieldId.new(:address, :st1) => base_value
        )
      ]

      expect(rows).to eq(expected)
    end
  end
end
