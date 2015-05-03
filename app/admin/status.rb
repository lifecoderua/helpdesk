ActiveAdmin.register Status do
  permit_params :title, :display

  form do |f|
    f.inputs 'Status Details' do
      f.input :title
      if f.object.new_record? || f.object.custom?
        f.input :display, as: :select, collection: Status.displays.keys
      end
    end
    f.actions
  end
end
