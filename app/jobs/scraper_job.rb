class ScraperJob < ApplicationJob
  queue_as :default

  def perform(*args)
    url_resultados = args[0]
    pp "Starting ScraperJob #{url_resultados}"
    tipo = args[1]
    operacion = args[2]
    ScraperService.new.call(url_resultados, tipo, operacion)
  end
end
