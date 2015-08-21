text :hostname do
  title 'Website domain'
  mandatory
end

text :path do
  title 'Path'
  default '/'
end

label_format '%{hostname}%{path}'

unique :hostname, :path
