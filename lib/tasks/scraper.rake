namespace :scraper do
  task start: :environment do

    operaciones = ['venta', 'arriendo']
    tipos = ['departamento', 'casa', 'oficina']
    
    tipos.each do |tipo|
      operaciones.each do |operacion|
        pagina = 1
        last_page_class = 'ultima'

        while last_page_class != 'active'
          url_resultados = "http://www.portalinmobiliario.com/#{operacion}/#{tipo}/metropolitana?tp=2&op=2&ca=3&ts=1&dd=0&dh=6&bd=0&bh=6&or=f-des&mn=1&sf=0&sp=0&pg=#{pagina}"
          response = Faraday.get url_resultados
          page = Nokogiri::HTML(response.body)

          puts "Starting job for page: #{pagina} & tipo: #{tipo} & operacion: #{operacion}"
          ScraperJob.perform_later(url_resultados, tipo, operacion)

          last_page_class = page.css('ul.pagination li')[-1].attr('class')
          pagina += 1
        end
      
      end
    end
 
  end
end
