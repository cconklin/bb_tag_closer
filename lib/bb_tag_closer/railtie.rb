module BBTagCloser
  class Railtie < Rails::Railtie
    initializer 'bb_tag_closer' do
      ActiveSupport.on_load :active_record do
        include BBTagCloser
      end
    end
  end
end