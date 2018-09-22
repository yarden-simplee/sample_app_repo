# Skip image resizing in testing to avoid errors
if Rails.env.test?
  CarrierWave.configure do |config|
    config.enable_processing = false
  end
end