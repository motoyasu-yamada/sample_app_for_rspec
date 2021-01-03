require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation' do
    it 'is valid with all attributes' do 
      task = build(:task)
      expect(task).to be_valid
      expect(task.errors).to be_empty
    end
  
    it 'is invalid without a title' do 
      task = build(:task, title: nil)
      expect(task).to be_invalid
      expect(task.errors[:title]).to include("can't be blank")
    end
  
    it 'is invalid without a status' do
      task = build(:task, status: nil)
      expect(task).to be_invalid
      expect(task.errors[:status]).to include("can't be blank")    
    end
  
    it 'is invalid with a invalid status' do
      expect {build(:task, status: 3)}.to raise_error(ArgumentError,"'3' is not a valid status")
    end

    it 'is invalid with a duplicated title' do
      original = create(:task)
      task = build(:task, title: original.title)
      expect(task).to be_invalid
      expect(task.errors[:title]).to include("has already been taken")    
    end

    it 'is valid with another title' do 
      create(:task)
      task = build(:task)
      expect(task).to be_valid
      expect(task.errors).to be_empty
    end
  end
end
