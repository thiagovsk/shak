text :hostname do
  title 'Website domain'
  mandatory
end

text :path do
  title 'Path'
  default '/'
end

label_format '%{hostname}%{path}'

text :user do
  title 'User'
  default 'root'
end
text :group do
  title 'Group'
  default 'root'
end

unique :hostname, :path
