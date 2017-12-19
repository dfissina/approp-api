class DocumentType < ApplicationRecord
  
  enum type: [:cedula_identidad, :certificado_dicom, :liquidacion_sueldo, :certificado_laboral]
    
end
