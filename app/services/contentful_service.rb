class ContentfulService
  CONTENTFUL_ENDPOINT = "https://cdn.contentful.com/".freeze
  CONTENTFUL_PATH = "spaces/#{::CONTENTFUL_SPACE_ID}/environments/#{::CONTENTFUL_ENVIRONMENT}/entries".freeze
  ASSET_PATH = "spaces/#{::CONTENTFUL_SPACE_ID}/environments/#{::CONTENTFUL_ENVIRONMENT}/assets".freeze
  attr_accessor :recipes

  def get_recipes
    begin
      api_response = connection.get(CONTENTFUL_PATH, access_token: ::CONTENTFUL_ACCESS_TOKEN)
      if api_response.success?
        @recipes = JSON.parse(api_response.body)
      end
    rescue Faraday::ConnectionFailed, Faraday::ClientError, Faraday::TimeoutError => exception
      errors << "Unable to connect to Contentful service due to #{exception.message}"
    end
  end

  def get_recipe(entry_id)
    connection.get("#{CONTENTFUL_PATH}/#{entry_id}", access_token: ::CONTENTFUL_ACCESS_TOKEN)
  end

  def get_image(asset_id)
    JSON.parse(connection.get("#{ASSET_PATH}/#{asset_id}", access_token: ::CONTENTFUL_ACCESS_TOKEN).body)
  end

  private

    def connection
      Faraday.new(url: CONTENTFUL_ENDPOINT) do |faraday|
        faraday.adapter Faraday.default_adapter
        faraday.response :json, content_type: 'application/json'.freeze
      end
    end
end
