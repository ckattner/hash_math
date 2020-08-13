# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe HashMath::Unpivot do
  let(:a_and_b_pivot) do
    {
      keys: %i[a b],
      coalesce_key: :ab_key,
      coalesce_key_value: :ab_value
    }
  end

  let(:cd_and_e_pivot) do
    {
      keys: %i[c d e],
      coalesce_key: :cde_key,
      coalesce_key_value: :cde_value
    }
  end

  let(:hash) do
    { a: 1, b: 2, c: 3, d: 4, e: 5 }
  end

  context 'with no pivots' do
    it 'returns the inputted hash only' do
      actual = subject.expand(hash)

      expect(actual).to match_array([hash])
    end
  end

  context 'with nil inputted' do
    it 'returns array with nil' do
      actual = subject.expand(nil)

      expect(actual).to match_array([nil])
    end
  end

  context 'with one pivot' do
    it 'coalesces two columns into two rows' do
      subject.add(**a_and_b_pivot)

      expected = [
        { ab_key: :a, ab_value: 1, c: 3, d: 4, e: 5 },
        { ab_key: :b, ab_value: 2, c: 3, d: 4, e: 5 }
      ]

      actual = subject.expand(hash)

      expect(actual).to eq(expected)
    end
  end

  context 'with two pivots' do
    it 'coalesces five columns into six rows' do
      subject.add(**a_and_b_pivot).add(**cd_and_e_pivot)

      expected = [
        { ab_key: :a, ab_value: 1, cde_key: :c, cde_value: 3 },
        { ab_key: :b, ab_value: 2, cde_key: :c, cde_value: 3 },
        { ab_key: :a, ab_value: 1, cde_key: :d, cde_value: 4 },
        { ab_key: :b, ab_value: 2, cde_key: :d, cde_value: 4 },
        { ab_key: :a, ab_value: 1, cde_key: :e, cde_value: 5 },
        { ab_key: :b, ab_value: 2, cde_key: :e, cde_value: 5 }
      ]

      actual = subject.expand(hash)

      expect(actual).to match_array expected
    end
  end

  describe 'README examples' do
    context 'single patient row and one pivot example' do
      let(:patient) do
        {
          patient_id: 2,
          first_exam_date: '2020-01-03',
          last_exam_date: '2020-04-05',
          consent_date: '2020-01-02'
        }
      end

      let(:pivot_set) do
        {
          pivots: [
            {
              keys: %i[first_exam_date last_exam_date consent_date],
              coalesce_key: :field,
              coalesce_key_value: :value
            }
          ]
        }
      end

      subject { HashMath::Unpivot.new(pivot_set) }

      it 'extrapolates one row into N rows (one per column key)' do
        expected = [
          { patient_id: 2, field: :first_exam_date, value: '2020-01-03' },
          { patient_id: 2, field: :last_exam_date,  value: '2020-04-05' },
          { patient_id: 2, field: :consent_date,    value: '2020-01-02' }
        ]

        actual = subject.expand(patient)

        expect(actual).to match_array(expected)
      end
    end
  end
end
