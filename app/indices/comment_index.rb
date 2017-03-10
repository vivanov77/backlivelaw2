unless ENV["DYNO"]
  ThinkingSphinx::Index.define :comment, :with => :active_record, :delta => true do
    indexes title
    indexes text
  end
end