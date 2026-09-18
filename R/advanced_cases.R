# Semua data di sini sintetis. Jalankan dari akar proyek.
# SBM diimplementasikan dengan transformasi Charnes-Cooper, bukan rasio numerik iteratif.
dir.create('results',showWarnings=FALSE); dir.create('data',showWarnings=FALSE)
sbm <- function(X,Y,B=NULL,vrs=FALSE) {
 X<-as.matrix(X);Y<-as.matrix(Y)
 if(is.null(B))B<-matrix(numeric(0),nrow(X),0) else B<-as.matrix(B)
 n<-nrow(X);m<-ncol(X);s<-ncol(Y);h<-ncol(B)
 stopifnot(all(X>0),all(Y>0),all(B>0),nrow(Y)==n)
 out<-vector('list',n)
 for(o in seq_len(n)) {
  il<-seq_len(n);ix<-n+seq_len(m);iy<-n+m+seq_len(s)
  ib<-if(h)n+m+s+seq_len(h) else integer(0);it<-n+m+s+h+1L
  A<-matrix(0,m+s+h+1+as.integer(vrs),it);rhs<-rep(0,nrow(A));rr<-0
  for(k in seq_len(m)){rr<-rr+1;A[rr,il]<-X[,k]/X[o,k];A[rr,ix[k]]<-1/X[o,k];A[rr,it]<--1}
  for(k in seq_len(s)){rr<-rr+1;A[rr,il]<-Y[,k]/Y[o,k];A[rr,iy[k]]<--1/Y[o,k];A[rr,it]<--1}
  if(h)for(k in seq_len(h)){rr<-rr+1;A[rr,il]<-B[,k]/B[o,k];A[rr,ib[k]]<-1/B[o,k];A[rr,it]<--1}
  rr<-rr+1;A[rr,it]<-1;A[rr,iy]<-1/(s*Y[o,]);if(h)A[rr,ib]<-1/(h*B[o,]);rhs[rr]<-1
  if(vrs){rr<-rr+1;A[rr,il]<-1;A[rr,it]<--1}
  obj<-numeric(it);obj[it]<-1;obj[ix]<--1/(m*X[o,])
  fit<-lpSolve::lp('min',obj,A,rep('=',nrow(A)),rhs)
  stopifnot(fit$status==0,max(abs(A%*%fit$solution-rhs))<1e-5)
  tau<-fit$solution[it];stopifnot(tau>0)
  lam<-fit$solution[il]/tau
  out[[o]]<-list(score=fit$objval,x_target=drop(t(X)%*%lam),y_target=drop(t(Y)%*%lam),
                 b_target=if(h)drop(t(B)%*%lam) else numeric(),lambda=lam)
 }
 stopifnot(all(vapply(out,function(z)z$score,0)>-1e-7),all(vapply(out,function(z)z$score,0)<=1+1e-6))
 out
}
set.seed(22092026)
n<-60
green<-data.frame(id=sprintf('HIJAU-%03d',1:n),beds=sample(60:250,n,TRUE),electricity_mwh=runif(n,500,1800))
green$inpatients<-round((green$beds*25+green$electricity_mwh*2)*runif(n,.65,1))
green$outpatients<-round(green$inpatients*runif(n,3,6))
green$co2_tonnes<-round(green$electricity_mwh*runif(n,.3,.95),2)
write.csv(green,'data/rs-hijau-sintetis.csv',row.names=FALSE)
g<-sbm(green[c('beds','electricity_mwh')],green[c('inpatients','outpatients')],green['co2_tonnes'])
g0<-sbm(green[c('beds','electricity_mwh')],green[c('inpatients','outpatients')])
green_result<-data.frame(id=green$id,sbm_tanpa_emisi=sapply(g0,`[[`,'score'),sbm_dengan_emisi=sapply(g,`[[`,'score'),
                       co2_awal=green$co2_tonnes,co2_target=sapply(g,function(z)z$b_target[1]))
