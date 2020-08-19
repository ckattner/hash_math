# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe HashMath::Mapper do
  let(:active)   { { id: 1, name: 'active' } }
  let(:inactive) { { id: 2, name: 'inactive' } }
  let(:archived) { { id: 3, name: 'archived' } }

  let(:single)   { { id: 1, code: 'single' } }
  let(:married)  { { id: 2, code: 'married' } }
  let(:divorced) { { id: 3, code: 'divorced' } }

  let(:patient_statuses) { [active, inactive, archived] }
  let(:marital_statuses) { [single, married, divorced] }

  subject do
    described_class
      .new(mappings)
      .add_each(:patient_statuses, patient_statuses)
      .add_each(:marital_statuses, marital_statuses)
  end

  let(:mappings) do
    [
      {
        lookup: {
          name: :patient_statuses,
          by: :name
        },
        set: :patient_status_id,
        value: :patient_status,
        with: :id
      },
      {
        lookup: {
          name: :marital_statuses,
          by: :code
        },
        set: :marital_status_id,
        value: :marital_status,
        with: :id
      }
    ]
  end

  let(:omitted) do
    { patient_id: 1 }
  end

  let(:filled) do
    { patient_id: 2, patient_status: 'active', marital_status: 'single' }
  end

  let(:mismatched) do
    { patient_id: 2, patient_status: 'doesnt_exist', marital_status: 'no_exist' }
  end

  describe '#add' do
    it 'raises ArgumentError when name is nil' do
      expect { subject.add(nil, {}) }.to raise_error(ArgumentError)
    end

    it 'raises ArgumentError when name is empty string' do
      expect { subject.add('', {}) }.to raise_error(ArgumentError)
    end
  end

  describe '#add_each' do
    it 'raises ArgumentError when name is nil' do
      expect { subject.add_each(nil, []) }.to raise_error(ArgumentError)
    end

    it 'raises ArgumentError when name is empty string' do
      expect { subject.add_each('', []) }.to raise_error(ArgumentError)
    end
  end

  describe '#map' do
    context 'with nil input' do
      it 'returns base mapped hash' do
        expected = {
          patient_status_id: nil,
          marital_status_id: nil
        }

        actual = subject.map(nil)

        expect(actual).to eq(expected)
      end
    end

    context 'with missing keys input' do
      it 'returns hash with nil values' do
        expected = omitted.merge(
          patient_status_id: nil,
          marital_status_id: nil
        )

        actual = subject.map(omitted)

        expect(actual).to eq(expected)
      end
    end

    context 'with present keys input' do
      it 'returns hash with values' do
        expected = filled.merge(
          patient_status_id: 1,
          marital_status_id: 1
        )

        actual = subject.map(filled)

        expect(actual).to eq(expected)
      end
    end

    context 'with present keys input but no values match lookups' do
      it 'returns hash with nil values' do
        expected = mismatched.merge(
          patient_status_id: nil,
          marital_status_id: nil
        )

        actual = subject.map(mismatched)

        expect(actual).to eq(expected)
      end
    end
  end
end
