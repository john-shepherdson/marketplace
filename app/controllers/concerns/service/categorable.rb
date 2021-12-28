# frozen_string_literal: true

module Service::Categorable
  extend ActiveSupport::Concern

  included { before_action :init_categories_tree, only: :index }

  def category_counters(scope, filters)
    services = search_for_categories(scope, filters)
    counters =
      services.aggregations["categories"]["categories"]["buckets"].each_with_object({}) do |e, h|
        h[e["key"]] = e["doc_count"]
      end
    counters.tap { |c| c[nil] = services.aggregations["categories"]["doc_count"] }
  end

  private

  def init_categories_tree
    @siblings = siblings
    @subcategories = subcategories
    @siblings_with_counters = siblings_with_counters.partition { |_cid, c| c[:category][:name] != "Other" }.flatten(1)
    @subcategories_with_counters =
      subcategories_with_counters&.partition { |_cid, c| c[:category][:name] != "Other" }&.flatten(1)

    # rubocop:disable Naming/MemoizedInstanceVariableName
    @services_total ||= counters[nil]
    # rubocop:enable Naming/MemoizedInstanceVariableName
  end

  def category
    @category ||= Category.friendly.find(params[:category_id]) if params[:category_id]
  end

  def siblings
    category&.ancestry.nil? ? @root_categories : category.siblings.order(:name)
  end

  def subcategories
    category&.children&.order(:name)
  end

  def siblings_with_counters
    siblings.each_with_object({}) { |cat, h| h[cat.id] = { category: cat, counter: count_services(cat) } }
  end

  def subcategories_with_counters
    subcategories&.inject({}) do |h, cat|
      h[cat.id] = { category: cat, counter: count_services(cat) }
      h
    end
  end

  def count_services(category)
    services = search_for_categories(scope, all_filters).map { |s| s.id.to_i }
    (counters[category.id] || 0) +
      category.descendants.map { |c| c.services.to_a.map(&:id) & services }.flatten.uniq.size
  end

  def counters
    @counters ||= category_counters(scope, all_filters)
  end
end
