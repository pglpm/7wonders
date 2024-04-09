pdff('uplot',portrait=F);tplot(x=1:256,y=1:256,xlabels=NA,ylabels=NA,xlim=c(NA,NA),ylim=c(-50,NA),xlab=bquote(italic(t)),ylab=bquote(italic(u)[italic(x)]),lwd=4,cex.lab=4,mar=c(NA,4,NA,1),ly=1,family='Palatino');dev.off()

pdff('wplot',portrait=F);tplot(x=1:256,y=sin(2*pi*(1:256)/75+5),xlabels=NA,ylabels=NA,xlab=bquote(italic(t)),ylab=bquote(italic(w)[italic(x)]),lwd=4,cex.lab=4,ly=1,mar=c(NA,4,NA,1),family='Palatino');abline(h=0,lwd=3);dev.off()
