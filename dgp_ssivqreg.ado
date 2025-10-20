cap prog drop dgp_ssivqreg
prog dgp_ssivqreg 


	syntax [anything] , [n(integer 10000) rho(real -.2) model(string) ///
	                     copula(string)                               ///
						 ovid method(string) seed(string)]
	
	
	di "***********************************************************************"
	di " DGP selectiv"
	di "***********************************************************************"

	if ("`model'"=="") local model exog 
	if ("`copula'"=="") local copula Gaussian
	if ("`seed'"!="") set seed `seed'
	if ("`ovid'"!="") scalar b_ovid = 1
	else scalar b_ovid = 0
	
	local N `n'
	
	di " N = `N' , rho = `rho', model =  `model', copula = `copula'"
	di "Method = `method' , seed =  `seed'"

	drop _all
	set obs `N'
	drawnorm x1 x2 z z2 zp w , double
	gen rho = `rho'
	
	gen double u = runiform()
	gen double v = .
	if ("`method'"!="") mata: simulv("v","u",(`rho'),"`copula'","`method'")
	else  mata: simulv("v","u",`rho',"`copula'")
	gen double eps_v = invnormal(v)
	gen double eps_u = invnormal(u)
	
	scalar beta1 = 1
	scalar beta2 = 1
	
	clonevar alpha =  u
	
	// endogenous case
	if ("`model'"=="endog") {
			gen double err = u/2 + w/4
			gen byte   p = (x1/2 + x2/2 + zp/2 + z/2 +  eps_v) > 0
			gen byte   d = (x2/2 + z/2 - b_ovid*z2/2  + err/2) > 0
	}
	else {
		drawnorm d // 
		replace    d = w > 0
		compress   d 
		gen byte   p = (d + x1/2 + x2/2 + zp/2 + z/2 +  eps_v) > 0
	}
	
// 	gen double y = alpha*d + x1*beta1 + x2*beta2 + 1 + u 
	gen double y = alpha*d + x1*beta1 + x2*beta2 + 1 + eps_u
	
	gen byte touse = 1

end 

