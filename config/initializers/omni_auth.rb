class OmniAuth
  Rails.application.config.middleware.use OmniAut::Builder do
    provider :facebook, '313633625769590', 'adfdff2d7461975bd6b8533760b514c1'
  end
end