*! ssivqreg , v0.0.9 CKOL NIKR PAB, 2025-10-8
* 2025-10-20 : check for packages moremata and amcmc are installed 
* 2025-10-15 : check if rho and bstep2 are set  
* 2025-10-8  : subprogram to pass the algorithms options 
* 2025-10-5  : sa option includes parameters for the simulated annealing 
* 2025-09-15 : added log option
* 2024-11-10 : added option bStep2 , itol and ptol (gmm)
* 2024-11-01 : added option for noAB criterion
* 2024-10-06 : added option for the one step estimator (exogenous case: ssqr)
* 2024-09-29 : added option for the gmm optimal weighting matrix (optgmm)
* 2024-09-19 : added no 2nd step gmm option (no2steps)
* 2024-05-04 : added timer
* 2024-02-24 : handling of factor variables (omitted variables) for the smoothed gmm
* 2024-01-28 : vce boostrap option 
* 2024-01-13 : added qrsolve option (use qrsolve instead of normal equations for lp_fnm)
* 2024-01-12 : logit + level options
* 2023-12-27 : added option tol for rq 
* 2023-12-22 : option for preprocessing quantile regression with fnm (pfnm)
* 2023-12-05 : Sample selection statistic
* 2023-11-19 : options for weights 
* 2023-08-16 : option nrho with 1 or 2 arguments
* 2023-03-22 : option for supplying a Stata matrix for the grid for the copula parameter(s)
* 2023-03-21 : option gradient added 
* 2023-03-19 : added message on excluded instruments
* 2023-03-16 : added criterion of objective funtion from AB's model
* 2023-03-15 : version 0.0.2. options for amcmc
* 2023-03-14 : option for moptimize
* 2023-03-01 : added AMCMC option
* 2023-01-29 : added sample selection test option
* 2023-01-09 : remove base/omitted factor variables from factor variables list
*              as it give problems for estimation.
* 2023-01-05: ssivqreg gives the Wald Statistic when using the Cherzhonukov/Hansen's estimator 
* modified 2022-12-29: implementation of Spearman and Kendat's tau rank correlation 
* modified 2022-12-28: added maxiter (simulated annealing and gmm) and print option (SA)
* modified 2022-12-07
* modified 24-11-2022: added a saiv and a seed option (for SA) 
* modified 04-11-2022
* modified 11-01-2021
* modified 06-07-2021: changed some option step2 instead of step 3

/*
Copulas available

Gaussian
Frank
Plackett
Clayton
Gumbel
Joe
G-BB1
G-Frank (BB7)

*/

