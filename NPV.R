calc_NPV <- function(annual_revenue, i=0.05, lifetime_yrs, CAPEX, OPEX=0){
  costs_op <- rep(OPEX, lifetime_yrs) #operating cost
  revenue <- rep(annual_revenue, lifetime_yrs) 
  t <- seq(1, lifetime_yrs, 1) #output: 1, 2, 3, ...25
  
  NPV <- sum( (revenue - costs_op)/(1 + i)**t ) - CAPEX
  return(round(NPV, 0))
}

# 计算NPV
npv_result <- calc_NPV(annual_revenue = 6747397271, i = 0.05, lifetime_yrs = 25, CAPEX = 41507103376, OPEX = 0)
ifelse(npv_result>0, "Support","obeject" )
# 打印结果
print(npv_result)



Life_span_generation_kWH <- function (yearly_generation_kWH, discount = 0.03, lifetime_yrs = 25){
  t<- seq(1, lifetime_yrs, 1)
  L_S_G <- sum(yearly_generation_kWH/(1+discount)**t)
  return (round(L_S_G,0))
}

#NPV of cost. 
#If you don't consider the operational cost, you can just use CAPEX as proxy for NPV of cost
LCOE <- function(NPV_cost,Life_span_generation){
  lcoe <- NPV_cost/Life_span_generation
  return(round(lcoe,2))
}


annual= 65508711365 #kwh 
lsg = Life_span_generation_kWH(yearly_generation_kWH=annual)
lsg


npv_cost = 41507103376

lcoe = LCOE(npv_cost, lsg)
lcoe 

