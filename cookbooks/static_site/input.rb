text :hostname do
  title 'Website domain'
  mandatory
end

text :path do
  title 'Path'
  default '/'
end

unique :hostname, :path
