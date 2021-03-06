require 'spec_helper'

describe Video do
  it {should belong_to (:category)}
  it {should have_many(:reviews).order("created_at DESC")}
  it {should validate_presence_of (:title)}
  it {should validate_presence_of (:description)}

  describe "#search_by_title" do
    context "no match" do
      it "returns an empty array" do
        expect(Video.search_by_title("some title")).to eq([])
      end
    end

    context "perfect match" do
      it "returns an array of one video" do
        vid = Fabricate(:video)
        expect(Video.search_by_title("#{vid.title}")).to eq([vid])
      end
    end
    
    context "partial match" do
      it "returns an array of one video"  do
        str = "some string"
        vid1 = Fabricate(:video, title: "#{str} abc")
        vid2 = Fabricate(:video, title: "abc")
        expect(Video.search_by_title("#{str}")).to eq([vid1])
      end
    end

    context "multiple matches" do
      it "returns an array of all matches ordered by created_at" do
        str = "some string"
        vid1 = Fabricate(:video, title: "#{str} abc")
        vid2 = Fabricate(:video, title: "#{str} def")
        expect(Video.search_by_title("#{str}")).to eq([vid2, vid1])
      end
    end

    context "no match" do
      it "returns an empty array with a search with an empty string" do
        expect(Video.search_by_title("")).to eq([])
      end
    end
  end
end
