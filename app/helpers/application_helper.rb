module ApplicationHelper

	def round(param)
    if param.nil?
      '-'
    else
			number_with_precision(param, precision: 1)    
		end
  end


end
