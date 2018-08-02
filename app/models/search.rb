class Search
  RESOURCES = %w(Questions Answers Comments Users)

  def self.find(query, resource)
    query = ThinkingSphinx::Query.escape(query) if query.present?
    if RESOURCES.include?(resource)
      resource.classify.constantize.search(query)
    else
      ThinkingSphinx.search(query)
    end
  end
end