stopifnot(all(green_result$co2_target<=green_result$co2_awal+1e-5))
write.csv(green_result,'results/advanced-green.csv',row.names=FALSE)
# Kesetaraan SBM biasa dengan paket independen.
dd<-deaR::make_deadata(data.frame(id=green$id,green[c('beds','electricity_mwh','inpatients','outpatients')]),ni=2,no=2)
ref<-as.numeric(deaR::efficiencies(deaR::model_sbmeff(dd,orientation='no',rts='crs')))
stopifnot(max(abs(ref-green_result$sbm_tanpa_emisi))<1e-5)
# Kasus Lean: dua periode pada frontier gabungan yang sama.
set.seed(23092026);n<-30
lean<-data.frame(id=sprintf('LEAN-%02d',1:n),period='sebelum',fte=runif(n,50,150),hours=runif(n,1200,3000))
lean$visits<-round((lean$fte*20+lean$hours)*runif(n,.65,1))
lean$completed<-round(lean$visits*runif(n,.7,.95))
post<-lean;post$period<-'sesudah';post$visits<-round(post$visits*1.1);post$completed<-round(post$completed*1.12)
both<-rbind(lean,post);both$key<-paste(both$id,both$period,sep='_')
l<-sbm(both[c('fte','hours')],both[c('visits','completed')],vrs=TRUE)
lr<-data.frame(id=both$id,period=both$period,score=sapply(l,`[[`,'score'),
               visits=both$visits,visits_target=sapply(l,function(z)z$y_target[1]),
               fte=both$fte,fte_target=sapply(l,function(z)z$x_target[1]))
stopifnot(all(lr$score[31:60]>=lr$score[1:30]-1e-6))
write.csv(both,'data/lean-sintetis.csv',row.names=FALSE);write.csv(lr,'results/advanced-lean.csv',row.names=FALSE)
# Model jaringan bintang latihan: logistik -> tiga unit layanan.
# Setiap simpul memiliki lambda sendiri; arus perantara harus sama pada kedua ujung.
set.seed(24092026);n<-40
net<-data.frame(id=sprintf('JEJARING-%02d',1:n),logistics_fte=runif(n,10,25))
for(k in 1:3){net[[paste0('fte',k)]]<-runif(n,15,40);net[[paste0('link',k)]]<-round(net$logistics_fte*runif(n,70,140));net[[paste0('service',k)]]<-round(pmin(net[[paste0('link',k)]],net[[paste0('fte',k)]]*80)*runif(n,.55,.95))}
network_fit<-function(d) {
 n<-nrow(d);X<-as.matrix(d[c('logistics_fte','fte1','fte2','fte3')]);Y<-as.matrix(d[paste0('service',1:3)]);Z<-as.matrix(d[paste0('link',1:3)])
 score<-numeric(n)
 for(o in 1:n){nv<-4*n+1;A<-matrix(0,0,nv);dirs<-character();rhs<-numeric()
  add<-function(v,dir,b){A<<-rbind(A,v);dirs<<-c(dirs,dir);rhs<<-c(rhs,b)}
  for(p in 0:3){ii<-p*n+1:n;v<-numeric(nv);v[ii]<-X[,p+1]/X[o,p+1];v[nv]<--1;add(v,'<=',0)
   v<-numeric(nv);v[ii]<-1;add(v,'=',1)
   if(p>0){v<-numeric(nv);v[ii]<-Y[,p]/Y[o,p];add(v,'>=',1)
    v<-numeric(nv);v[1:n]<-Z[,p]/Z[o,p];v[ii]<--Z[,p]/Z[o,p];add(v,'=',0)}
  }
  obj<-numeric(nv);obj[nv]<-1;f<-lpSolve::lp('min',obj,A,dirs,rhs)
  stopifnot(f$status==0);res<-drop(A%*%f$solution)-rhs
  stopifnot(all(abs(res[dirs=='='])<1e-6),all(res[dirs=='<=']<1e-6),all(res[dirs=='>=']> -1e-6))
  score[o]<-f$objval
 }
 stopifnot(all(score>0),all(score<=1+1e-6));score
}
ns<-network_fit(net)
nr<-data.frame(id=net$id,theta_network=ns)
for(p in 1:3)nr[[paste0('theta_unit',p)]]<-Benchmarking::dea(as.matrix(net[c(paste0('fte',p),paste0('link',p))]),as.matrix(net[paste0('service',p)]),RTS='vrs',ORIENTATION='in')$eff
write.csv(net,'data/jaringan-sintetis.csv',row.names=FALSE);write.csv(nr,'results/advanced-network.csv',row.names=FALSE)
# Niedar: struktur tiga input tenaga dan empat output cakupan; bukan data artikel.
set.seed(25092026);n<-120
pc<-data.frame(id=sprintf('KAB-S%03d',1:n),region=rep(c('Barat','Tengah','Timur'),each=40),
 doctors_100k=runif(n,15,45),nurses_100k=runif(n,80,200),midwives_100k=runif(n,50,160))
