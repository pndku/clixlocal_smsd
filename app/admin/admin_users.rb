ActiveAdmin.register AdminUser do

  menu :priority => 100, :if => proc{ can?(:manage, AdminUser) }
  controller.authorize_resource

  index do
    column :email
    column :current_sign_in_at
    column :last_name
    column :department
    default_actions
  end

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :first_name
      f.input :last_name
      f.input :department
    end
    f.buttons
  end

  after_create { |admin| admin.send_reset_password_instructions }

  def password_required?
    new_record? ? false : super
  end

end
