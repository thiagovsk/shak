select :site_type do
  title 'Site type'
  mandatory
  default :push
  option :push, 'Content is pushed by users over SSH'
  option :pull, 'Content is pulled from a git repository'
  option :archive, 'Content is uploaded as a compressed archive'
end

text :git_repository do
  title 'URL of the git repository'
  dependent_on :site_type, :pull
  mandatory
end

blob :archive do
  title 'Archive with site contents'
  dependent_on :site_type, :archive
  mandatory
  # TODO validate content type and/or filename
end
