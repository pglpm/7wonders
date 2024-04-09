
tdur <- 2
dt <- 0.01#0.1
M <- 0.059#4
P0 <- 3#30
r0 <- 2#5
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
for(i in 1:(nsteps)){
    t[i+1] <- t[i] + dt
    r[i+1] <- r[i] + v[i]*dt
    P[i+1] <- P[i] + (F + G)*dt
    v[i+1] <- P[i+1]/M
}

##
pdff('plot_tennisball_z',portrait=TRUE)
tplot(t,r,xlab=bquote(italic(t)/"s"),ylab=bquote(italic(z)(italic(t))/"s"),type='b',lwd=3,mar=c(NA,NA,1,0))
dev.off()
pdff('plot_tennisball_P',portrait=TRUE)
tplot(t,P,xlab=bquote(italic(t)/"s"),ylab=bquote(italic(P)[italic(z)](italic(t))/"Ns"),type='b',lwd=3,mar=c(NA,NA,1,0))
dev.off()
pdff('plot_tennisball_v',portrait=TRUE)
tplot(t,v,xlab=bquote(italic(t)/"s"),ylab=bquote(italic(v)[italic(z)](italic(t))/"m/s"),type='b',lwd=3,mar=c(NA,NA,1,0))
dev.off()

cbind(t,r=r,P=P,v=v)


#### Earth orbit

tdur <- 3*366*24*3600
dt <- 360
M <- 5.9722e24
Msun <- 1988500e24
P0 <- M * c(0, 30.29e3)
r0 <- c(147.095e9, 0)
F <- 0
gg <- 6.67408e-11
Gforce <- function(r){
    -gg*Msun*M*r/(sum(r^2)^(3/2))
}
##
nsteps <- tdur/dt
##
v <- r <- P <- t <- matrix(NA,nsteps,2)
t[1,] <- 0
P[1,] <- P0
r[1,] <- r0
v[1,] <- P0/M
for(i in 1:(nsteps-1)){
    t[i+1,] <- t[i,] + dt
    r[i+1,] <- r[i,] + v[i,]*dt
    P[i+1,] <- P[i,] + Gforce(r[i,])*dt
    v[i+1,] <- P[i+1,]/M
}
au <- 149597870691
toplot <- round(seq(1,nsteps,length.out=tdur/3600))
tplot(r[toplot,1]/au,r[toplot,2]/au,xlab="x",ylab="y",type='l',asp=1)
tplot(0,0,type='p',pch=16,cex=3,col=yellow,add=T)



##
pdff('plot_tennisball_z',portrait=TRUE)
tplot(t,r,xlab=bquote(italic(t)/"s"),ylab=bquote(italic(z)(italic(t))/"s"),type='b',lwd=3,mar=c(NA,NA,1,0))
dev.off()
pdff('plot_tennisball_P',portrait=TRUE)
tplot(t,P,xlab=bquote(italic(t)/"s"),ylab=bquote(italic(P)[italic(z)](italic(t))/"Ns"),type='b',lwd=3,mar=c(NA,NA,1,0))
dev.off()
pdff('plot_tennisball_v',portrait=TRUE)
tplot(t,v,xlab=bquote(italic(t)/"s"),ylab=bquote(italic(v)[italic(z)](italic(t))/"m/s"),type='b',lwd=3,mar=c(NA,NA,1,0))
dev.off()

cbind(t,r=r,P=P,v=v)


n0 <- 1e-12
t2 <- 5700
n <- n0
nnow <- 2e-13
t <- 0
dt <- 1/365
lam <- log(2)/t2
while(n > nnow){
    t <- t+dt
    n <- n - lam*n*dt
}
print(t)
print(n)
