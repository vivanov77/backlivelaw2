unless ENV["DYNO"]
  ThinkingSphinx::Index.define :doc_response, :with => :active_record, :delta => true do
    indexes doc_request.title, :as => :doc_request_title, :sortable => true
    indexes text

    has doc_request_id
  end
end