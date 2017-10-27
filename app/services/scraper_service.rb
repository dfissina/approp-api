class ScraperService

  def call(url_resultados, tipo, operacion)
      
    response = Faraday.get url_resultados
    page = Nokogiri::HTML(response.body)
    resultados = page.css('div.row .product-item:not(.proyecto)')
    resultados.each do |resultado|
      begin
        link = resultado.css('div.product-item-image a').first
        href = link.attribute('href')
        url = "http://www.portalinmobiliario.com#{href}" 
        process_property(url, tipo, operacion)
      rescue Exception => e
        pp "Error parsing #{url}:  #{e}"
        next
      end
    end
  
  end

  def process_property(url, tipo, operacion)
    data = parse(url)
    data[:tipo] = tipo
    data[:operacion] = operacion
    if Property.find_by(external_id: data[:codigo]).present?
      puts "Propiedad con codigo: #{data[:codigo]} ya existe :c"
      return
    end
    create_property(data)
  end

  def create_property(data)
    raise "Creando propiedad sin DATA" if data.blank?
    user = User.find_by(email: data[:email])
    User.create(
      email: data[:email],
      nombre: data[:nombre],
      telefono: data[:telefono]&.strip,
      password: data[:email],
      password_confirmation: data[:email],
      rol: 'agent' 
    ) if user.blank?

    comuna_limpia = data[:comuna]&.gsub('\r\n','')&.downcase&.strip
    comuna_limpia = 'ñuñoa' if comuna_limpia=='Ñuñoa'
    comuna = Comuna.where('lower(nombre) = ?', comuna_limpia).first
    raise "No se encontro la comuna #{comuna_limpia} se limpio: #{data[:comuna]}" if comuna.blank?

    property = Property.create(
      titulo: data[:titulo],
      descripcion: data[:descripcion],
      direccion: data[:direccion],
      habitaciones: data[:habitaciones],
      lat: data[:latitude],
      lng: data[:longitude],
      precio_pesos: data[:precio],
      moneda: 'CLP',
      user_id: user.id,
      created_at: data[:publicada],
      tipo: data[:tipo],
      operacion: data[:operacion],
      banios: data[:banios],
      external_id: data[:codigo],
      superficie_terreno: data[:superficie_terreno],
      superficie_construida: data[:superficie_construida],
      comuna_id: comuna.id
    )

    if data[:fotos]
      data[:fotos].first(5).each do |foto|
        PropertyPhoto.create(remote_photo_url: foto, property_id: property.id)
      end
    end
  end

  def parse(url)
    response = Faraday.get url
    puts "PARSING #{url}"
    page = Nokogiri::HTML(response.body)
    titulo = page.css('h4.media-block-title').first.text.strip
    descripcion = page.css('div.propiedad-descr').text.strip
    direccion = page.css('.data-sheet-column-address').text.gsub('Dirección', '').gsub('Direccion', '').strip
    hab_ban = page.css('.data-sheet-column-programm p').to_s.gsub('<p>', '').gsub('</p>', '').gsub('&amp;nbsp', ' ').split('<br>')
    dorm_idx = hab_ban.find_index { |obj| obj.include?('Dormitorio') }
    ban_idx =  hab_ban.find_index { |obj| obj.include?('Baño') }
    hab = (hab_ban.at(dorm_idx)&.to_i || 0) if dorm_idx
    ban = (hab_ban.at(ban_idx)&.to_i || 0) if ban_idx
    latitude = page.css('meta[itemprop="latitude"]')[0]['content'] rescue nil
    longitude = page.css('meta[itemprop="longitude"]')[0]['content'] rescue nil
    photos = page.css('ul.slides a.jackbox').map{|a| a['href']}
    superficies = page.css('.data-sheet-column-area p').to_s.gsub('<p>', '').gsub('</p>', '').gsub('&amp;nbsp', ' ').split('<br>')
    construida_idx = superficies.find_index { |obj| obj.include?('til') }
    total_idx = superficies.find_index { |obj| obj.include?('total') }
    superficie_construida = (superficies[construida_idx]&.to_i || 0) if construida_idx
    superficie_total = (superficies[total_idx]&.to_i || 0) if total_idx
    mini_ficha = page.css('div.propiedad-ficha-mini')
    codigo_publicada = mini_ficha.css('.operation-internal-code strong').map(&:text)
    codigo_idx = codigo_publicada.find_index { |obj| obj.include?('digo') }
    publicada_idx = codigo_publicada.find_index { |obj| obj.include?('ublicada') }
    codigo = (codigo_publicada[codigo_idx]&.to_s&.gsub('Código:', '')&.strip || nil) if codigo_idx
    publicada = (codigo_publicada[publicada_idx]&.to_s&.gsub('Publicada:', '')&.strip || nil) if publicada_idx
    precio = mini_ficha.css('p.price')&.text&.gsub('$', '')&.gsub('.', '').to_i
    js_contacto = page.search('script')[-3].text.gsub('var', '').gsub(';','').gsub("<span itemprop='telephone'>", '').split('=').last.gsub(/\r\n?/, '').gsub(' : ', ':').gsub(' ,', ',').gsub('</span>', '').gsub('&nbsp', '')
    datos_contacto = eval(js_contacto)
    nombre = datos_contacto[:nombreVendedor]
    telefono = datos_contacto[:telefonosVendedor]
    email = datos_contacto[:emailVendedor]
    comuna = page.css('.breadcrumb li').last.text
    return {
      titulo: titulo,
      direccion: direccion,
      habitaciones: hab,
      banios: ban,
      latitude: latitude,
      longitude: longitude,
      nombre: nombre,
      email: email,
      telefono: telefono,
      precio: precio,
      publicada: publicada,
      codigo: codigo,
      superficie_total: superficie_total,
      superficie_construida: superficie_construida,
      fotos: photos,
      descripcion: descripcion,
      comuna: comuna
    }
  end
end


