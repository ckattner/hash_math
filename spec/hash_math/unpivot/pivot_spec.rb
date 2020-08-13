# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe HashMath::Unpivot::Pivot do
  let(:config) do
    {
      keys: %i[first_exam_date last_exam_date consent_date],
      coalesce_key: :field,
      coalesce_key_value: :value
    }
  end

  let(:patient) do
    {
      patient_id: 2,
      first_exam_date: '2020-01-03',
      last_exam_date: '2020-04-05',
      consent_date: '2020-01-02'
    }
  end

  subject { described_class.make(config) }

  describe '#expand' do
    it 'performs a single un-pivoting' do
      actual = subject.expand({}, patient)

      expected = [
        {
          field: :first_exam_date,
          value: '2020-01-03'
        },
        {
          field: :last_exam_date,
          value: '2020-04-05'
        },
        {
          field: :consent_date, value: '2020-01-02'
        }
      ]

      expect(actual).to match_array(expected)
    end
  end
end
