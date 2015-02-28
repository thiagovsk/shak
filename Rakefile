require "bundler/gem_tasks"

module Bundler
  class GemHelper
    # Sign tags by default (i.e. s/git tag -a/git tag -s/)
    def tag_version
      sh "git tag -s -m \"Version #{version}\" #{version_tag}"
      Bundler.ui.confirm "Tagged #{version_tag}."
      yield if block_given?
    rescue
      Bundler.ui.error "Untagging #{version_tag} due to error."
      sh_with_code "git tag -d #{version_tag}"
      raise
    end
  end
end
