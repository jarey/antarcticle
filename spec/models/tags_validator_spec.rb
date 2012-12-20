# encoding: utf-8

describe TagsValidator do
  let(:validator) { TagsValidator.new({}) }

  before do
    @model = mock('article')
    @model.stub("errors").and_return([])
    @model.errors.stub('[]').and_return({})
    @model.errors[].stub('add')
  end

  context "single" do
    context "valid tag" do
      ["abc", "a bc", "ыввфыв", ".net", "node.js",
       "i`t's", "qwe?", "a-n-t", "C#", "c++", "a"*30].each do |tag|

        it "#{tag} passes validation" do
          @model.stub(:tag_list).and_return([tag])
          @model.should_not_receive("errors")
          validator.validate(@model)
        end

      end
    end

    context "invalid tag" do
      [".", "/", "A/bc", "<html>", "{}", "..",
       "a"*31].each do |tag|

        it "#{tag} doesn't pass validation" do
          @model.stub(:tag_list).and_return([tag])
          @model.errors.should_receive("add")
          validator.validate(@model)
        end

      end
    end
  end

  context "multiple" do
    context "valid tags" do
      let(:tags) { ["abc", "a bc", "ыввфыв", ".net", "node.js",
       "i`t's", "qwe?", "a-n-t", "C#", "c++"] }
      it "passes validation" do
          @model.stub(:tag_list).and_return(tags)
          @model.should_not_receive("errors")
          validator.validate(@model)
      end
    end

    context "invalid tags count" do
      let(:tags) { ["abc"]*11 }
      it "doesn't pass validation" do
        @model.stub(:tag_list).and_return(tags)
        @model.errors.should_receive("add")
        validator.validate(@model)
      end
    end
  end
end