potential<-(pc$doctors_100k/45+pc$nurses_100k/200+pc$midwives_100k/160)/3
for(v in c('outpatient_pct','anc4_pct','birth_assisted_pct','immunization_pct'))pc[[v]]<-round(20+70*potential*runif(n,.55,1),2)
XX<-as.matrix(pc[3:5]);YY<-as.matrix(pc[6:9]);pf<-Benchmarking::dea(XX,YY,RTS='vrs',ORIENTATION='out')
pr<-data.frame(id=pc$id,region=pc$region,phi=pf$eff,potential_pct=100*(pf$eff-1),anc4=pc$anc4_pct,anc4_target=pc$anc4_pct*pf$eff)
stopifnot(all(pf$eff>=1-1e-7),all(YY*pf$eff<=100+1e-6))
write.csv(pc,'data/layanan-primer-sintetis.csv',row.names=FALSE);write.csv(pr,'results/advanced-niedar.csv',row.names=FALSE)
# Tambahan: super-efficiency dan metafrontier dengan konvensi input.
d<-read.csv('data/fasilitas-sintetis.csv');X<-as.matrix(d[c('staff_fte','beds')]);Y<-as.matrix(d['discharges'])
su<-Benchmarking::sdea(X,Y,RTS='crs',ORIENTATION='in')$eff
stopifnot(all(is.finite(su)),all(su>0))
groups<-ifelse(d$beds<100,'Kapasitas kecil','Kapasitas besar')
meta<-Benchmarking::dea(X,Y,RTS='vrs',ORIENTATION='in')$eff;grp<-numeric(nrow(d))
for(gp in unique(groups)){ii<-which(groups==gp);grp[ii]<-Benchmarking::dea(X[ii,,drop=FALSE],Y[ii,,drop=FALSE],RTS='vrs',ORIENTATION='in')$eff}
stopifnot(all(meta<=grp+1e-6))
write.csv(data.frame(id=d$id,super_crs=su,group=groups,theta_group=grp,theta_meta=meta,TGR=meta/grp),'results/advanced-meta-super.csv',row.names=FALSE)
writeLines(c('PASS SBM tanpa emisi dibanding deaR: selisih < 1e-5',
 'PASS SBM target emisi tidak melebihi emisi awal; semua LP optimal dan residual < 1e-5',
 'PASS Lean: skor sesudah >= sebelum pada frontier gabungan yang sama',
 'PASS jaringan: semua LP optimal, neraca link dan kendala diperiksa',
 'PASS layanan primer: phi >= 1 dan seluruh target cakupan <= 100%',
 'PASS super-efficiency CRS finite; theta meta <= theta kelompok',
 'Semua angka sintetis; bukan replikasi hasil empiris artikel.'),'results/advanced-tests.txt')
capture.output(sessionInfo(),file='results/advanced-sessionInfo.txt')
