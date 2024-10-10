module CustomCommonActions
  def customize_help_page
    SiteCustomization::Page.create!(
      slug: "vragen",
      status: "published",
      title: "CONSUL is a platform for citizen participation",
      content: "Another custom page"
    )
  end
end
