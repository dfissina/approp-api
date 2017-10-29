namespace :scraper do

  task start: :environment do
	# URLs por comunas
	#https://www.portalinmobiliario.com/venta/departamento/providencia-metropolitana?ca=3&ts=1&mn=2&or=&sf=1&sp=1&at=0&pg=1
	#https://www.portalinmobiliario.com/venta/departamento/las-condes-metropolitana?ca=3
	#https://www.portalinmobiliario.com/venta/departamento/nunoa-metropolitana?ca=3
	#https://www.portalinmobiliario.com/venta/departamento/centro-historico-de-santiago-santiago-santiago-metropolitana?ca=3
	
    operaciones = ['venta', 'arriendo']
    tipos = ['departamento', 'casa']
    comunas = ['providencia-metropolitana', 'las-condes-metropolitana', 'nunoa-metropolitana', 'centro-historico-de-santiago-santiago-santiago-metropolitana']
    
    comunas.each do |comuna|
	    tipos.each do |tipo|
	      operaciones.each do |operacion|
	        pagina = 1
	        last_page_class = 'ultima'
	
	        while last_page_class != 'active'
	          
	          url_resultados = "https://www.portalinmobiliario.com/#{operacion}/#{tipo}/#{comuna}?ca=3&ts=1&mn=2&or=&sf=1&sp=1&at=0&pg=#{pagina}"
	          response = Faraday.get url_resultados
	          page = Nokogiri::HTML(response.body)
	
	          puts "Starting job for page: #{pagina} & tipo: #{tipo} & operacion: #{operacion}"
	          #puts "Starting job for page: #{pagina} & tipo: casa & operacion: venta"
	          ScraperJob.perform_now(url_resultados, tipo, operacion)
	
	          last_page_class = page.css('ul.pagination li')[-1].attr('class')
	          pagina += 1
	        end
	      
	      end
	    end
	end	    
 
  end
end
