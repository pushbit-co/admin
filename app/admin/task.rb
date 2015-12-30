ActiveAdmin.register ::Pushbit::Task do
  menu label: "Tasks"
  index do
    id_column
    column :number
    column :status
    column :kind
    column :created_at
    column :updated_at
    column :completed_at
    column :container_status
    column :reason
    actions
  end
end

