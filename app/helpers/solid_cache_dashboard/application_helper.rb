module SolidCacheDashboard
  module ApplicationHelper
    def page_title
      [
        content_for(:page_title),
        SolidCacheDashboard.configuration.title
      ].compact.join(" - ")
    end

    def badge(text, type)
      tag.span(text, class: "px-2 py-1 text-xs font-medium text-#{type}-700 bg-#{type}-100 rounded-full dark:bg-#{type}-700 dark:text-#{type}-100")
    end

    def format_date(date)
      return "N/A" unless date.is_a?(Time)

      date.strftime("%Y-%m-%d %H:%M:%S")
    end
  end
end
