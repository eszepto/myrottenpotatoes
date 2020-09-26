# Replace API_KEY and API_SECRET with the values you got from Twitter
Rails.application.config.middleware.use OmniAuth::Builder do
    provider :twitter, "GbDCIN405rPcTxD88yriSYFLc", "yxM4EfFXulXAyE24urA5sNYJ2wmVcIUOIm1EqyIwjNvdaHAEQA"
  end