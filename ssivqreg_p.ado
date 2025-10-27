program ssivqreg_p

	syntax newvarname [if] [in] , [xb Equation(passthru)]
	
	marksample touse , novarlist
	
	_predict `typlist' `varlist' if `touse' , xb `equation'
	

end

