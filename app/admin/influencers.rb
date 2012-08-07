ActiveAdmin.register Influencer do

  menu :priority => 4, :if => proc{ can?(:manage, Influencer) }
  controller.authorize_resource

  form do |f|
    f.inputs do
      f.input :influencerType, :label => "Influencer type"
      f.input :name
      f.input :url
      f.input :followers
    end
    f.buttons
  end

end
