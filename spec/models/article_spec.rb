require 'rails_helper'

RSpec.describe Article, type: :model do
  let(:article1) { build(:article) }
  
  it "is valid with valid attributes" do
    expect(article1).to be_valid
  end
  
  it "is empty for title" do
    article2 = build(:article, title: "")
    expect(article2).to_not be_valid
  end
  
  it "is empty for body" do
    article2 = build(:article, body: "")
    expect(article2).to_not be_valid
  end
  
  it "is nil for title" do 
    article2 = build(:article, title: nil)
    expect(article2).to_not be_valid
  end
  
  it "is nil for body" do 
    article2 = build(:article, body: nil)
    expect(article2).to_not be_valid
  end
end
