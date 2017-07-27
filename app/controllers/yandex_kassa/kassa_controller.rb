class YandexKassa::KassaController < YandexKassa::ApplicationController

  def pay

	render json: { response: :pay_test }, status: :ok
  end

  def check

  end

  def aviso

  end
 
end
