Geocoder.configure(
  esri: {
    api_key: [
      Rails.application.credentials.arcgis_user, 
      Rails.application.credentials.arcgis_secret,
    ], 
    for_storage: true
  }
)