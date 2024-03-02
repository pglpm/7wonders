
tdur <- 2
dt <- 0.1
M <- 4
P0 <- 30
r0 <- 2
F <- 0
##
g <- -9.80665
G <- M*g
nsteps <- tdur/dt
##
v <- r <- P <- t <- numeric(nsteps)
t[1] <- 0
P[1] <- P0
r[1] <- r0
v[1] <- P0/M
for(i in 1:(nsteps-1)){
    t[i+1] <- t[i] + dt
    r[i+1] <- r[i] + v[i]*dt
    P[i+1] <- P[i] + (F + G)*dt
    v[i+1] <- P[i+1]/M
}
##
cbind(t[1:3],r=r[1:3],P=P[1:3],v=v[1:3])
pdff('plot_tennisball',portrait=TRUE)
tplot(t,r,xlab=bquote(italic(t)/"s"),ylab=bquote(italic(z)(italic(t))/"s"),type='b',mar=c(NA,NA,0,0))
dev.off()
