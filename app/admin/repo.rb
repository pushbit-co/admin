ActiveAdmin.register ::Pushbit::Repo do
  menu label: "Repos"
  filter :name
  filter :owner
  filter :private
  filter :active
end

