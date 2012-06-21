module Jekyll

  class TocBuild < Generator
    # This generator is safe from arbitrary code execution.
    safe true

    # Generate paginated pages if necessary.
    #
    # site - The Site.
    #
    # Returns nothing.
    def generate(site)
      site.site_payload['site']['posts'].reverse
    end
  end
end

