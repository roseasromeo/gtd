module ApplicationHelper

  def page_title(separator = " – ")
    [content_for(:title), 'GTD'].compact.join(separator)
  end

  def page_heading(title)
    content_for(:title){ title }
    content_tag(:h1, title, class: "page_title" )
  end

end
