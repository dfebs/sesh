module ApplicationHelper
  def combined_dom_id(*records)
    records.map { |record| dom_id(record) }.join("_")
  end
end
