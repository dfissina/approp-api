class PropertyPhoto < ApplicationRecord
  
  belongs_to :property
  
  mount_uploader :photo, PhotoUploader
  
  validates :photo, file_size: { less_than_or_equal_to: 4.megabytes, message: 'El tamaño de la foto debe ser menor a 4 megabyte.'  },
                                file_content_type: { allow: ['image/jpeg', 'image/png'], message: 'Las fotos de propiedades deben ser JPG o PNG.'  }
  
end
