class PropertiesController < ApplicationController

  swagger_controller :properties, 'Properties Managment'
  skip_before_action :authorize_request, only: [:search, :show]
  before_action :set_user, only: [:index, :show, :create, :update, :destroy]
  before_action :set_user_property, only: [:show, :update, :destroy]

  swagger_api :index do
    summary 'Show  all properties'
    param :path, :user_id, :integer, :required, 'User id'
    param :header, :Authorization, :string, :required, 'Authorization'
    response :unauthorized
  end
  
  # GET /user/:user_id/properties
  def index
   @properties =  @user.properties
   properties_size = @properties.size
   @properties.paginate(:page => 1, :per_page => 20)
   render json: {
    properties: ActiveModel::Serializer::CollectionSerializer.new(@properties, serializer: PropertyResultSearchSerializer),
    total_size: properties_size,
    total_pages: 1
   }
  end

  swagger_api :search do
    summary 'Public search properties'
    param :query, :id, :integer, :optional, 'Propiedad id'
    param :query, :cod, :string, :optional, 'Código de la propiedad'
    param :query, :keyword, :string, :optional, 'Palabra Clave'
    param :query, :bedrooms, :integer, :optional, 'Dormitorios'
    param :query, :bathrooms, :integer, :optional, 'Baños'
    param :query, :price1, :double, :optional, 'Precio 1'
    param :query, :price2, :double, :optional, 'Precio 2'
    param :query, :build_mtrs1, :integer, :optional, 'Metros construidos 1'
    param :query, :build_mtrs2, :integer, :optional, 'Metros construidos 2'
    param :query, :total_mtrs1, :integer, :optional, 'Total metros 1'
    param :query, :total_mtrs2, :integer, :optional, 'Total metros 2'
    param_list :query, :property_type, :string, :optional, 'Tipo propiedad', ['casa', 'departamento']
    param_list :query, :operation, :string, :optional, 'Operación', ['venta', 'arriendo']
    param_list :query, :state, :string, :optional, 'Estado', ['nueva', 'usada']
    param_list :query, :currency, :string, :optional, 'Moneda', ['uf', 'clp']
    param :query, :street, :string, :optional, 'Calle'
    param :query, :comuna_id, :string, :optional, 'Comuna id'
    param :query, :region_id, :string, :optional, 'Región id'
    param :query, :condominium, :boolean, :optional, 'Condominio'
    param :query, :furniture, :boolean, :optional, 'Amueblado'
    param_list :query, :orientation, :string, :optional, 'Orientación',
               ['norte', 'sur', 'oriente', 'poniente', 'norte_sur', 'nororiente', 'norponiente', 'suroriente', 'surponiente',
                'oriente_poniente', 'todas']
    param :query, :lat, :double, :optional, 'Latitud'
    param :query, :lng, :double, :optional, 'Longitud'
    param :query, :radius, :integer, :optional, 'Radio de búsqueda (mts)'
    param :query, :page, :integer, :optional, 'Página'
    param :query, :resultsperpage, :integer, :optional, 'Resultados por página'
    param :query, :pets, :boolean, :optional, 'Mascotas'
  end
  
  # GET /search
  def search
      
    @properties = Property.all

    if params[:id].present?
      @properties = @properties.where(id: params[:id])
    end
    
    if params[:cod].present?
      @properties = @properties.where(cod: params[:cod])
    end

    if params[:keyword].present?
      keywords = params[:keyword].split(',')
      @properties = @properties.where((['description LIKE ?'] * keywords.size).join(' OR '), *keywords.map{ |key| "%#{key}%" })
    end
 
    if params[:currency].present?
      @properties = @properties.where(currency: params[:currency])
    end
 
    if params[:property_type].present?
      @properties = @properties.where(property_type: params[:property_type])
    end
    
    if params[:operation].present?
      @properties = @properties.where(operation: params[:operation])
    end
    
    if params[:state].present?
      @properties = @properties.where(state: params[:state])
    end
    
    if params[:comuna_id].present?
      @properties = @properties.where(comuna_id: params[:comuna_id])
    end
    
    if params[:region_id].present?
      @properties = @properties.joins(:comuna).where("comunas.region_id == ?",  params[:region_id])
    end
    
    if params[:price1].present? && params[:price2].present?
      @properties = @properties.where('price between ? and ?', params[:price1], params[:price2])
    end
    
    if params[:condominium].present?
      @properties = @properties.where(condominium: parse_boolean(params[:condominium]))
    end
    
    if params[:furniture].present?
      @properties = @properties.where(furniture: parse_boolean(params[:furniture]))
    end
    
    if params[:orientation].present?
      @properties = @properties.where(orientation: params[:orientation])
    end
    
    if params[:street].present?
      @properties = @properties.where(street: params[:street])
    end
    
    if params[:pets].present?
      @properties = @properties.where(:pets => parse_boolean(params[:pets]))
    end
    
    if params[:bedrooms].present?
      @properties = @properties.where('bedrooms = ?', params[:bedrooms])
    end
    
    if params[:bathrooms].present?
      @properties = @properties.where('bathrooms = ?', params[:bathrooms])
    end
    
    if params[:build_mtrs1].present? && params[:build_mtrs2].present?
      @properties = @properties.where('build_mtrs between ? and ?', params[:build_mtrs1], params[:build_mtrs2])
    end
    
    if params[:total_mtrs1].present? && params[:total_mtrs2].present?
      @properties = @properties.where('total_mtrs between ? and ?', params[:total_mtrs1], params[:total_mtrs2])
    end

    if params[:lat].present? && params[:lng].present?
      if params[:radius].present?
        @properties = @properties.within(params[:radius], :origin => [params[:lat], params[:lng]]).order('lat, lng desc')
      else
        @properties = @properties.within(500, :origin => [params[:lat], params[:lng]]).order('lat, lng desc')
      end
    end


    properties_size = @properties.size
    if params[:resultsperpage].present?
      result_per_page = params[:resultsperpage]
    else
      result_per_page = 20
    end

    if params[:page].present?
      @properties = @properties.paginate(:page => params[:page], :per_page => result_per_page)
    else
      @properties = @properties.paginate(:page => 1, :per_page => result_per_page)
    end

    render json: {
      properties: ActiveModel::Serializer::CollectionSerializer.new(@properties, serializer: PropertyResultSearchSerializer),
      total_size: properties_size,
      total_pages: @properties.total_pages
    }

  end

  swagger_api :show do
    summary 'Show property'
    param :path, :user_id, :integer, :required, 'User id'
    param :path, :id, :integer, :required, 'Property id'
    param :header, :Authorization, :string, :required, 'Authorization'
    response :unauthorized
  end

  # GET /user/:user_id/properties/:id
  def show
    render json: @property, serializer: PropertyResultSearchSerializer
  end

  swagger_api :create do
    summary 'Create property'
    param :path, :user_id, :integer, :required, 'User id'
    param :form, :cod, :string, :required, 'Código de la propiedad'
    param :form, :title, :string, :required, 'Título'
    param :form, :description, :string, :required, 'Descripción'
    param :form, :bedrooms, :integer, :required, 'Dormitorios'
    param :form, :bathrooms, :integer, :required, 'Baños'
    param :form, :price, :double, :required, 'Precio'
    param :form, :build_mtrs, :integer, :required, 'Metros construidos'
    param :form, :total_mtrs, :integer, :optional, 'Total metros'
    param_list :form, :property_type, :string, :required, 'Tipo propiedad', ['casa', 'departamento']
    param_list :form, :operation, :string, :required, 'Operación', ['venta', 'arriendo']
    param_list :form, :state, :string, :required, 'Estado', ['nueva', 'usada']
    param_list :form, :currency, :string, :required, 'Moneda', ['uf', 'clp']
    param :form, :street, :string, :required, 'Calle'
    param :form, :number, :integer, :required, 'Número'
    param :form, :departament, :integer, :optional, 'Número departamento'
    param :form, :neighborhood, :string, :optional, 'Vecindario'
    param :form, :show_pin_map, :boolean, :required, 'Mostrar en mapa'
    param :form, :comuna_id, :string, :required, 'Comuna'
    param :form, :condominium, :boolean, :required, 'Condominio'
    param :form, :furniture, :boolean, :required, 'Amueblado'
    param_list :form, :orientation, :string, :required, 'Orientación',
               ['norte', 'sur', 'oriente', 'poniente', 'norte_sur', 'nororiente', 'norponiente', 'suroriente', 'surponiente',
                'oriente_poniente', 'todas']
    param :form, :parking_lots, :integer, :optional, 'Estacionamientos'
    param :form, :cellar, :boolean, :optional, 'Bodega'
    param :form, :expenses, :double, :optional, 'Expensas'
    param :form, :pets, :boolean, :required, 'Mascotas'
    param :form, :tower, :string, :optional, 'Torre'
    param :form, :terrace, :boolean, :optional, 'Terraza'
    param :form, :lat, :double, :required, 'Latitud'
    param :form, :lng, :double, :required, 'Longitud'
    param :header, :Authorization, :string, :required, 'Authorization'
  end

  # POST /users/:user_id/properties
  def create
   @user.properties.create!(property_params)
   json_response(@user.properties.last, :created)
  end

  swagger_api :update do
    summary 'Update property'
    param :path, :user_id, :integer, :required, 'User id'
    param :path, :id, :integer, :required, 'Property id'
    param :form, :cod, :string, :optional , 'Código de la propiedad'
    param :form, :title, :string, :optional, 'Título'
    param :form, :description, :string, :optional, 'Descripción'
    param :form, :bedrooms, :integer, :optional, 'Dormitorios'
    param :form, :bathrooms, :integer, :optional, 'Baños'
    param :form, :price, :double, :optional, 'Precio'
    param :form, :build_mtrs, :integer, :optional, 'Metros construidos'
    param :form, :total_mtrs, :integer, :optional, 'Total metros'
    param_list :form, :property_type, :string, :optional, 'Tipo propiedad', ['casa', 'departamento']
    param_list :form, :operation, :string, :optional, 'Operación', ['venta', 'arriendo']
    param_list :form, :state, :string, :optional, 'Estado', ['nueva', 'usada']
    param_list :form, :currency, :string, :optional, 'Moneda', ['uf', 'clp']
    param :form, :street, :string, :optional, 'Calle'
    param :form, :number, :integer, :optional, 'Número'
    param :form, :departament, :integer, :optional, 'Número departamento'
    param :form, :neighborhood, :string, :optional, 'Vecindario'
    param :form, :show_pin_map, :boolean, :optional, 'Mostrar en mapa'
    param :form, :comuna_id, :string, :optional, 'Comuna'
    param :form, :condominium, :boolean, :optional, 'Condominio'
    param :form, :furniture, :boolean, :optional, 'Amueblado'
    param_list :form, :orientation, :string, :optional, 'Orientación',
               ['norte', 'sur', 'oriente', 'poniente', 'norte_sur', 'nororiente', 'norponiente', 'suroriente', 'surponiente',
                'oriente_poniente', 'todas']
    param :form, :parking_lots, :integer, :optional, 'Estacionamientos'
    param :form, :cellar, :boolean, :optional, 'Bodega'
    param :form, :expenses, :double, :optional, 'Expensas'
    param :form, :pets, :boolean, :optional, 'Mascotas'
    param :form, :tower, :string, :optional, 'Torre'
    param :form, :terrace, :boolean, :optional, 'Terraza'
    param :form, :lat, :double, :optional, 'Latitud'
    param :form, :lng, :double, :optional, 'Longitud'
    param :header, :Authorization, :string, :required, 'Authorization'
  end

  # PUT /users/:user_id/properties/:id
  def update
   @property.update(property_params)
   head :no_content
  end

  swagger_api :destroy do
      summary 'Delete property'
      param :path, :user_id, :integer, :required, 'User id'
      param :path, :id, :integer, :required, 'Property id'
      param :header, :Authorization, :string, :required, 'Authorization'
   end

  # DELETE /users/:user_id/properties/:id
  def destroy
   @property.destroy
   head :no_content
  end


  private

  def parse_boolean(value)
    value  == "true"
  end
  
  def set_user
    if params[:user_id].present?
      @user = User.find(params[:user_id])
    end
  end
    
  def set_user_property
    @property = @user.properties.find_by!(id: params[:id]) if @user
    @property = Property.find(params[:id])
  end
  
  def property_params
    # whitelist params
    params.permit(
      :title,
      :description,
      :bedrooms,
      :bathrooms,
      :price,
      :build_mtrs,
      :total_mtrs,
      :property_type,
      :operation,
      :state,
      :currency,
      :street,
      :number,
      :neighborhood,
      :show_pin_map,
      :comuna_id,
      :condominium,
      :furniture,
      :orientation,
      :parking_lots,
      :cellar,
      :expenses,
      :pets,
      :tower,
      :terrace,
      :lat,
      :lng,
      :page,
      :keyword,
      :departament,
      :resultsperpage,
      :radius,
      :cod
    )
  end
end