program ssivqreg , eclass
* version 15.0

		if replay() {
                if "`e(cmd)'"!="ssivqreg" { 
                        error 301 
                } 
//                 if _by() {
//                         error 190 
//                 }
        syntax [, Level(cilevel)]
                ereturn display, level(`level')
				exit
        }

		
		syntax anything(name=maineq) [if] [pw/] , [SELect( /*varlist fv*/ string) ///
		                                          Copula(string)                 ///
											      Quantile(numlist)              ///
											      nrho(numlist min=1 max=2)               ///
											      nalpha(integer 10)             ///
											      ps(varname)                    ///
											      step2(numlist)                 ///
												  /*step3(numlist)*/             ///
											      rho(string)                    ///
											      noshow                         ///
											      noSTDerr                       ///
											      Rescale                        ///
											      seed(string)                   ///
											      SSTest                         ///
											      trace                          ///
												  ALGOrithm(string)              ///
												  sa                             ///
												  saiv sivqr GMMsivqr PROFiled   ///
											      GRADient                       ///
											      gn gf mopt recap from(string)  ///
											      maxiter(integer 100)           ///
												  rqtol(real 1e-05)              ///
											      print(integer 0)               ///
											      EVALType(string) amcmc         ///
											      ndraws(numlist max=2)          ///
											      nburns(numlist max=2)          ///
											      dampers(numlist max=2)         ///
											      arate(numlist max=2)           ///
											      grid(string)                   ///
											      pfnm logit level(passthru)     ///
												  vce(string) qrsolve no2steps   ///
												  optgmm ONEstep noab            ///
												  bStep2(string)                 ///
												  itol(real 1e-09)               ///
												  ptol(real 1e-09)               ///
												  log]
		
		
		** Check that the moremata package is installed
		cap findfile lmoremata.mlib , path(`"`c(adopath)'"')
		if _rc > 0 {
			di "{error: The package moremata is not installed!}"
			error 601
		}
		
		marksample touse , zeroweight
		
// 		di "sa = `sa'"
// 		di "Algorithm = `algorithm'"
// 		count if `touse'
		_ssivqreg_parse `maineq' , touse(`touse')
		
		
		/* Test if user has chosen more than one algorithm */
		local algo : word 1 of `algorithm' 
		local nalg : word count `profiled' `gmmsivqr' `sa' `saiv' `amcmc' `algo'
		
		cap assert `nalg' <= 1
		if _rc {
			display "{error: More than one algorithm chosen}"
			error 198
		}
		local method `profiled' `gmmsivqr' `sa' `saiv' `amcmc' `algo'
		
		** Check that the amcmc package is installed
		if (inlist("amcmc", "`algo'", "`amcmc'")) {
				cap findfile lamcmc.mlib , path(`"`c(adopath)'"')
				if _rc > 0 {
					di "{error: amcmc option is selected, but the package amcmc is not installed!}"
					error 601
				}
		}
		
				
		/* test if nostderr and vce are both chosen by the user */
		
		if ("`stderr'"!="" & "`vce'" !="") {
			display "{error: You have selected both nostderr and vce options}"
			error 198
		}
		
		/* vce type */
		gettoken vce_type : vce , parse(",")
// 		di "`vce_type'"
		if "`vce_type'" == "none" local stderr stderr
		if (!inlist(strtrim("`vce_type'"), "", "as", "asymptotic", "boot", "bootstrap", "none" )) {
			display "{error: option `vce' not valid}"
			error 198
		}
		
		if ("`rho'"!="" & "`bstep2'" =="") {
			di "{err:Warning: }{txt}option {input:rho()} requires option {input:bstep2()} to compute the covariance."
			di "{input: The computation of the covariance will be turned off}"
			local stderr stderr
		} 
		
		

		local hasStep2 = 1
		if ("`step2'" == "" & "`quantile'" =="") local quantile 0.5
		if ("`step2'" != "") {
// 			di "Step 2"
			if ("`quantile'"!="") {
				numlist "`quantile'"
				local tauS3 `r(numlist)'
				numlist "`step2'"
				local quantile `r(numlist)'	
			}
			else {
			    numlist "`step2'"
				local quantile `r(numlist)'				
			}
			
		} 
		else {
			numlist "`quantile'"
			local quantile `r(numlist)'	
			local tauS3 // `quantile'			
		}
		
		local hasStep3 = "`tauS3'"!=""
		if ("`quantile'"=="") {
		    di "Quantile was empty and is now set to 0.5"
			local quantile 0.5			
		}
		if ("`rho'"!="") {
			local rhoS3 `rho'
			if ("`tauS3'"=="") local tauS3 `quantile'
			if ("`step2'"!="") {
			    di "Step 2 and rho options are both specified. ssivqreg will go directly to step 3"
				local hasStep2 = 0
			}
		}
		
		
		local y `s(depvar)'
		local X `s(exrest)'
		local W `s(inst)'
		local E `s(endog)'
		// Store Weights varname in a local : used by ssivqreg to get the weights
		if ("`weight'"!="") {
			local weights `exp'
			local wtype `weight'
		}
		
		gettoken D Z : select
		local D : subinstr local D "=" "", all
		local Z : subinstr local Z "=" "", all
		fvexpand `Z' if `touse'
		local Z `r(varlist)'
		
/*
		di "Z = `Z'"
		di "E = `E'"
		di "X = `X'"
*/

		/* amcmc options */
		
		
		if ("`ndraws'"=="")  local ndraws 5000 5000
		if ("`nburns'"=="")  local nburns 3000 1000
		if ("`dampers'"=="") local dampers .75 1
		if ("`arate'"=="")   local arate   0.5 0.234
		if ("`nrho'"=="")    local nrho 10 
		
		
// #############################################################################
// 	    Parsing the Method options 
// #############################################################################

		
		if ( ("`sa'" !="" | "`saiv'" !="") & "`algorithm'"=="" ) local algorithm sa // , nrho(`nrho') nalpha(`nalpha')

// 		di "algorithm = `algorithm'"
		
		parseAlgoOptions `algorithm'
		foreach s in `s(opts)' {
			if ("`s'"!="") local `s' `s(`s')' // Don't overwrite the values already given
			// di "`s' = ``s''"
		}
		
// 		sret li
// 		di `" s(opts) = `s(opts)'"'
		
/* 
		if ("`ndraws'"=="")  local ndraws 5000 5000
		if ("`nburns'"=="")  local nburns 3000 1000
		if ("`dampers'"=="") local dampers .75 1
		if ("`arate'"=="")   local arate   0.5 0.234
		if ("`nrho'"=="")    local nrho 10 
*/
		
		// error 101
		/*
		foreach var in y X E W Z D {
				if ("`trace'"!="") di "`var': ``var''"
		}
		*/
		tempvar sc
		
		if ("`copula'"=="") local copula Gaussian
		else local copula `= strproper("`copula'")'
	
		cap scalar drop rho
		tempname objFunc grid_rho grid_alpha b_quant
		
// #####################################################################
//     Call of the main mata routine
// #####################################################################
		mata:ssivqreg_main()
		
		if (`r(modelType)'==1)      local title "IV Quantile regression with sample selection"
		else if (`r(modelType)'==2) local title "Quantile regression with sample selection (exogenous regressors)"
		else if (`r(modelType)'==3) local title "IV Quantile regression"
		if (`r(modelType)'==3) local copula 
		
		if (`r(modelType)'<0 & "`stderr'"=="") di "Covariance matrix not computed for this model!"
		else if (`r(modelType)'>=0 & "`stderr'"=="" /* & "`sivqr'"==""*/) {
			tempname V
			/* if ("`sivqr'"=="") */ 
			mat `V' = r(V)
		}
		cap matrix colnames grad = `: colnames b'
		cap matrix coleq    grad = `: coleq    b'
		local ncovar : word count `evar' `xvar'
		
		// Compute the degrees of freedom
		scalar df_r = `r(N)' - `ncovar' - 1
		scalar df_m = `ncovar'
		
		eret clear
		eret post b `V' , depname(`y') obs(`r(N)') e(`touse') properties(b)
		eret scalar  N1 = `r(N1)'
		eret scalar modelType = `r(modelType)'
		cap eret scalar min_objFunc = `r(min_objFunc)'
		eret scalar runtime = `r(runtime)'
// If weights
		if ("`weight'" !="") {
				eret scalar sum_weights = `r(sum_weights)'
				eret scalar sum_weights = `r(sum_weights1)'
				eret local wtype   = "`wtype'"
				eret local wexp    = "`exp'"
		}
		
		eret scalar df_r = df_r
		eret scalar df_m = df_m
		
		if (`e(modelType)'<=2) cap eret matrix grid_rho = `grid_rho'
		if (inlist(`e(modelType)',1,3)) cap eret matrix grid_alpha = `grid_alpha'

		cap eret scalar rc      = rc 
		cap eret matrix grad    =  grad
		cap eret matrix moments = moments
		cap eret matrix scaled_b = scaled_b
		cap eret matrix objFunc = `objFunc'
		cap eret scalar rho = `r(rho)'
		cap eret matrix grid_rho = `r(grid_rho)'
		cap eret matrix Wald = Wald
		cap eret matrix Wald_df = Wald_df
		cap eret matrix b_quant  = `b_quant'
		cap eret matrix taus = `taus'
		cap eret matrix bw   = `bw'
		
		
		cap eret local  copula = "`copula'"
		if (`e(modelType)'<=2) cap eret scalar nrho = `nrho'
		if (inlist(`e(modelType)',1,3)) cap eret scalar nalpha = `nalpha'
		cap eret scalar SpearmanCorr = `r(spearmanCorr)'
		cap eret scalar KendalTau    = `r(KendalTau)'
		cap eret scalar AB_objfnc = `r(AB_objfnc)'
		cap eret scalar ss_stat = ss_stat
		foreach x in ke kx kz kw {
			if (!missing(`r(x)')) cap eret scalar `x' = `r(`x')'
		} 
		
		eret local step2 = "`step2'"
// 		eret local quantiles = "`quantile'"
		eret local plotprocess "e(quantiles) Quantile"  // to be compatible with plotprocess
		
		eret local cmdline `"ssivqreg `0'"'
		eret local cmd     "ssivqreg"
		eret local predict "ssivqreg_p"
		eret local title = "`title'"
		eret local xvar  = "`xvar'"
		eret local psvar = "`psvar'"
		eret local wvar  = "`wvar'"
		eret local selvar= "`selvar'"
// 		eret local zvar  = "`zvar'"
		eret local evar  = "`evar'"
		eret local method = "`method'"
		
		if ("`show'"=="") displayResults `level'
		

end

prog displayResults 


		args level
		
		local start 40
		local skip 1
		local fmt %12.0g  
		di _col(`start') "{txt}Number of obs           = {res}" _skip(`skip') `fmt' `e(N)'
		if ( inlist(`e(modelType)',1,2,4,5,6,7) ) {
			di _col(`start') "{txt}Number of obs selected  = {res}" _skip(`skip') `fmt' `e(N1)'
			if ("`e(min_objFunc)'"!="") di _col(`start') "{txt}Objective function      = {res}" _skip(`skip') `fmt' `e(min_objFunc)'
			di _col(`start') "{txt:AB Objective function   = }" _skip(`skip') "{res}" `fmt' `e(AB_objfnc)'
			di _col(`start') "{txt}Spearman rank corr.     = {res}" _skip(`skip') `fmt' `e(SpearmanCorr)'
			di _col(`start') "{txt}Kendal's tau            = {res}" _skip(`skip') `fmt' `e(KendalTau)'
		}
		if ( `e(modelType)' <= 2 )	di _col(`start') "{txt}# of points grid rho    = {res}" _skip(`skip') `fmt' `e(nrho)'

		if (inlist(`e(modelType)', 1, 3)) di _col(`start') ///
							 "{txt}# of points grid alpha  = {res}" _skip(`skip') `fmt' `e(nalpha)'
		eret di , `level'
		
		if ("`e(wvar)'"!="") di "Excluded instruments for {res: `e(evar)' }: {res: `e(wvar)'}"

end 


prog _ssivqreg_parse , sclass

		syntax anything(equalok) , touse(string)
		
		gettoken y anything : anything
		gettoken left right :  anything , parse("()") match(paren) // bind
	
		
		if ("`right'"=="") {
			local exrest `left'
			local exog `exrest'
		}
		else {
			gettoken endog inst : left , parse("=")
			gettoken junk  inst : inst , parse("=")
			local exrest `right'
			local inst : subinstr local inst "=" "" , all
			local exrest : subinstr local exrest "=" "" , all
			local exog `inst' `exrest'
		}
		
		foreach x in endog inst exrest exog {
				if ("``x''"!="") {
					local newvarlist 
					fvunab `x' : ``x''
					fvexpand ``x'' if `touse'
					local `x' `r(varlist)'
					_rmcoll ``x'' if `touse' , expand
					local `x' `r(varlist)'
// 					di "`r(varlist)'"
// 					di "`r(k_omitted)'"
// 					matrix bt = J(1, `: word count `r(varlist)'',0)
// 					matrix coln bt = `r(varlist)'
// 					_ms_omit_info bt
// 					mat bto = r(omit) 
// 					mat li bto
					
					
// 					foreach v in ``x'' {
// 						qui _ms_parse_parts `v'
// // 						if (!`r(omit)') 
// 						local newvarlist `newvarlist' `v' 
// 					}
// 					local `x' `newvarlist'
// 					di "`x' :  ``x''"
				}
		}
		
		
		
		sret clear
		sret local depvar = "`y'"
		sret local inst   = "`inst'"
		sret local exrest = "`exrest'"
		sret local exog   = "`exog'"
		sret local endog  = "`endog'"
		
end


prog parseAlgoOptions , sclass

		syntax [anything(name=method)] , [copula(string)               ///
						  max_iter(integer 1000)      ///
		                  t(real 5.0)                  /// Simulated annealing
						  r_t(real 0.4)                ///
						  eps(real 0.00001)            ///
						  n_s(integer 5)               ///
						  n_t(integer 5)               ///
						  n_eps(integer 5)             ///
						  rho0(real 0.0)               ///
						  ndraws(numlist min=2 max=2)  /// AMCMC
						  nburns(numlist min=2 max=2)  ///
						  dampers(numlist min=2 max=2) ///
						  arate(numlist min=2 max=2)   ///
													   /// Profiled 
						  nrho(integer 10)             ///
						  nalpha(integer 10)           ///
						  rqtol(real 1e-05)            ///
						  pfnm                         ///
						  maxiter(integer 100)         ///
													   /// Smoothed
						  itol(real 1e-09)             ///
						  ptol(real 1e-09)             ///
						  optgmm                       ///
						  verbose ///
						  ]
						  
		sret clear 		  
// 		di "parseAlgoOptions `0'"
		
		if ("`method'"=="") exit
		
		local method = strlower("`method'")
		if ("`method'"=="gmm") local method gmmsivqr
		if ("`method'"=="one") local method onestep
		
		if !inlist("`method'", "sa", "saiv", "gmmsivqr", "gmm", "amcmc", "profiled", "prof","onestep") {
				di "{error: invalid algorithm options}"
				error 198
		}
		
	
		if ("`copula'"=="")  local copula Gaussian				  
		if ("`ndraws'"=="")  local ndraws 5000 5000
		if ("`nburns'"=="")  local nburns 3000 1000
		if ("`dampers'"=="") local dampers .75 1.0
		if ("`arate'"=="")   local arate   0.5 0.234
		
		if ( inlist("`copula'", "Gaussian", "Frank") ) local rho0 0.0
		else local rho0 = 0.0
		
		local opts copula max_iter ///
		t r_t eps n_s n_t n_eps rho0 ///
		ndraws nburns dampers arate ///
		nrho nalpha rqtol pfnm ///
		itol ptol ///
		method
		
		foreach x in `opts' {
			if ("`verbose'"!="") di "`x' = ``x''"
			sreturn local `x' = "``x''"
			// local nmis_opt 
		}
		sreturn local opts = "`opts'"

		

end