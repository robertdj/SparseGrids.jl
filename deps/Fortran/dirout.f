C Output from Public domain Ratfor, version 1.0
      subroutine dirout(dirsum,nadj,madj,x,y,ntot,npd,rw,ind,eps,nerror)
      implicit double precision(a-h,o-z)
      dimension nadj(-3:ntot,0:madj), x(-3:ntot), y(-3:ntot)
      dimension dirsum(npd,3), ind(npd), rw(4)
      logical collin, intfnd, bptab, bptcd, rwu
      xmin = rw(1)
      xmax = rw(2)
      ymin = rw(3)
      ymax = rw(4)
      do23000 i1 = 1,npd 
      area = 0.
      nbpt = 0
      npt = 0
      i = ind(i1)
      np = nadj(i,0)
      do23002 j1 = 1,np 
      j = nadj(i,j1)
      call pred(k,i,j,nadj,madj,ntot,nerror)
      if(nerror .gt. 0)then
      return
      endif
      call succ(l,i,j,nadj,madj,ntot,nerror)
      if(nerror .gt. 0)then
      return
      endif
      call circen(i,k,j,a,b,x,y,ntot,eps,collin,nerror)
      if(nerror.gt.0)then
      return
      endif
      if(collin)then
      nerror = 13
      return
      endif
      call circen(i,j,l,c,d,x,y,ntot,eps,collin,nerror)
      if(nerror.gt.0)then
      return
      endif
      if(collin)then
      nerror = 13
      return
      endif
      call stoke(a,b,c,d,rw,tmp,sn,eps,nerror)
      if(nerror .gt. 0)then
      return
      endif
      area = area+sn*tmp
      xi = x(i)
      xj = x(j)
      yi = y(i)
      yj = y(j)
      if(yi.ne.yj)then
      slope = (xi - xj)/(yj - yi)
      rwu = .true.
      else
      slope = 0.d0
      rwu = .false.
      endif
      call dldins(a,b,slope,rwu,ai,bi,rw,intfnd,bptab)
      if(intfnd)then
      call dldins(c,d,slope,rwu,ci,di,rw,intfnd,bptcd)
      if(.not.intfnd)then
      nerror = 17
      return
      endif
      if(bptab .and. bptcd)then
      xm = 0.5*(ai+ci)
      ym = 0.5*(bi+di)
      if(xmin.lt.xm.and.xm.lt.xmax.and.ymin.lt.ym.and.ym.lt.ymax)then
      nbpt = nbpt+2
      npt = npt+1
      endif
      else
      npt = npt + 1
      if(bptab .or. bptcd)then
      nbpt = nbpt+1
      endif
      endif
      endif
23002 continue
23003 continue
      dirsum(i1,1) = npt
      dirsum(i1,2) = nbpt
      dirsum(i1,3) = area
23000 continue
23001 continue
      return
      end
