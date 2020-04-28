require 'ostruct'
require 'spec_helper'
require_relative '../../notiflo/retrieve_speakers'

RSpec.describe Notiflo::RetrieveSpeakers do
  describe '.run' do
    subject { described_class.run(card) }

    context 'when card has internal speakers' do
      let(:card) do
        OpenStruct.new(members: [
          OpenStruct.new(
            full_name: 'Ali Ilman'
          )
        ])
      end

      it { should eq(card.members.map(&:full_name).join("\n")) }
    end

    context 'when card is for project demos' do
      let(:card) do
        OpenStruct.new(
          members: [],
          labels: [OpenStruct.new(name: 'Project Demos')],
          checklists: [
            OpenStruct.new(
              name: 'Projects',
              check_items: [
                {
                  'name' => 'example.com'
                }
              ]
            )
          ]
        )
      end

      let(:checklist) do
        card.checklists.find { |checklist| checklist.name == 'Projects' }
      end

      let(:project_names) do
        checklist.check_items.map do |check_item|
          check_item['name'].split('-').first
        end.join("\n")
      end

      it do
        should eq(project_names)
      end
    end

    context 'when card has external speakers' do
      let(:card) do
        OpenStruct.new(
          members: [],
          labels: [],
          checklists: [
            OpenStruct.new(
              name: 'Speakers',
              check_items: [
                {
                  'name' => 'Liam Gallagher'
                }
              ]
            )
          ]
        )
      end

      let(:checklist) do 
        card.checklists.find { |checklist| checklist.name == 'Speakers' }
      end

      let(:name_of_speaker) do
        checklist.check_items.map { |item| item['name'] }.join("\n")
      end

      it do
        should eq(name_of_speaker)
      end
    end

    context 'when card is yet to be filled with details' do
      let(:card) do
        OpenStruct.new(members: [], labels: [], checklists: [])
      end

      it { should eq('_TBA_') }
    end
  end
end
