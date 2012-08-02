ActiveAdmin.register Status do

  menu :priority => 3

  index do
    column :content
    column :created_at
  end


end
