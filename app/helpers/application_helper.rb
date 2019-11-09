module ApplicationHelper
  def sortable(column, title = nil, display_toggle = false)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    display_toggle = display_toggle == true ? true : false
    link_to title, {:sort => column, :direction => direction, :display_toggle => display_toggle}, {:class => css_class}
  end

  def page_title(separator = " – ")
    [content_for(:title), 'GTD'].compact.join(separator)
  end

  def page_heading(title)
    content_for(:title){ title }
    content_tag(:h1, title, class: "page_title" )
  end

end
