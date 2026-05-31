puts I18nCountryTranslations.name
puts I18nCountryTranslations.is_a?(Module)
puts I18nCountryTranslations.ancestors.include?(I18nCountryTranslations)
puts I18nCountryTranslations.instance_methods(false).length
puts I18nCountryTranslations.respond_to?(:name)
