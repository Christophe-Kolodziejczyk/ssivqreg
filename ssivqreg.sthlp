{smcl}
{* *! version 1.0.1 29-09-2025}{...}
{vieweralsosee "[R] help" "help help "}{...}
{viewerjumpto "Syntax" "ssivqreg##syntax"}{...}
{viewerjumpto "Description" "ssivqreg##description"}{...}
{viewerjumpto "Options" "ssivqreg##options"}{...}
{viewerjumpto "Post-estimation" "ssivqreg##postestimation"}{...}
{viewerjumpto "Remarks" "ssivqreg##remarks"}{...}
{viewerjumpto "Examples" "ssivqreg##examples"}{...}
{viewerjumpto "References" "ssivqreg##references"}{...}
{title:Title}

{phang}
{bf:ssivqreg} {hline 2} estimates quantile regression model with sample selection and endogenous covariates


{marker syntax}{...}
{title:Syntax}

{phang}Quantile regresion with selection - Arellano and Bonhomme's model

{p 8 13 2}
{cmd:ssivqreg} {depvar} [{indepvars}] {ifin} 
[{it:{help ssivqreg##weight:weight}}]
	{cmd:,}  {cmdab:sel:ect}({it:{help depvar: depvar_s}} [=] {it:{help varlist: varlist_s}}) [{it:{help ssivqreg##options:options}}] (1)
{p_end}

{phang}Quantile regression with endogenous variable - Chernozhoukov and Hansen's model

{p 8 13 2}
{cmd:ssivqreg} {depvar} ({varname} = {it: {help varlist:instruments}}) [{indepvars}] {ifin} [{it:{help ssivqreg##weight:weight}}]
	[{cmd:,} {it:{help ssivqreg##options:options}}] (2)
{p_end}

{phang}Quantile regression with endogenous regressors and sample selection

{p 8 13 2}
{cmd:ssivqreg} {depvar} ({varname} [=] {it: {help varlist:instruments}}) [{indepvars}] {ifin} [{it:{help ssivqreg##weight:weight}}]
 {cmd:,}  {cmdab:sel:ect}({it:{help depvar: depvar_s}} [=] {it:{help varlist: varlist_s}})	[{it:{help ssivqreg##options:options}}] (3)
{p_end}


{phang}{cmd:ssivqreg} allows the use of factor variables.
**# Bookmark #1

{marker options}{...}
{title:Options}

{synoptset 30 tabbed}{...}
{marker options}{...}
{synopthdr :options}
{synoptline}
{syntab :Quantiles to be estimated}
{synopt :{opth q:uantile(numlist)}} specifies the quantile(s) to be estimated; default value is 0.5 (the median).{p_end}

{syntab : Quantiles for estimation of the copula paramater - second step}
{synopt :{opth step2(numlist)}} specifies the quantiles to be estimated for identifying/estimating the dependency parameter: Normally more than one quantile (i.e. moment condition) should be used to estimate the copula parameter. The option quantile is used for Step 3.{p_end}

{syntab : Choice of copula}
{synopt :{opth c:opula(string)}} specifies the copula that governs the dependence 
between the main equation and the selection equation.
You can choose between the Gaussian, Frank and Plackett copulas; default value is Gaussian. The option is not case-sensitive.{p_end}


{syntab : Number of grid points for dependency paramater}
{synopt :{opth nrho(integer)}} specifies the number of points to estimate the dependency paramaer; default value is 10.{p_end}


{syntab : Number of grid points for endogenous variable}
{synopt :{opth nalpha(integer)}} specifies the number of points to estimate the parameter of the endogenous variable; default value is 10.{p_end}


{syntab : Algorithms for finding dependency parameter(s)}

{synopt :{opt prof:iled}} Profiled gmm, The default algorithm{p_end}
{synopt :{opt gmm:sivqr}} Minimizes the quadratic form from the smoothed moment conditions by the Gauss-Newton algorithm. Can be used with exogenous and endogenous covariates.{p_end}

{synopt :{opt sa}} Uses Simulated Annealing instead of grid search for finding the optimal dependency parameter(s).{p_end}

{*:syntab : Algorithm for estimating the parameter(s) of the endogenous variables}
{synopt :{opt saiv}} Uses Simulated Annealing instead of grid search for estimating the parameters of the endogenous variables. Only for the endogenous case.{p_end}

{synopt :{opt amcmc}}AMCMC algorithm (can be applied both in the exogenous and endogenous case). 

{synopt: {opt one:step}}Uses the one-step estimator to estimate a quantile process.
This algorithm can be applied only in the exogenous case (syntax 1). 
A fine frid for the quantile process is recommanded and steps=0.01 seems to work well in practice.{p_end}

{*:syntab:Algorithms}
{synopt :{opt algo:rithm}{cmd:(}[{it:{help ssivqreg##algtype:algtype}}]{cmd:,} [{it:{help ssivqreg##algopts:algopts}}]{cmd:)}}Specifies the algorithm{p_end}

{synopthdr:algtype}
{synoptline}

{synopt :{opt prof:iled}}Profiled GMM. The default{p_end}
{synopt :{opt gmm:sivqr}}Smoothed GMM{p_end}
{synopt :{opt sa}}Simulated annealing {p_end}
{synopt :{opt amcmc}}Adaptative Monte Carlo Markov Chain (AMCMC){p_end}
{synopt :{opt onestep}}One-step estimator{p_end}

{synopthdr:algopts}
{synoptline}

{syntab: {it:Profiled}}
{synopt :{opth nrho(integer)}} Number of points for the grid for the dependency parameter. Default value 10.{p_end}
{synopt :{opth nalpha(integer)}}Number of points for the grid for the endogenous variables. Only in the c ase of endogneous covariates (syntaxes 2 and 3). Default value 10.{p_end}
{synopt :{opth rqtol(real)}} Tolerance for the Interior point (Frisch-Newton) algorithm for the rotated quantile regression; default 1e-05{p_end}
{synopt :{opt pfnm}}Quantile regression with pre-processing{p_end}
{synopt :{opth maxiter(integer)}}Maximum number of iterations for the Frisch-Newton algorithm. Default 100{p_end}

{syntab: {it:Smoothed}}

{synopt :{opth itol(real)}} i-tolerance for the Gauss-Newton algorithm; default 1e-09. See {manhelp moptimize m-5}{p_end}
{synopt :{opth ptol(real)}} p-tolerance for the Gauss-Newton algorithm. default 1e-09. See {manhelp moptimize m-5}{p_end}
{synopt :{opt opt:gmm}}GMM with optimal weighting matrix in the second step of the smoothed estimator.{p_end}
{synopt :{opth maxiter(integer)}}Maximum number of iterations for the Gauss-Newton algorithm; default value is 1000{p_end}
{synopt :{opth from(matrix)}}Initial values for the gmm{p_end} 

{syntab: {it:Simulated annealing}}
{synopt :{opth T(real)}}Initial temperature; default value is 5.0{p_end}
{synopt :{opth r_T(real)}}Temperature cooling rate; default value is 0.4{p_end}
{synopt :{opth eps(integer)}}Tolerance for stopping the algorithm; default value 1e-5{p_end}
{synopt :{opth N_S(integer)}}Number of trials S; default value 5{p_end}
{synopt :{opth N_T(integer)}}Number of trials T; default value 5{p_end}
{synopt :{opth N_eps(real)}}N eps; default value 5{p_end}
{synopt :{opth max_iter(integer)}}Max number of iterations; default value 1000{p_end}
{synopt :{opth rho0(real)}}Initial value for the dependency parameter; default value is dependent of the copula and it 0.0 for the Gaussian and the Frank copula{p_end}
{synopt :{opth seed(integer)}}Set the seed for the simulated annealing{p_end}

{syntab: {it:ACMC}}
{synopt :{opth ndraws(numlist)}}Numbers of draws for each run of the AMCMC. Default values is 5000 in each run. It is recommanded to use higher values.{p_end}
{synopt :{opth nburns(numlist)}}Numbers of draws burned in each run. Default values 3000 and 1000.{p_end}
{synopt :{opth dampers(integer)}}Damping rates. Default values are 0.75 and 1.0{p_end}
{synopt :{opth arate(real)}}Acceptance rates in each run. Default values are 0.5 and 0.234{p_end}

{syntab:Inference}
{synopt :{opt vce}{cmd:(}[{it:{help ssivqreg##vtype:vtype}}]{cmd:,} [{it:{help ssivqreg##vopts:vopts}}]{cmd:)}}Specifies the method to estimate the standard-errors{p_end}
{synopt :{opt nostderr}}by-passes the computation of standard-errors. {*:Only relevant for the Arellano & Bonhomme's estimator}.{p_end}
{synoptset 30}{...}
{marker vtype}{...}

{synopthdr:vtype}
{synoptline}
{synopt :{opt as:ympotic}}asymptotic standard-errors; the default {p_end}
{synopt :{opt boot:strap}}bootstrap standard errors {p_end}

{*: syntab : Computation of analytical standard errors}
{synoptset 30}{...}
{marker vopts}{...}
{synopthdr :vopts}
{synoptline}
{synopt :{opt subsamp}}subsample size; integer default value full sample size {p_end}
{synopt :{opt reps}}number of bootstrap replications; integer default value 100{p_end}


{syntab: {it:Other options}}

{syntab : Pre-estimated copula parameter}
{synopt :{opth rho(real)}} you can supply the value for the copula parameter. 
goes directly to the third step.{p_end}

{syntab : Pre-estimated propensity score}
{synopt :{opth ps(varname)}} you can supply the propensity score of the model and
by-pass the first sted of the estimation {p_end}

{syntab : Options for displaying the output }
{synopt :{opt noshow}} does not show the output after estimation {p_end}

{synopt :{opt r:escale}}Rescale the covariates for the estimation. The covariates are demeaned and scaled by their standard deviation. After estimation the coefficients are scaled back and outputted to the user.{p_end}

{*:, the simulated annealing . Default 100}
{synopt :{opt logit}}First step estimated with a logit regression instead of a probit.{p_end}

{synopt :{opth bStep2(matrix)}}Supply the coefficient from the second step. Used in combination with the rho() option.{p_end}

{synopt :{opt log}}Show some log during the estimation procedure{p_end}

**# Description #2
{marker syntax}{...}
{title:Description}

{pstd}
This command estimates quantile regression models with sample selection and allows the presence 
of endogenous covariates appearing in the outcome equation. 
It follows the approach proposed by {help ssivqreg##Arellano_2017a: Arellano & Bonhomme, 2017}. 
The sample selection, i.e. the correlation between the unobserved factors driving the participation decision and the outcome of interest is modelled with the help of a copula. 
To deal with endogenous covariates, {cmd:ssivqreg} offers different estimation methods.{p_end} 
{pstd}
The first one is an extension of the GMM profiled estimator proposed by Arellano and Bonhomme (AB).
It is the default algorithm.
The estimator consists in two steps to estimate the dependency parameter. 
The first step is to estimate the propensity score of partipicating, whereas the second step consists in profiling the objective function. For given values of the dependency parameter {cmd:ssivqreg} estimates the quadratic form corresponding to the moment condition for this particular parameter and chooses the value giving the lowest value.
This second step involves to run a series of rotated quantile regressions, i.e. corrected for sample selection, which minimizes the other moments. 
In the presence of endogenous covariates, this second step is modified by using a rotated version of an instrumental variable quantile regression (IVQR).
We apply {help ssivqreg##Chernozhoukov_2008a: Chernozhoukov & Hansen (2008)}'s inverse quantile regression (IQR) approach.{p_end}

{pstd}
The second method available consists in smoothing the moment conditions of the moments, that is we approximate the moment conditions with a smoothing functions. 
Smoothing techniques have been applied for quantile models ({help ssivqreg##Kaplan_2017a:Kaplan and  Sun (2017)}, {help ssivqreg##Castro_2019a: Castro et al. (2019)}
and {help ssivqreg##Kaplan_2022a:Kaplan (2022)}).
We apply this idea to estimate the parameters of the model. 
From the smoothed moment condition we form a quadratic form, which we then minimize with the Gauss-Newton algorithm. This technique works best with just identified models.{p_end}

{pstd}
The third method available is the adaptive Monte Carlo Markov Chain algorithm ({help ssivqreg##Baker_2014a: Baker, 2014}). This bayesian technique in particular was suggested by {help ssivreg##Chernozhoukov_2003a:Chernozhoukov & Hong (2003)} 
for the quantile regression and can be applied to non-convex problems. Like other bayesian techniques it relies on sampling and baysesian updating.  
These three different techniques can be applied in the case of exogenous covariates.{p_end}

{pstd}
{cmd:ssivqreg} has three different syntaxes. Syntax 1 asumes that there is sample selection and all the covariates are exogenous. This syntax is close to {manhelp heckman R}.
Syntax 2 assumes that there is no sample selection, but allows the presence of endogenous covariates in the main equation. 
This syntax is close to commands involving instrumtal variables like {manhelp ivregress R} or the user-written package {help ivreg2}.
It follows the convention that the endogenous variables and the instruments are put between parentheses with an equal sign inbetween to distinguish the two.  
Compared to {manhelp ivqregress R} the main difference is that we use an interior point (Frisch-Newton) algorithm instead of the exterior point algorithm used by {manhelp qreg R}.
Syntax 3 assumes both sample selection and the presence of endogenous covariates in the main equation. 
This syntax combines syntax 1 and 2.  
{p_end}

{pstd}
Other techniques are available in the exogenous case.
The profiled GMM can be modified by using a one-step estimator to estimate the quantile process in the second step instead of quantile regression ({help ssivqreg##Chernozhoukov_2022a: Chernozhoukov et al., 2022)}).
The other technique is the simulated annealing ({help ssivqreg##Goffe_1994a: Goffe et al., 1994}) instead of a grid search. 
This algorithm is a deritave-free optimization algorithm designed to find the global optimum of non-convex and non-smoothed functions. This technique can also be applied with syntax 2.{p_end}

{pstd}
The commands {cmd:arhomme} by {help ssivqreg##Biewen_2021a: Biewen and Erhardt (2021) } and {cmd:qregsel} by {help ssivqreg##Muñoz_2021a: Muñoz and Siravegna (2021)} implement AB's profiled estimator in the case of exogenous regressors.
Both commands rely on bootstraping for inference and subsampling to speed up the process.
{cmd:ssivqreg} can compute analytical standard errors, but can also bootstrap standard-errors.
{p_end}



{title:Options for ssivqreg}

{dlgtab:Selection}

{phang3}
{cmdab:sel:ect}({it:{help depvar: depvar_s}} [=] {it:{help varlist: varlist_s}}) specifies the propensity score. The model is estimated by probit by default, bu you can estimate the model by logit with the logit option.

{dlgtab:Copula}

{phang3}
{cmdab: c:opula(string)} selects the copula. The following copulas are implemented: Frank, Gaussian, Plackett, Clayton, Gumbel and BB1. See {help ssivqreg##Joe_1997:Joe (1997)} for details about these copulas.
Both the Frank and the Gaussian copula allow positive and negative dependence. The BB1 is the generalized Frank copula. These three copulas have been used by {help ssivqreg##Arellano_2017a:Arellano and Bonhomme (2017a)}.
  

{dlgtab:Method}

{phang}{cmd:method(mtype , mopts )}

{phang3}
{cmd:method({ul:prof}ile)} selects the profiled GMM estimator proposed by  {help ssivqreg##Arellano_2017a:Arellano and Bonhomme (2017a)}{p_end}

{phang3}
{cmd:method({ul:gmm}sivqr)} selects the smoothed GMM estimator{p_end}

{phang3}
{cmd:method(sa)} selects the simulated annealing. {help ssivqreg##Goffe_1994a:Goffe et al. (1994)}{p_end}
 
{phang3}
{cmd:{ul:one}step} selects the onestep estimator{p_end}

{phang3}
{cmd:amcmc} select the amcmc algorithm to estimate the model. See  {help ssivqreg##Baker_2014a:Baker et al. (2014)}

{phang}
These five estimators can be used in the exogenous case. The profiled, smoothed and AMCMC algorithms can be used both in the exogenous and the endogenous case. Saiv can be used in the case of the IVQR (case with endogenous covariates without sample selection) instead of the grid search. The Simulated Annealing for the case with sample selection with endogenous variable is not implemented (yet).{p_end}
{*: dlgtab:IVQR model}
{*:phang}
{*:{opt nalpha(#)} [{it:integer}]}

{dlgtab:Inference}

{phang}
{cmd:ssivqreg} provides by default the analytical asymptotic standard errors based on the formulas derived by {help ssivqreg##Arellano_2017a: Arellano & Bonhomme, (2017a,2017b)}.
It is also possible to bootstrap the standard errors of the profiled and smoothed GMM. As the profiled GMM can be slow it is possible to use subsampling (or m-out-of-n bootstrap) to speed up the process.
{p_end}

{marker postestimation}{...}
{title:Post-estimation for ssivqreg}

{phang}
{cmd:predict} {dtype} {newvar} {ifin} [{cmd:,} {opt e:quation(eqno)}]
{p_end}

{marker remarks}{...}
{title:Remarks}

{phang}{it:IVQR}{p_end}


{pstd}
The implementation of the IVQR model follows Inverse Quantile Regression (IQR) approach by Chernozhoukov & Hansen (2005, 2006, 2008). 
It can be seen as a profiled GMM, since we use a grid search to minimize the minimize the quadratic form obtained from the moment conditions of the model. 
In the case where we assume sample selection, the quantile probabilities are rotated, i.e. corrected for sample selection and observation specific as suggested by Arellano and Bonhomme (2017a, 2017b). 
The coefficient of the endogenous variable is also found by grid search. 
The grid is evenly spaced with the end limits obtained as follows. 
{cmd: ssivqreg} first runs a linear regression of endogenous variable on the exogenous variables and computes a linear projection of the endgoneous variable bassed on the results of this model. 
For each quantile probability, {cmd: ssivqreg} runs quantile regressions for the outcome on the covariates of the model (X) and the linear projection. 
The end points of the grid are obtained by substracting 4 times the standard error of the coefficient for the prediction of the endogenous variable from the coefficient itself. 
The covariance for this quantile regression is corrected of sample selection by using Arellano and Bonhomme's formulas for the asympotic variance in the case where the dependency parameter is fixed.
See {help ssivqreg##Bingley_2025: Bingley et al. (2025)} and {help ssivqreg##Kolodziejczyk_2025: Kolodziejczyk et al. (2025)} for details.{p_end}


{phang}{it:Smoothing}{p_end}

{pstd}
Syntaxes (1) and (2) allow to estimate the model by using a smoothed version of the moment conditions of the model. 
Smoothing the moment conditions for quantile regressoion models has been used by various authors (See {help ssivqreg##Kaplan_2017a: Kaplan and Sun (2017)}
and {help ssivqreg##Castro_2019a: Castro et al. (2019)}).
We use the same smoothing function as {help ssivqreg##Kaplan_2022a:Kaplan (2022)}. 
As for the profiled gmm we need to compute several quantiles in order to identify the dependency parameter. A typical choice is to estimate the 9 deciles. 
For each quantile {cmd:ssivqreg} computes a smoothing parameter with the plugin estimator used by 
{help ssivqreg##Kaplan_2017a:Kaplan and  Sun (2017)}. 
From these smoothed moment conditions we form a quadratic form as a quadratic form. 
We estimate the parameters by minimizing this objective function  with the Gauss-Newton algorithm 
(see {manhelp moptimize m-5 }) with {manhelp optimize m-5}. 
We estimate the model in two steps. We supply the algorithm with initial values, compute the smoothing parameters with the plugin estimator and estimate the model. 
We then update the smoothing paramaters with the obtained coefficients and re-run the Gauss-Newton algorithm with the coefficients as initial values. 
See {help ssivqreg##Bingley_2025: Bingley et al. (2025)} and {help ssivqreg##Kolodziejczyk_2025: Kolodziejczyk et al. (2025)} for details.{p_end}

{pstd}{it:AMCMC}{p_end}

{pstd}{it:Simulated annealing}{p_end}

{pstd}{it:Algorithm for the quantile regression}{p_end}

{pstd}{it:Analytical standard-errors}{p_end}
 
{pstd}

{marker examples}{...}
{title:Examples}

{pstd}Generate data for the with exogenous covariates only{p_end}
{phang2}. {stata dgp_ssivqreg , n(10000) rho(-0.2) copula(Gaussian) model(exog) seed(1010101)}{p_end}

{pstd}Estimate the model with the smooth estimator and 9 quantiles{p_end}
{phang2}. {stata ssivqreg y d x1 x2, sel(p = d x1 x2 z zp) q(0.1(.1).9) gmm rescale log}{p_end}

{pstd}Estimate the model with the  profiled estimator, 9 quantiles and a grid with 101 points{p_end}
{phang2}. {stata ssivqreg y d x1 x2, sel(p = d x1 x2 z zp) q(0.1(.1).9) nrho(101) rescale log}{p_end}

{pstd}Estimate the model with the  profiled estimator, 9 quantiles and simulated annealing{p_end}
{phang2}. {stata ssivqreg y d x1 x2, sel(p = d x1 x2 z zp) q(0.1(.1).9) algo(sa) rescale log}{p_end}



{pstd}Generate data with 1 endogenous covariate (d){p_end}
{phang2}. {stata dgp_ssivqreg , n(10000) rho(-0.2) copula(Gaussian) model(endog) seed(1010101)}{p_end}

{pstd}Estimate the model with the smooth estimator and 9 quantiles{p_end}
{phang2}. {stata ssivqreg y (d=z) x1 x2, sel(p = x1 x2 z zp) q(0.1(.1).9) gmm rescale log}{p_end}

{pstd}Estimate the model with the profiled estimator and 9 quantiles{p_end}
{phang2}. {stata ssivqreg y (d=z) x1 x2, sel(p = x1 x2 z zp) q(0.1(.1).9) nrho(11) nalpha(11) rescale log}{p_end}

{title:Stored results}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}Number of observations{p_end}
{synopt:{cmd:e(N1)}}Number of selected observations{p_end}
{synopt:{cmd:e(modelType)}}Model type{p_end}
{synopt:{cmd:e(min_objFunc)}}Minimum of the obejctive function{p_end}
{synopt:{cmd:e(nrho)}}Number of grid-points for the copula parameter(s){p_end}
{synopt:{cmd:e(SpearmanCorr) }}Spearman correlation coefficient{p_end}
{synopt:{cmd:e(KendalTau)}}Kendall's tau{p_end}
{synopt:{cmd:e(AB_objfnc)}}Arellano-Bonhomme objective funtion{p_end}
{synopt:{cmd:e(ss_stat)}}Sample selection statistice  (AB, 2017){p_end}
{synopt:{cmd:e(ke)}}Number of endogenous variables{p_end}
{synopt:{cmd:e(kx)}}Number of exogenous variables{p_end}
{synopt:{cmd:e(kz)}}Number of variables in the selection equation{p_end}
{synopt:{cmd:e(kw)}}Number of instrumental variables for the endogenous variables {p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:ssivqreg}{p_end}
{synopt:{cmd:e(cmdline)}}Command as typed{p_end}
{synopt:{cmd:e(depvar)}}Name of dependent variable{p_end}
{synopt:{cmd:e(xvar)}}List of exogenous variables{p_end}
{synopt:{cmd:e(selvar)}}List of variables for the selection equation{p_end}
{synopt:{cmd:e(psvar)}}Variable name for the propensity score{p_end}
{synopt:{cmd:e(title)}}{p_end}
{synopt:{cmd:e(predict)}}program used to implement predict{p_end}
{synopt:{cmd:e(quantiles)}}numlist of quantiles{p_end}
{synopt:{cmd:e(copula)}}Chosen copula{p_end}
{synopt:{cmd:e(properties)}}b{p_end}
		
{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}Coefficient vector{p_end}
{synopt:{cmd:e(V)}}Variance-covariance matrix{p_end}
{synopt:{cmd:e(taus)}}List of quantiles estimated{p_end}
{synopt:{cmd:e(b_quant)}}Beta's coefficients stored in a matrix with one column for each quantile{p_end}
{synopt:{cmd:e(objFunc)}}Vector with the values of the objective function for each value of the copula parameter grid{p_end}
{synopt:{cmd:e(grid_rho)}}Matrix with the values of the grid for the copula parameters{p_end} 

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}Marks estimation sample{p_end}



{marker references}{...}
{title:References}

INCLUDE help ssivqreg_ref
{*: Baker, 2014}
{*: biewen Erhardt, 2021}
{*: Chernozhoukov & Hansen}
{*:{marker AB2017}{...}}
{*:{phang}}
{*:{Arellano, M. and Bonhomme, S. 2017.}}
{*:Quantile Selection Models with an application to understanding changes in wage inequality.}
{*:{it:Econometrica} 85(1): 1-28.}
{*:{p_end}}

