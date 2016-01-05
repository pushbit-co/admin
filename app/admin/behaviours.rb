ActiveAdmin.register ::Pushbit::Behavior do
  menu label: "Behaviors"
  index do
    id_column
    column :name
    actions
  end

  filter :name
end

